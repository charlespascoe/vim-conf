setlocal shiftwidth=2
setlocal tabstop=2
setlocal softtabstop=2

setlocal spell spelllang=en_gb

" Replaces quotes when copying from other documents
command! Fix :
    \ %s/‘/`/ge |
    \ %s/’/'/ge |
    \ %s/“/``/ge |
    \ %s/”/''/ge |
    \ %s/—/---/ge |
    \ %s/"\([^"]\+\)"/``\1''/ge

vmap <buffer> m c\texttt{<C-r>"}<Esc>
vmap <buffer> i c\textit{<C-r>"}<Esc>
vmap <buffer> b c\textbf{<C-r>"}<Esc>

" Text Wrapping
setlocal textwidth=80

fun! FormatOp(type)
    if !exists('b:format') || b:format == ''
        return
    endif

    if a:type ==# 'char'
        exec 'normal!' '`[v`]c'.b:format."{\<C-r>\"}"
    else
        echom "FormatOperator: Unhandled type ".a:type
    endif
endfun

nnoremap <buffer> <Leader>fi :let b:format = '\textit' \| set opfunc=FormatOp<CR>g@
nnoremap <buffer> <Leader>fb :let b:format = '\textbf' \| set opfunc=FormatOp<CR>g@
nnoremap <buffer> <Leader>fm :let b:format = '\texttt' \| set opfunc=FormatOp<CR>g@
