import re
import vim


leading_whitespace_re = re.compile(r'^\s+')


# Returns the zero-based index of the first line that matches the regexp
def find_line(regexp):
	for i in range(len(vim.current.window.buffer)):
		if regexp.match(vim.current.window.buffer[i]):
			return i

	return None

def preceeding_lines():
	l = vim.current.window.cursor[0] - 2

	while l >= 0:
		yield vim.current.window.buffer[l]
		l -= 1


def nonempty(strings):
    for string in strings:
        if string != '':
            yield string


def top_level(lines):
    for line in lines:
        if line != '' and not leading_whitespace_re.match(line):
            yield line
