" Map autocomplete trigger onto Omnicomplete
inoremap <buffer> <C-z> <C-x><C-o>

nmap <buffer> <leader>tt <Plug>(go-info)
nmap <buffer> <leader>td <Plug>(go-def)
nmap <buffer> <leader>tD <Plug>(go-doc)
nmap <buffer> <leader>tr <Plug>(go-referrers)
nmap <buffer> <leader>tc <Plug>(go-coverage-toggle)
nmap <buffer> <leader>tR <Plug>(go-rename)
nmap <buffer> <leader>tT <C-w>v<C-w><C-w><Plug>(go-alternate-edit)
nmap <buffer> <leader>tI <Plug>(go-import)
nmap <buffer> <leader>tf $ca" ()<Left><CR><C-r>"
nmap <buffer> <leader>tb <Plug>(go-build)
nmap <silent> <buffer> <leader>tf <Esc>:GoFmt<CR>
nmap <buffer> <leader>e <Plug>(go-iferr)
nnoremap <buffer> <leader>i `iO""<Left>

setlocal completeopt=menu

call QuickSearchMap('f', 'func')
call QuickSearchMap('t', 'type')
call QuickSearchMap('s', 'struct')
