setlocal spell
setlocal wrap
setlocal textwidth=80

" Don't format any Markdown files in the ~/.pi/ directory, which are often
" prompts that are manually formatted
if stridx(expand('%:p'), $HOME..'/.pi/') == 0
  let b:format_on_save = v:false
endif

py3 import format as vimformat

function! s:FormatMarkdown(line1, line2) abort
  if !executable('prettier')
    echoerr "Prettier is not installed, cannot format Markdown files. Please install it with 'brew install prettier'."
    return
  endif

  " TODO: See if it's possible to use --cursor-offset to preserve cursor position
  py3 vimformat.format('prettier', ['--parser', 'markdown', '--tab-width', '4', '--print-width', '80', '--prose-wrap', 'always'], int(vim.eval('a:line1')) - 1, int(vim.eval('a:line2')) - 1)
endfunction

command! -buffer -range=% FormatMarkdown call <SID>FormatMarkdown(<line1>, <line2>)

augroup format_markdown_on_save
  autocmd! * <buffer>
  autocmd BufWritePre <buffer> if get(b:, 'format_on_save', v:true) | call <SID>FormatMarkdown(1, line('$')) | endif
augroup END

nnoremap <silent> <buffer> <leader>tf <Cmd>FormatMarkdown<CR>

imap <expr> <buffer> <Tab> ShouldIndentBullet() ? '<Esc>>>^i<Right><Right>' : (ShouldAutocomplete() ? '<C-z>' : '<Tab>')
imap <expr> <buffer> <S-Tab> ShouldIndentBullet() ? '<Esc><<^i<Right><Right>' : copilot#Accept('<Tab>')

func s:PasteCode()
  let l:prev = getreg(v:register)
  let l:prev_type = getregtype(v:register)
  " Trim trailing newlines
  let l:prev = substitute(l:prev, '\n\+$', '', '')
  call setreg(v:register, "```\n" .. l:prev .. "\n```", 'V')
  normal! p
  call setreg(v:register, l:prev, l:prev_type)
endfunc

nnoremap <silent> <buffer> <leader>p <Cmd>call <SID>PasteCode()<CR>

let g:markdown_fenced_languages = ['js=javascript', 'jsx=javascript']
let g:markdown_minlines = 200

fun! ShouldIndentBullet()
  return strpart(getline('.'), col('.') - 3, 1) == '-'
endfun

py3 import mdjoin
command! -range=% Export let @+ = py3eval('mdjoin.join(start=<line1>, end=<line2>)')

" Convert selected text to a link

fun! FormatLinkSlug(type)
  if a:type ==# 'char'
    exec 'normal!' "`[v`]c\<C-r>='#'.join(split(tolower(@\"), '[^a-z0-9]\\+'), '-')\<Enter>"
  else
    echom "FormatLinkSlug: Unhandled type ".a:type
  endif
endfun

let b:get_dictation_prompt = function('dictation#GetLeadingLines')
