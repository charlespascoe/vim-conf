import vim
import re

bullet_re = re.compile(r"^(\s{4})*[-*] ")
repeated_ws_re = re.compile(r"(?<=[^ \t])\s{2,}(?=[^ \t])")


def join():
    lines = []
    para = []

    for line in vim.current.buffer:
        if line != "" and not bullet_re.match(line):
            para.append(line)
            continue

        if len(para) > 0:
            lines.append(" ".join(para))
            para = []

        if line != "":
            para.append(line)
        else:
            lines.append("")

    if len(para) > 0:
        lines.append(" ".join(para))

    return "\n".join(repeated_ws_re.sub(" ", line) for line in lines)
