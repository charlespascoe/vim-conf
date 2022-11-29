import re

hexstrs = ["00", "5f", "87", "af", "d7", "ff"]
greyscale = [
    "#080808",
    "#121212",
    "#1c1c1c",
    "#262626",
    "#303030",
    "#3a3a3a",
    "#444444",
    "#4e4e4e",
    "#585858",
    "#626262",
    "#6c6c6c",
    "#767676",
    "#808080",
    "#8a8a8a",
    "#949494",
    "#9e9e9e",
    "#a8a8a8",
    "#b2b2b2",
    "#bcbcbc",
    "#c6c6c6",
    "#d0d0d0",
    "#dadada",
    "#e4e4e4",
    "#eeeeee",
]


def ansi256_to_hex(x):
    if x < 16:
        raise Error("Colours below 16 are terminal-specific")

    if x >= 232:
        return greyscale[x - 232]

    x -= 16

    b = x % 6
    x //= 6
    g = x % 6
    x //= 6
    r = x

    return "#" + hexstrs[r] + hexstrs[g] + hexstrs[b]


def hex_to_ansi256(s):
    r, g, b = _decode_hex(s)

    return _best_match(r) * 6**2 + _best_match(g) * 6 + _best_match(b) + 16


def hex_to_ansirgb(s, fg=True):
    r, g, b = _decode_hex(s)
    sig = 38 if fg else 48

    return f"{sig};2;{r};{g};{b}"


def _best_match(comp):
    return min(enumerate(abs(int(h, 16) - comp) for h in hexstrs), key=lambda i: i[1])[
        0
    ]


def _decode_hex(s):
    match = re.match(r"^#([A-Fa-f0-9]{2})([A-Fa-f0-9]{2})([A-Fa-f0-9]{2})$", s)

    if not match:
        raise Error("Not valid hex colour code")

    r = int(match[1], 16)
    g = int(match[2], 16)
    b = int(match[3], 16)

    return r, g, b
