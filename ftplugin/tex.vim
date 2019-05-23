setlocal shiftwidth=2
setlocal tabstop=2
setlocal softtabstop=2

setlocal spelllang=en_gb spell

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

nnoremap <Leader>fi :let b:format = '\textit' \| set operatorfunc=FormatOp<CR>g@
nnoremap <Leader>fb :let b:format = '\textbf' \| set operatorfunc=FormatOp<CR>g@
nnoremap <Leader>fm :let b:format = '\texttt' \| set operatorfunc=FormatOp<CR>g@
