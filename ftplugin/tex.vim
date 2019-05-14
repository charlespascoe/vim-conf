setlocal shiftwidth=2
setlocal tabstop=2
setlocal softtabstop=2

setlocal spelllang=en_gb spell

" Replaces quotes when copying from other documents
command! Fix : %s/‘/`/ge | %s/’/'/ge | %s/“/``/ge | %s/”/''/ge | %s/—/---/ge | %s/"\([^"]\+\)"/``\1''/ge

vmap <buffer> m c\texttt{<C-r>"}<Esc>
vmap <buffer> i c\textit{<C-r>"}<Esc>
vmap <buffer> b c\textbf{<C-r>"}<Esc>

" Text Wrapping

setlocal textwidth=79

fun! RewrapSelection(type)
   if a:type ==# 'line'
      let startmark = getpos("'[")
      let endmark = getpos("']")

      let startline = startmark[1]
      let endline = endmark[1]

      let i = startline

      while i <= endline
	 if i == startline
	    exec 'normal' "Aa\<BS>\<Esc>"
	 else
	    if getline('.') =~ '^\s\+'
	       exec 'normal' "I\<C-w>\<C-w> \<Esc>Aa\<BS>\<Esc>"
	    else
	       exec 'normal' "I\<C-w> \<Esc>Aa\<BS>\<Esc>"
	    endif
	 endif

	 if i != endline
	    normal j
	 endif

	 let i += 1
      endwhile
   else
      echom "RewrapSelection: Won't handle ".a:type
   endif
endfun

nnoremap gR :set operatorfunc=RewrapSelection<CR>g@
