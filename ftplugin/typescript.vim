setlocal completeopt+=menu,preview
inoremap <buffer> <C-o> <C-x><C-o>
highlight TypeScriptDefinitionDescription ctermfg=46
inoremap <buffer> <C-t> : <C-u>echohl TypeScriptDefinitionDescription <bar> echo tsuquyomi#hint() <bar> echohl None<CR>
nnoremap <buffer> <C-t> : <C-u>echohl TypeScriptDefinitionDescription <bar> echo tsuquyomi#hint() <bar> echohl None<CR>
