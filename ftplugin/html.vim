let b:delimitMate_matchpairs  = '(:),{:},[:]'

if &filetype ==# 'html'
  py3 import format as vimformat

  function! s:FormatHtml(line1, line2) abort
    if !executable('prettier')
      echoerr "Prettier is not installed, cannot format HTML files. Please install it with 'brew install prettier'."
      return
    endif

    py3 vimformat.format('prettier', ['--parser', 'html'], int(vim.eval('a:line1')) - 1, int(vim.eval('a:line2')) - 1)
  endfunction

  command! -buffer -range=% FormatHtml call <SID>FormatHtml(<line1>, <line2>)

  augroup format_html_on_save
    autocmd! * <buffer>
    autocmd BufWritePre <buffer> if get(b:, 'format_on_save', v:true) | call <SID>FormatHtml(1, line('$')) | endif
  augroup END

  nnoremap <silent> <buffer> <leader>tf <Cmd>FormatHtml<CR>
endif
