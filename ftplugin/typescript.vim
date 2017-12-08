setlocal completeopt+=menu,preview
inoremap <buffer> <C-o> <C-x><C-o>
highlight TypeScriptDefinitionDescription ctermfg=46
nmap <buffer> <Leader>t : <C-u>echohl TypeScriptDefinitionDescription <bar> echo tsuquyomi#hint() <bar> echohl None<CR>
