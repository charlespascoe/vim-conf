let b:sleuth_automatic=0
setlocal shiftwidth=4  " operation >> indents 4 columns; << unindents 4 columns
setlocal tabstop=4     " a hard TAB displays as 4 columns
setlocal softtabstop=4 " insert/delete 4 spaces when hitting a TAB/BACKSPACE"
setlocal textwidth=80

" TODO: Tab/Shift-Tab at beginning of bullet to shift indentation (sort of done)
" TODO: Type different bullet at root of bullet to change it
" TODO: Allow arbitrary bullet definitions (do syntax later)

set debug="msg"

" Automatically updates formatting (wrapping) as text is changed
"setlocal formatoptions+=a
"setlocal formatoptions+=2
setlocal formatoptions=t

fun! FindBulletStart(lnum, strict)
   let lstr = getline(a:lnum)

   if match(lstr, '^\s*$') != -1
      return -1
   endif

   let pattern = '^\(\s'

   if a:strict
      let pattern .= '\{4\}'
   endif

   let pattern .= '\)*[-*.]'

   let m = matchstr(lstr, pattern)

   if m == ''
      if a:lnum == 1
	 return -1
      else
	 return FindBulletStart(a:lnum - 1, a:strict)
      endif
   else
      return a:lnum
   endif
endfun

fun! FindBulletEnd(startline, subitems)
   let lstr = getline(a:startline)
   " +1 for the symbol, +1 for the space
   let indent = len(matchstr(lstr, '^\s*')) + 2
   let lnum = a:startline + 1

   let pattern = '^\s\{'.indent.'\}'

   if !a:subitems
      let pattern = pattern.'[^ ]'
   endif

   " TODO: Check before end of file
   while matchstr(getline(lnum), pattern) != ''
      let lnum = lnum + 1
   endwhile

   return lnum - 1
endfun

fun! FindBullet(subitems)
   let startline = FindBulletStart(line('.'), 1)

   if startline == -1
      return {}
   endif

   let endline = FindBulletEnd(startline, a:subitems)

   return {
      \ "startline": startline,
      \ "endline": endline
   \ }
endfun

fun! MarkBullet(subitems)
   let bullet = FindBullet(a:subitems)

   if empty(bullet)
      echoerr "Can't find bullet"
      return
   endif

   let start = getpos(".")
   let start[1] = bullet["startline"]
   let start[2] = col([bullet["startline"], "^"])

   let end = getpos(".")
   let end[1] = bullet["endline"]
   let end[2] = col([bullet["endline"], "$"])

   call setpos(".", start)
   exec 'normal!' 'V'
   call setpos(".", end)
endfun

onoremap <silent> <buffer> ab :<C-u>call MarkBullet(0)<CR>
onoremap <silent> <buffer> aB :<C-u>call MarkBullet(1)<CR>

fun! GetIndentOfLine(lnum)
   if a:lnum < 1
      return 0
   endif

   return len(matchstr(getline(a:lnum), '^\s*'))
endfun


fun! BnGetIndent(lnum)
   echom a:lnum
   let bulletPattern =  '^\s*[-*.] '

   let m = matchstr(getline(a:lnum), bulletPattern)

   if m != ''
      let ind = GetIndentOfLine(a:lnum)
      return float2nr(floor(ind / 4) * 4)
   endif

   let m = matchstr(getline(a:lnum - 1), bulletPattern)

   if m != ''
      return GetIndentOfLine(a:lnum - 1) + 2
   endif

   return GetIndentOfLine(a:lnum - 1)
endfun

fun! GetBulletType(lnum, default)
   let startline = FindBulletStart(a:lnum, 1)

   if startline == -1
      return a:default
   else
      let lstr = getline(startline)
      return trim(lstr)[0]
   endif
endfun



inoremap <silent> <buffer> <expr> <CR> "\<CR>\<Left>\<Left>".GetBulletType(line('.'), '-')."\<Right>\<Right>\<BS>\<Space>"
nmap <silent> <buffer> <expr> o "o\<Left>\<Left>".GetBulletType(line('.'), '-')."\<Right>\<Right>\<BS>\<Space>"

nmap <silent> <buffer> >ab >abgv=:call repeat#set('>ab', v:count)<CR>
nmap <silent> <buffer> <ab <abgv=:call repeat#set('<ab', v:count)<CR>
nmap <silent> <buffer> >aB >aBgv=:call repeat#set('>aB', v:count)<CR>
nmap <silent> <buffer> <aB <aBgv=:call repeat#set('<aB', v:count)<CR>

inoremap <silent> <expr> <buffer> - IsAtStartOfBullet() ? '<BS><BS>-<Space>' : '-'
inoremap <silent> <expr> <buffer> * IsAtStartOfBullet() ? '<BS><BS>*<Space>' : '*'
inoremap <silent> <expr> <buffer> . IsAtStartOfBullet() ? '<BS><BS>.<Space>' : '.'

imap <silent> <expr> <buffer> <Tab> IsAtStartOfBullet() ? '<Esc>>>^i<Right><Right>' : '<Tab>'
imap <silent> <expr> <buffer> <S-Tab> IsAtStartOfBullet() ? '<Esc><<^i<Right><Right>' : '<Tab>'
"inoremap <expr> <buffer> <Tab> ShouldIndentBullet() ? '<Esc>>aBi' : '<Tab>'
"inoremap <silent> <expr> <buffer> <S-Tab> ShouldIndentBullet() ? '<Esc><aBi' : '<Tab>'

fun! IsAtStartOfBullet()
    return strpart(getline('.'), 0, col('.') - 1) =~ '^\s*[-*.] $'
endfun

set indentexpr=BnGetIndent(v:lnum)

let s:pathSegmentPattern = '[a-zA-Z0-9_\-.]\+'
let s:pathPattern = s:pathSegmentPattern.'\(\/'.s:pathSegmentPattern.'\)*'

if !exists('g:bn_project_loaded')
   let g:bn_project_loaded = 0
endif


if !exists('g:bn_functions_loaded')
   let g:bn_functions_loaded = 0
endif

if !g:bn_functions_loaded
   fun ResolveFile(targetDescriptor, ext)
      let m = matchlist(a:targetDescriptor, '^\([@&]\)\('.s:pathPattern.'\)')

      if len(m) == 0
	 return ''
      endif

      let type = m[1]
      let p = m[2]

      let parents = []

      if type == '&'
	 let parents = ['ref']
      elseif type == '@'
	 let parents = ['inbox', 'archive']
      endif

      for parent in parents
	 if filereadable(parent.'/'.p.a:ext)
	    return parent.'/'.p.a:ext
	 endif
      endfor

      return ''
   endfun

   fun OpenFile(targetDescriptor)

      let path = ResolveFile(a:targetDescriptor, '.bn')

      if path != ''
	 exec 'e '.path
	 return
      endif

      let path = ResolveFile(a:targetDescriptor, '')

      if path != ''
	 silent call job_start("xdg-open '".shellescape(path)."'")
	 return
      endif

      echoerr 'Not found: '.a:targetDescriptor
   endfun

   nnoremap <silent> <buffer> <leader>ft :Find <C-r><C-a><CR>
   " TODO: Make this much more robust (e.g. what if the WORD has a single
   " quote?)
   nnoremap <silent> <buffer> <leader>gf :call OpenFile('<C-r><C-a>')<CR>

   fun GetDate()
      return trim(system('date +"%y%m%d-%H%M"'))
   endfun

   fun SanitiseNoteName(name)
      let result = substitute(a:name, '\s\+', '_', 'g')
      let result = substitute(result, '[^a-zA-Z0-9_\-.]', '', 'g')
      return result
   endfun

   fun NewInboxItem(...)
      if a:0 == 0
	 exec 'e inbox/'.GetDate().'.bn'
	 exec 'normal i- '
      else
	 exec 'e inbox/'.GetDate().'-'.SanitiseNoteName(a:1).'.bn'
	 set paste
	 exec 'normal i:: '.a:1." ::\<CR>\<CR>- "
	 set nopaste
	 startinsert!
      endif
   endfun

   fun LoadProjectCommands()
      command! -nargs=? Inbox call NewInboxItem(<f-args>)
   endfun

   let bn_functions_loaded = 1
endif

if !g:bn_project_loaded
   let s:root = FindProjectRoot(getcwd(), '.bnproj')

   if s:root != ''
      exec "cd ".fnameescape(s:root)
      let g:bn_project_loaded = 1
   endif
endif

if g:bn_project_loaded
   call LoadProjectCommands()
endif
