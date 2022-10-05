setlocal spell
hi Comment ctermbg=none

fun! ShowDiff()
    vertical rightbelow terminal git --no-pager diff --cached
    exec 'normal' "\<C-w>\<C-w>"
endfun

command! ShowDiff call ShowDiff()

nmap <buffer> <leader>gd <Cmd>ShowDiff<CR>

setlocal nolist
