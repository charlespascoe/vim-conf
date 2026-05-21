" Allows you to use 'gf' to jump to a schema file
setlocal suffixesadd=.json
setlocal isfname-=#

command! -buffer FormatJson %!python3 -m json.tool
