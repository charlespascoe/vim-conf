" Map autocomplete trigger onto Omnicomplete
inoremap <buffer> <C-z> <C-x><C-o>


highlight TypeScriptDefinitionDescription ctermfg=46

" Type analysis commands
nmap <buffer> <leader>td <Esc>:TsuDefinition<CR>
nmap <buffer> <leader>tD <Esc><C-w>v<C-w><C-w>:TsuDefinition<CR>
nmap <buffer> <leader>tI <Esc>:TsuImport<CR>
nmap <buffer> <leader>tr <Esc>:TsuReferences<CR>
nmap <buffer> <leader>tR <Esc>:TsuRenameSymbol<CR><C-R><C-W>
nmap <buffer> <leader>tt <Esc>:echohl TypeScriptDefinitionDescription <bar> echo tsuquyomi#hint() <bar> echohl None<CR>
nmap <buffer> <leader>tP <Esc>:TsuReloadProject<CR>
execute "UltiSnipsAddFiletypes typescript.javascript"
