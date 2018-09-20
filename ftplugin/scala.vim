" Map C-z (custom autocomplete) to Omnicomplete
inoremap <buffer> <expr> <C-z> '<C-x><C-o>'

" Type analysis commands
nmap <buffer> <leader>td <Esc>:EnDeclaration<CR>
nmap <buffer> <leader>tD <Esc><C-w>v<C-w><C-w>:EnDeclaration<CR>
nmap <buffer> <leader>tI <Esc>:EnSuggestImport<CR>
nmap <buffer> <leader>tO <Esc>:EnOrganiseImports<CR>
nmap <buffer> <leader>tR <Esc>:EnRename<CR>
nmap <buffer> <leader>tt <Esc>:EnType<CR>
nmap <buffer> <leader>tT <Esc>:EnTypeCheck<CR>

" Expansions
imap <buffer> <C-e>cc case class ()<Left><Left>
imap <buffer> <C-e>o object  {<CR><CR>}<Esc><Up><Up>7li
imap <buffer> <C-e>d def () = {<CR>}<Esc><Up>4li
