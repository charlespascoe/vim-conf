import re
import vim
from snippet_utils import find_line


import_re = re.compile(r'^import \($')


def add_import(prefix, snip, *imports):
	if not snip.buffer[snip.line][:snip.column+1].endswith(prefix):
		return False

	imports = list(imports)

	index = find_line(import_re)

	if index is None:
		go_import(imports)
		return True

	for i in range(index + 1, len(vim.current.window.buffer)):
		line = vim.current.window.buffer[i].strip().replace('"', '')

		imports = [imp for imp in imports if imp != line]

		if line == ')':
			if len(imports) > 0:
				# End of imports - not found, so just add it
				go_import(imports)
			return True


def go_import(imports):
	for imp in imports:
		parts = imp.split(' ')

		if len(parts) > 1:
			alias, path = parts[0], parts[1]
			vim.command(f'GoImportAs {alias} {path}')
		else:
			vim.command(f'GoImport {imp}')
