" Map C-z (custom autocomplete) to Omnicomplete
inoremap <buffer> <expr> <C-z> '<C-x><C-o>'
highlight TypeScriptDefinitionDescription ctermfg=46
nmap <buffer> <leader>d <Esc>:TsuDefinition<CR>
nmap <buffer> <leader>D <Esc><C-w>v<C-w><C-w>:TsuDefinition<CR>
nmap <buffer> <leader>r <Esc>:TsuRenameSymbol<CR>
nmap <buffer> <leader>R <Esc>:TsuReferences<CR>
nmap <buffer> <leader>t <Esc>:echohl TypeScriptDefinitionDescription <bar> echo tsuquyomi#hint() <bar> echohl None<CR>
nmap <buffer> <leader>I <Esc>:TsuImport<CR>

" Expansions

inoremap <buffer> <C-y>i import {  } from '';<Left><Left>
inoremap <buffer> <C-y>b <Esc>^9li
inoremap <buffer> <C-y>e const {  } = ;<Left>
