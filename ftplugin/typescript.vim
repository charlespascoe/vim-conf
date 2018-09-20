" Map C-z (custom autocomplete) to Omnicomplete
inoremap <buffer> <expr> <C-z> '<C-x><C-o>'
highlight TypeScriptDefinitionDescription ctermfg=46

" Type analysis commands
nmap <buffer> <leader>td <Esc>:TsuDefinition<CR>
nmap <buffer> <leader>tD <Esc><C-w>v<C-w><C-w>:TsuDefinition<CR>
nmap <buffer> <leader>tI <Esc>:TsuImport<CR>
nmap <buffer> <leader>tr <Esc>:TsuReferences<CR>
nmap <buffer> <leader>tR <Esc>:TsuRenameSymbol<CR>
nmap <buffer> <leader>tt <Esc>:echohl TypeScriptDefinitionDescription <bar> echo tsuquyomi#hint() <bar> echohl None<CR>

" Expansions
inoremap <buffer> <C-y>i import {  } from '';<Left><Left>
inoremap <buffer> <C-y>b <Esc>^9li
inoremap <buffer> <C-y>e const {  } = ;<Left>
