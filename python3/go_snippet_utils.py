import re
import vim
from snippet_utils import find_line


import_re = re.compile(r'^import \($')


def add_import(snip, *imports):
	imports = list(imports)

	index = find_line(import_re)

	if index is None:
		go_import(imports)
		silence_buffer_mutation_errors(snip)
		return

	for i in range(index + 1, len(vim.current.window.buffer)):
		line = vim.current.window.buffer[i].strip().replace('"', '')

		imports = [imp for imp in imports if imp != line]

		if line == ')':
			if len(imports) > 0:
				# End of imports - not found, so just add it
				go_import(imports)
				silence_buffer_mutation_errors(snip)

			return


def silence_buffer_mutation_errors(snip):
	# A **SUPER** hacky-hack that prevents UltiSnips from
	# complaining that the buffer has changed, even though I know
	# that the GoImport command won't affect the cursor position
	# relative to the snippet location. This may break at any time.
	snip.buffer._change_tick = int(vim.eval("b:changedtick"))


def go_import(imports):
	for imp in imports:
		parts = imp.split(' ')

		if len(parts) > 1:
			alias, path = parts[0], parts[1]
			vim.command(f'GoImportAs {alias} {path}')
		else:
			vim.command(f'GoImport {imp}')
