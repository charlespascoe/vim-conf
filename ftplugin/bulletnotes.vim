let b:sleuth_automatic=0
setlocal shiftwidth=4  " operation >> indents 4 columns; << unindents 4 columns
setlocal tabstop=4     " a hard TAB displays as 4 columns
setlocal softtabstop=4 " insert/delete 4 spaces when hitting a TAB/BACKSPACE"
setlocal textwidth=80

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
   "echom 'Indent: '.indent
   let lnum = a:startline + 1

   let pattern = '^\s\{'.indent.'\}'

   if !a:subitems
      let pattern = pattern.'[^ ]'
   endif

   " echom '"'.getline(lnum).'"'
   " echom '"'.pattern.'"'
   " echom '"'.matchstr(getline(lnum), pattern).'"'

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
   echom "test"
   let lstr = getline(a:lnum)

   echom 'SOMETHING'

   let m = matchstr(lstr, '^\s*[-*.] ')

   if m == ''
      echom 'NO MATCH'
      let startline = FindBulletStart(a:lnum - 1, 0)

      if startline == -1
	 return GetIndentOfLine(a:lnum - 1)
      else
	 return GetIndentOfLine(startline) + 2
      endif
   else
      echom 'MATCH'
      let ind = GetIndentOfLine(a:lnum)
      echom "'".matchstr(getline(a:lnum), '^\s*')."'"
      echom "INDENT ".ind
      return float2nr(floor(ind / 4) * 4)
   endif
endfun

fun! BnGetIndent2(lnum)
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

" TODO: Tab/Shift-Tab at beginning of bullet to shift indentation
" TODO: Type different bullet at root of bullet to change it
" TODO: Fix indentexpr


inoremap <silent> <buffer> <expr> <CR> "\<CR>\<Left>\<Left>".GetBulletType(line('.'), '-')."\<Right>\<Right>\<BS>\<Space>"
nmap <silent> <buffer> <expr> o "o\<Left>\<Left>".GetBulletType(line('.'), '-')."\<Right>\<Right>\<BS>\<Space>"

nmap <silent> <buffer> >ab >abgv=:call repeat#set('>ab', v:count)<CR>
nmap <silent> <buffer> <ab <abgv=:call repeat#set('<ab', v:count)<CR>
nmap <silent> <buffer> >aB >aBgv=:call repeat#set('>aB', v:count)<CR>
nmap <silent> <buffer> <aB <aBgv=:call repeat#set('<aB', v:count)<CR>
