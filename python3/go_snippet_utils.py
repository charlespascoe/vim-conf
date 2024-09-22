import re
import vim
from snippet_utils import *
from dataclasses import dataclass
from typing import List
from os import path


camel_case_re = re.compile(r"[A-Z]?[a-z]+|[A-Z]+(?=$|[A-Z][a-z])")
ws_re = re.compile(r"\s+")
import_re = re.compile(r"^import \($")
end_import_re = re.compile(r"^\)$")
quoted_string_re = re.compile(r'"(([^"]|\\.)+)"')
func_re = re.compile(r"^func (\w+)\(")
test_re = re.compile(r"^func Test([^(]*)\(")
method_re = re.compile(r"^func \((?:(\w+)\s+)?([^)]+)\)\s+(\w+)[\[(]")
generic_type_re = re.compile(r"(\w+)(?:\[(.*)\])?")
type_re = re.compile(r"^type (\w+)(?:\[(.*)\])? ")
package_re = re.compile(r"^package (\w+)")


@dataclass
class Package:
    name: str

    def __str__(self):
        return self.name

    @classmethod
    def match(cls, line: str):
        match = package_re.match(line)

        return Package(match[1]) if match else None


@dataclass
class FunctionMatch:
    name: str

    def __str__(self):
        return self.name


@dataclass
class TestFunctionMatch:
    name: str
    parts: List[str]

    def __str__(self):
        return self.name


@dataclass
class TypeMatch:
    name: str
    type_params: List[str]

    def __str__(self):
        params = ",".join(self.type_params)

        if params:
            return f"{self.name}[{params}]"

        return self.name

    @classmethod
    def from_string(self, string):
        match = generic_type_re.match(string)

        if not match:
            return TypeMatch(string, [])

        type_params = []

        if match[2]:
            type_params = [ws_re.split(part.strip())[0] for part in match[2].split(",")]

        return TypeMatch(match[1], type_params)


@dataclass
class MethodMatch:
    rec_name: str
    rec_type: TypeMatch
    rec_ptr: bool
    name: str
    real: bool = True

    def __str__(self):
        # TODO figure out if I can remove this because it's not correct
        return f"{self.rec_name} {self.rec_type_str}".strip()

    @property
    def rec_type_str(self):
        return f"{'*' if self.rec_ptr else ''}{self.rec_type}"


def match_func(line):
    match = func_re.match(line)

    if match:
        return FunctionMatch(match[1])

    return None


def match_test(line):
    match = test_re.match(line)

    if match:
        name = match[1]
        parts = [part for part in name.split("_") if len(part) > 0]
        return TestFunctionMatch(name, parts)

    return None


def match_method(line):
    match = method_re.match(line)

    if not match:
        return None

    rec_ptr = False
    type_str = match[2].strip()

    if type_str.startswith("*"):
        type_str = type_str[1:]
        rec_ptr = True

    if match[1] is None:
        # Receiver is not named, i.e. type ony
        return type_to_method(TypeMatch.from_string(type_str), rec_ptr)

    return MethodMatch(
        match[1].strip(),
        TypeMatch.from_string(type_str),
        rec_ptr,
        match[3].strip(),
    )


def match_type(line):
    match = type_re.match(line)

    if not match:
        return None

    type_params = []

    if match[2]:
        type_params = [ws_re.split(part.strip())[0] for part in match[2].split(",")]

    return TypeMatch(match[1], type_params)


def add_import(snip, *imports):
    imports = list(imports)

    index = find_line(import_re)

    if index is None:
        go_import(imports)
        silence_buffer_mutation_errors(snip)
        return

    for i in range(index + 1, len(vim.current.window.buffer)):
        line = vim.current.window.buffer[i].strip().replace('"', "")

        imports = [imp for imp in imports if imp != line]

        if line == ")":
            if len(imports) > 0:
                # End of imports - not found, so just add it
                go_import(imports)
                silence_buffer_mutation_errors(snip)

            return


def get_imports(buf=None):
    if buf is None:
        buf = current.buffer

    start = buf.find_line(import_re)

    if start is None:
        return None

    end = buf.find_line(end_import_re, start[0])

    if end is None:
        return None

    start_line = start[0]
    end_line = end[0]

    for _, match in search(quoted_string_re, buf[start_line + 1 : end_line]):
        yield match[1]


def get_package_name():
    _, match = next(search(package_re, current.buffer), None)

    if match:
        return match[1]

    return ""


def get_all_imports():
    return {imp for buf in buffers for imp in get_imports(buf)}


def guess_import(pkg):
    for imp in get_all_imports():
        if imp.split("/")[-1] == pkg:
            return imp

    return None


def silence_buffer_mutation_errors(snip):
    # A **SUPER** hacky-hack that prevents UltiSnips from
    # complaining that the buffer has changed, even though I know
    # that the GoImport command won't affect the cursor position
    # relative to the snippet location. This may break at any time.
    snip.buffer._change_tick = int(vim.eval("b:changedtick"))


def go_import(imports):
    if isinstance(imports, str):
        imports = [imports]

    # TODO: Only install if it's not in go.mod (maybe grep the file?)

    install = False
    bang = "!" if install else ""

    for imp in imports:
        parts = imp.split(" ")

        if len(parts) > 1:
            alias, path = parts[0], parts[1]
            vim.command(f"GoImportAs{bang} {alias} {path}")
        else:
            vim.command(f"GoImport{bang} {imp}")


def each_leading_char_name(type_match: TypeMatch):
    matches = camel_case_re.findall(type_match.name)

    if not matches:
        return type_match.name

    return "".join(part.lower()[0] for part in matches)


def last_leading_char_name(type_match: TypeMatch):
    matches = camel_case_re.findall(type_match.name)

    if not matches:
        return type_match.name

    return matches[-1].lower()[0]


def type_to_method(type_match: TypeMatch, pointer: bool) -> MethodMatch:
    return MethodMatch(
        rec_name=last_leading_char_name(type_match),
        rec_type=type_match,
        rec_ptr=pointer,
        name="",
        real=False,
    )


def find_method_type(pointer=False):
    m = scan(preceeding_lines(), match_method, match_type)

    method = MethodMatch("", TypeMatch("", []), False, "", real=False)

    if isinstance(m, MethodMatch):
        method = m

    if isinstance(m, TypeMatch):
        m2 = scan(following_lines(), match_method)
        if m2 and m2.rec_type.name == m.name:
            method = m2
        else:
            method = type_to_method(m, pointer)

    if pointer and not method.rec_ptr:
        method.rec_ptr = True

    return method


def guess_test_name():
    # NOTE: It is VERY important that this function ALWAYS returns a non-empty
    # string, so that the snippet plugin doesn't run this function more than
    # once per template

    reg = vim.eval('@"')

    method = match_method(reg)

    if method:
        vim.command('let @" = ""')
        return f"_{method.rec_type.name}_{method.name}_"

    func = match_func(reg)

    if func and not func.name.startswith("Test"):
        vim.command('let @" = ""')
        return f"_{func.name}_"

    test = scan(preceeding_lines(), match_test)

    if test and len(test.parts) > 1:
        # All but the last item
        return "_" + "_".join(test.parts[:-1]) + "_"

    return "_"


def guess_godoc_string():
    if not is_empty(next(preceeding_lines(limit=1), "")):
        return ""

    match = scan(
        following_lines(limit=1),
        match_method,
        match_type,
        match_func,
        Package.match,
    )

    if not match:
        return ""

    if isinstance(match, Package):
        if match.name == "main":
            return f"Command {path.basename(path.dirname(vim.current.buffer.name))} "
        else:
            return f"Package {match.name} "

    return f"{match.name} "


def get_module_name(cwd=None):
    if cwd is None:
        # Use current file rather than Vim's cwd (e.g. when opening a file from
        # a different project)
        cwd = path.dirname(vim.current.buffer.name)

    mod_path = path.join(cwd, "go.mod")

    while cwd != "/" and not path.exists(mod_path):
        cwd = path.dirname(cwd)
        mod_path = path.join(cwd, "go.mod")

    if cwd == "/":
        return ""

    with open(mod_path) as f:
        for line in f:
            if line.startswith("module "):
                return line.split(" ")[1].strip()

    return ""
