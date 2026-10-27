setlocal spell

" Same as 'Normal'
hi Comment guibg=#282A36

fun! ShowDiff()
    " Side-by-side diff only when there is room for it; otherwise stack below
    if winwidth(0) < 160
        belowright terminal git --no-pager diff --cached
    else
        vertical rightbelow terminal git --no-pager diff --cached
    endif
    exec 'normal' "\<C-w>\<C-w>"
endfun

command! ShowDiff call ShowDiff()

nmap <buffer> <leader>gd <Cmd>ShowDiff<CR>

setlocal nolist

let b:get_dictation_prompt = function('dictation#GetLeadingParagraph')
