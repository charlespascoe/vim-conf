" Map autocomplete trigger onto Omnicomplete
inoremap <C-z> <C-x><C-o>


highlight TypeScriptDefinitionDescription ctermfg=46

" Type analysis commands
nmap <buffer> td <Esc>:TsuDefinition<CR>
nmap <buffer> tD <Esc><C-w>v<C-w><C-w>:TsuDefinition<CR>
nmap <buffer> tI <Esc>:TsuImport<CR>
nmap <buffer> tr <Esc>:TsuReferences<CR>
nmap <buffer> tR <Esc>:TsuRenameSymbol<CR>
nmap <buffer> tt <Esc>:echohl TypeScriptDefinitionDescription <bar> echo tsuquyomi#hint() <bar> echohl None<CR>
execute "UltiSnipsAddFiletypes typescript.javascript"
