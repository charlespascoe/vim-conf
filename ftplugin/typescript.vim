" Map C-z (custom autocomplete) to Omnicomplete
inoremap <buffer> <expr> <C-z> '<C-x><C-o>'
highlight TypeScriptDefinitionDescription ctermfg=46
inoremap <buffer> <C-t> : <C-u>echohl TypeScriptDefinitionDescription <bar> echo tsuquyomi#hint() <bar> echohl None<CR>
nnoremap <buffer> <C-t> : <C-u>echohl TypeScriptDefinitionDescription <bar> echo tsuquyomi#hint() <bar> echohl None<CR>
inoremap <buffer> <C-e> <Esc>:TsuRenameSymbol<CR>
nnoremap <buffer> <C-e> <Esc>:TsuRenameSymbol<CR>
nnoremap <buffer> <C-S-d> <Esc>:TsuDefinition<CR>

inoremap <buffer> <C-]> import {  } from '';<Left><Left>
inoremap <buffer> <C-b> <Esc>^9li
