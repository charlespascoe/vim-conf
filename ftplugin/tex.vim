setlocal shiftwidth=2
setlocal tabstop=2
setlocal softtabstop=2

setlocal spelllang=en_gb spell

" Replaces quotes when copying from other documents
command! Fixquotes : %s/‘/`/ge | %s/’/'/ge | %s/“/``/ge | %s/”/''/ge

nnoremap <buffer> j gj
nnoremap <buffer> k gk
setlocal wrap

vmap <buffer> m c\texttt{<C-r>"}<Esc>
vmap <buffer> i c\textit{<C-r>"}<Esc>
vmap <buffer> b c\textbf{<C-r>"}<Esc>
