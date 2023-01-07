import vim
import re

bullet_re = re.compile(r"^(\s{4})*[-*] ")
repeated_ws_re = re.compile(r"(?<=[^ \t])\s{2,}(?=[^ \t])")


def join(start, end):
    return "\n".join(
        repeated_ws_re.sub(" ", line.rstrip())
        for line in merge(iter(vim.current.buffer[start - 1 : end]))
    )


def merge(buf_iter):
    for line in buf_iter:
        if line == "```":
            yield line
            yield from read_code(buf_iter)
        else:
            yield from read_block(line, buf_iter)


def read_code(buf_iter):
    for line in buf_iter:
        yield line

        if line == "```":
            return


def read_block(first, buf_iter):
    if first == "":
        yield ""
        return

    block = [first]

    for line in buf_iter:
        if line == "" or bullet_re.match(line):
            yield " ".join(block)
            yield from read_block(line, buf_iter)
            return

        block.append(line)

    yield " ".join(block)
