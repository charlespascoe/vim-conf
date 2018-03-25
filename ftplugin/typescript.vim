setlocal completeopt+=menu,preview
inoremap <buffer> <C-z> <C-x><C-o>
highlight TypeScriptDefinitionDescription ctermfg=46
inoremap <buffer> <C-t> : <C-u>echohl TypeScriptDefinitionDescription <bar> echo tsuquyomi#hint() <bar> echohl None<CR>
nnoremap <buffer> <C-t> : <C-u>echohl TypeScriptDefinitionDescription <bar> echo tsuquyomi#hint() <bar> echohl None<CR>
inoremap <buffer> <C-e> <Esc>:TsuRenameSymbol<CR>
nnoremap <buffer> <C-e> <Esc>:TsuRenameSymbol<CR>
