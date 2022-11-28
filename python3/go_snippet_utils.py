import re
import vim
from snippet_utils import *


import_re = re.compile(r"^import \($")
end_import_re = re.compile(r"^\)$")
quoted_string_re = re.compile(r'"(([^"]|\\.)+)"')


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
