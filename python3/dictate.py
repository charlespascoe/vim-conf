import vim
import re


def get_leading_comment():
    commentstring = vim.eval("&commentstring")

    if not commentstring:
        return ""

    l, r = commentstring.split(r"%s")

    l = l.strip()
    r = r.strip()

    lnum, col = vim.current.window.cursor

    prev = vim.current.buffer[lnum - 1][:col]

    if l not in prev:
        return ""

    start = prev.index(l)

    contents = [prev[start + len(l) :].strip()]

    if prev[:start].strip() != "":
        # Comment is at the end of some statement
        return contents[0]  # Like this

    lnum -= 1

    while lnum > 1:
        line = vim.current.buffer[lnum - 1].strip()

        if not line.startswith(l):
            break

        # TODO: Handle blank lines as paragraph separators etc.
        contents.append(line[len(l) :].strip())
        lnum -= 1

    return " ".join(contents[::-1])


def get_leading_paragraph():
    lnum, col = vim.current.window.cursor
    contents = [vim.current.buffer[lnum - 1][:col].strip()]

    lnum -= 1

    while lnum > 1:
        line = vim.current.buffer[lnum - 1].strip()

        if line == "":
            break

        contents.append(line)
        lnum -= 1

    return " ".join(contents[::-1])


string_re = re.compile("[\"'`]")


def get_leading_string():
    lnum, col = vim.current.window.cursor

    prev = vim.current.buffer[lnum - 1][:col]

    matches = list(string_re.finditer(prev))

    if len(matches) == 0:
        return ""

    match = matches[-1]

    return prev[match.span()[1] :]
