" Map C-z (custom autocomplete) to Omnicomplete
inoremap <buffer> <expr> <C-z> '<C-x><C-o>'
nmap <buffer> <leader>d <Esc>:EnDeclaration<CR>
nmap <buffer> <leader>D <Esc><C-w>v<C-w><C-w>:EnDeclaration<CR>
nmap <buffer> <leader>i <Esc>:EnSuggestImport<CR>
nmap <buffer> <leader>o <Esc>:EnOrganiseImports<CR>
nmap <buffer> <leader>r <Esc>:EnRename<CR>
nmap <buffer> <leader>t <Esc>:EnType<CR>
nmap <buffer> <leader>T <Esc>:EnTypeCheck<CR>

" Expansions
imap <buffer> <C-e>cc case class ()<Left><Left>
imap <buffer> <C-e>o object  {<CR><CR>}<Esc><Up><Up>7li
imap <buffer> <C-e>d def () = {<CR>}<Esc><Up>4li
