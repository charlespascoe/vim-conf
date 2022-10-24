import re
import vim


leading_whitespace_re = re.compile(r'^\s+')


def line_startswith(snip, s):
    if isinstance(s, re.Pattern):
        return s.search(snip.buffer[snip.line])
    else:
        return snip.buffer[snip.line].strip().startswith(s)


def line_endswith(snip, s):
    if isinstance(s, re.Pattern):
        return s.search(snip.buffer[snip.line])
    else:
        return snip.buffer[snip.line].strip().endswith(s)


def line_equals(snip, s):
    if isinstance(s, re.Pattern):
        return s.match(snip.buffer[snip.line])
    else:
        return snip.buffer[snip.line].strip() == s


def cursor_at_eol(snip):
    return len(snip.buffer[snip.line])-1 == snip.column


def after_cursor(snip, s):
    ac = snip.buffer[snip.line][snip.column+1:]
    print(ac)

    if isinstance(s, re.Pattern):
        return s.search(ac)
    else:
        return ac.strip().startswith(s)


def replace_rest_of_line(snip):
    l = snip.buffer[snip.line]
    snip.context = l[snip.column+1:].strip()

    ws_match = leading_whitespace_re.match(l)

    if ws_match is None:
        ws = ''
    else:
        ws = ws_match[0]

    snip.buffer[snip.line] = ws
    snip.cursor.set(snip.line, len(ws))


# Returns the zero-based index of the first line that matches the regexp
def find_line(regexp):
    for i in range(len(vim.current.window.buffer)):
        if regexp.search(vim.current.window.buffer[i]):
            return i

    return None


def find_lines(regexp):
    i = 0

    while i < len(vim.current.window.buffer):
        line = vim.current.window.buffer[i]

        if regexp.search(line):
            yield (i, line)

        i += 1


# Note that line is zero-based
def preceeding_lines(line=None):
    if line is None:
        line = vim.current.window.cursor[0] - 1

    l = line - 1

    while l >= 0:
        yield vim.current.window.buffer[l]
        l -= 1

# Note that line is zero-based
def following_lines(line=None):
    if line is None:
        line = vim.current.window.cursor[0] - 1

    l = line + 1

    while l < len(vim.current.window.buffer):
        yield vim.current.window.buffer[l]
        l += 1


def nonempty(strings):
    for string in strings:
        if string != '':
            yield string


def top_level(lines):
    for line in lines:
        if line != '' and not leading_whitespace_re.match(line):
            yield line

non_alphanum_underscore = re.compile(r'[^a-zA-Z0-9_]')


def jump():
	vim.command(r'call feedkeys("\<C-l>")')


def jump_after(ret):
    if ret:
        jump()

    return ret


def format_camel_case(s, cap_first=False):
    if s == "":
        return s

    print(f's: "{s}"')

    out = []

    cap = cap_first

    for word in non_alphanum_underscore.split(s):
        if not word:
            continue

        if cap:
            word = word[0].upper() + word[1:]

        out.append(word)

        cap = True

    return ''.join(out)


def format_snake_case(s, cap=False):
    if cap:
        s = s.upper()

    return '_'.join(word for word in non_alphanum_underscore.split(s) if word)


def start_dictation():
    vim.command('call dictate#Start()')

def get_syntax_name(pos, pattern, behind_pos=False):
    # NOTE: pos (in any form) must be zero-based
    if isinstance(pos, int):
        line = pos
        col = 0
    else:
        line, col = pos

    if isinstance(pattern, str):
        pattern = re.compile(pattern)

    line_text = vim.current.window.buffer[line]

    if behind_pos:
        m = pattern.search(line_text[:col])
    else:
        m = pattern.search(line_text[col:])

    if m is None:
        return None

    if len(m.groups()) > 0:
        match_col = m.span(1)[0]
    else:
        match_col = m.span()[0]

    return vim.eval(f'synIDattr(synID({line + 1}, {col + match_col + 1}, 0), "name")')

def in_syntax_group(name):
    syn_stack = vim.eval('map(synstack(line("."), col(".")), "synIDattr(v:val, \\"name\\")")')
    return name in syn_stack
