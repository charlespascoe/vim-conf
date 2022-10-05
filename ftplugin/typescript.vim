" Map autocomplete trigger onto Omnicomplete
inoremap <buffer> <C-z> <C-x><C-o>


highlight TypeScriptDefinitionDescription ctermfg=46

" Type analysis commands
nmap <buffer> <leader>td <Cmd>TsuDefinition<CR>
nmap <buffer> <leader>tD <Esc><C-w>v<C-w><C-w>:TsuDefinition<CR>
nmap <buffer> <leader>tR <Esc>:TsuRenameSymbol<CR><C-R><C-W>
nmap <buffer> <leader>tI <Cmd>TsuImport<CR>
nmap <buffer> <leader>tr <Cmd>TsuReferences<CR>
nmap <buffer> <leader>tt <Cmd>echohl TypeScriptDefinitionDescription <bar> echo tsuquyomi#hint() <bar> echohl None<CR>
nmap <buffer> <leader>tP <Cmd>TsuReloadProject<CR>
execute "UltiSnipsAddFiletypes typescript.javascript"
