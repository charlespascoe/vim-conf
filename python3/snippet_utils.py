import re
import vim


leading_whitespace_re = re.compile(r'^\s+')
non_alphanum_underscore = re.compile(r'[^a-zA-Z0-9_]')


class Window:
    def __init__(self, win, buf=None):
        self.win = win
        self.buffer = buf or Buffer(self.win.buffer.number)

    @property
    def number(self):
        return self.win.number

    @property
    def cursor(self):
        # NOTE: Cusor line is zero-based
        return (self.win.cursor[0] - 1, self.win.cursor[1])

    # NOTE: Cusor line is zero-based
    @property
    def line(self):
        return self.cursor[0]

    @property
    def col(self):
        return self.cursor[1]


class Buffer:
    def __init__(self, bufnr=None):
        if bufnr is None:
            self.buf = vim.current.window.buffer
            self.number = self.buf.number
        else:
            self.number = bufnr
            self.buf = vim.buffers[self.number]

    def __iter__(self):
        for line in self.buf:
            yield line

    def __getitem__(self, lines):
        return self.buf[lines]

    def __len__(self):
        return len(self.buf)

    def lines(self, start=0, end=None, reverse=False):
        if end is None:
            end = len(self)

        if reverse:
            i = end - 1
            while i >= start:
                yield i, self[i]
                i -= 1
        else:
            # Note that line_index = line_number - 1
            for line_index, line in enumerate(self[start:end], start):
                yield line_index, line

    @property
    def win(self):
        if vim.current.window.buffer.number == self.number:
            return Window(vim.current.window, self)
        else:
            raise Exception("TODO: Handle finding best window?")

    def find_line(self, regexp, start=0, end=None, reverse=False):
        for i, line in self.lines(start, end, reverse):
            match = regexp.search(line)
            if match:
                return (i, line, match)

        return None

    def find_lines(self, regexp, start=0, end=None, reverse=False):
        for i, lines in self.lines(start, end, reverse):
            match = regexp.search(line)
            if match:
                yield (i, line, match)


class Current:
    def __init__(self):
        self._win = None
        self._buf = None

    @property
    def window(self):
        if self._win is None or self._win.number != vim.current.window.number:
            self._win = Window(vim.current.window)

        return self._win

    @property
    def buffer(self):
        return self.window.buffer


class Buffers:
    def __getitem__(self, number):
        return Buffer(number)

    @property
    def current(self):
        # A cheat to save coding
        return current.buffer

    def __len__(self):
        return len(vim.buffers)

    def __iter__(self):
        for buf in vim.buffers:
            yield Buffer(buf.number)


buffers = Buffers()

current = Current()


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
    # Buffer.find_line() returns index, line, and match, whereas this function
    # originally just returned the index
    return current.buffer.find_line(regexp)[0]


def find_lines(regexp):
    # Buffer.find_lines() yields index, line, and match, whereas this function
    # originally just returned the index and line
    return current.buffer.find_lines(regexp)[:2]


# Note that line is zero-based and exclusive
def preceeding_lines(line_index=None):
    if line_index is None:
        line_index = current.window.line

    for _, line in current.buffer.lines(end=line_index, reverse=True):
        yield line


# Note that line is zero-based and exclusive
def following_lines(line=None):
    if line_index is None:
        line_index = current.window.line

    for _, line in current.buffer.lines(start=line+1):
        yield line


def nonempty(strings):
    for string in strings:
        if string != '':
            yield string


def top_level(lines):
    for line in lines:
        if line != '' and not leading_whitespace_re.match(line):
            yield line


def search(regexp, lines):
    for line in lines:
        match = regexp.search(line)

        if match:
            yield (line, match)


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
