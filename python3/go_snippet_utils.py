import re
import vim
from snippet_utils import *
from dataclasses import dataclass


import_re = re.compile(r"^import \($")
end_import_re = re.compile(r"^\)$")
quoted_string_re = re.compile(r'"(([^"]|\\.)+)"')
method_re = re.compile(r"^func \((?:(\w+)\s+)?([^)]+)\)\s+(\w+)\(")
type_re = re.compile(r"^type (\w+)")


@dataclass
class MethodMatch:
    rec_name: str
    rec_type: str
    name: str
    real: bool = True

    def __str__(self):
        return f"{self.rec_name} {self.rec_type}".strip()


@dataclass
class TypeMatch:
    name: str


def match_method(line):
    match = method_re.match(line)

    if match:
        return MethodMatch(match[1], match[2], match[3])

    return None


def match_type(line):
    match = type_re.match(line)

    if match:
        return TypeMatch(match[1])

    return None


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
    # Why am I using GoImport again? Do I need this?

    if isinstance(imports, str):
        imports = [imports]

    for imp in imports:
        parts = imp.split(" ")

        if len(parts) > 1:
            alias, path = parts[0], parts[1]
            vim.command(f"GoImportAs {alias} {path}")
        else:
            vim.command(f"GoImport {imp}")


def find_method_type(pointer=False):
    m = scan(preceeding_lines(), match_method, match_type)

    method = MethodMatch("", "nil", "", real=False)

    if isinstance(m, MethodMatch):
        method = m

    if isinstance(m, TypeMatch):
        m2 = scan(following_lines(), match_method)
        if m2:
            method = m2
        else:
            method = MethodMatch(m.name[0].lower() + m.name[1:], m.name, "", real=False)

    if pointer and not method.rec_type.startswith("*"):
        method.rec_type = "*" + method.rec_type

    return method
