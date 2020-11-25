setlocal spell
hi Comment ctermbg=none

fun! ShowDiff()
    vertical rightbelow terminal git --no-pager diff --cached
    exec 'normal' "\<C-w>\<C-w>"
endfun

command! ShowDiff call ShowDiff()

nmap <silent> <buffer> <leader>gd <Esc>:ShowDiff<CR>

setlocal nolist
