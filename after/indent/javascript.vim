function! JsIndent() abort
  " Find the previous non-blank line
  let l:prev_lnum = prevnonblank(v:lnum - 1)
  if l:prev_lnum == 0
    return 0
  endif

  " Start with the previous line's indent
  let l:ind = indent(l:prev_lnum)

  " If the previous line ends with ( or {, increase indent by one shiftwidth
  let l:prev_line = getline(l:prev_lnum)
  if l:prev_line =~# '[({]\s*$'
    let l:ind += shiftwidth()
  endif

  " If the current line starts with ) or }, decrease indent by one shiftwidth
  let l:cur_line = getline(v:lnum)
  if l:cur_line =~# '^\s*[)}]'
    let l:ind -= shiftwidth()
  endif

  return l:ind
endfunction

setlocal indentexpr=JsIndent()
