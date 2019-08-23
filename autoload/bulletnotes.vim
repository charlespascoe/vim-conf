let s:pathSegmentPattern = '[a-zA-Z0-9_\-.]\+'
let s:pathPattern = s:pathSegmentPattern.'\(\/'.s:pathSegmentPattern.'\)*'

if !exists('g:bn_project_loaded')
   let g:bn_project_loaded = 0
endif

" TODO: Tab/Shift-Tab at beginning of bullet to shift indentation (sort of done)
" TODO: Allow arbitrary bullet definitions (do syntax later)

set debug="msg"
fun bulletnotes#InitBuffer()
   setlocal shiftwidth=4  " operation >> indents 4 columns; << unindents 4 columns
   setlocal tabstop=4     " a hard TAB displays as 4 columns
   setlocal softtabstop=4 " insert/delete 4 spaces when hitting a TAB/BACKSPACE"
   setlocal textwidth=80
   setlocal formatoptions=t

   onoremap <silent> <buffer> ab :<C-u>call bulletnotes#MarkBullet(0)<CR>
   onoremap <silent> <buffer> aB :<C-u>call bulletnotes#MarkBullet(1)<CR>

   inoremap <silent> <buffer> <expr> <CR> "\<CR>\<Left>\<Left>".bulletnotes#GetBulletType(line('.'), '-')."\<Right>\<Right>\<BS>\<Space>"
   nmap <silent> <buffer> <expr> o "o\<Left>\<Left>".bulletnotes#GetBulletType(line('.'), '-')."\<Right>\<Right>\<BS>\<Space>"

   nmap <silent> <buffer> >ab >abgv=:call repeat#set('>ab', v:count)<CR>
   nmap <silent> <buffer> <ab <abgv=:call repeat#set('<ab', v:count)<CR>
   nmap <silent> <buffer> >aB >aBgv=:call repeat#set('>aB', v:count)<CR>
   nmap <silent> <buffer> <aB <aBgv=:call repeat#set('<aB', v:count)<CR>

   inoremap <silent> <expr> <buffer> - bulletnotes#IsAtStartOfBullet() ? '<BS><BS>-<Space>' : '-'
   inoremap <silent> <expr> <buffer> * bulletnotes#IsAtStartOfBullet() ? '<BS><BS>*<Space>' : '*'
   inoremap <silent> <expr> <buffer> . bulletnotes#IsAtStartOfBullet() ? '<BS><BS>.<Space>' : '.'

   imap <silent> <expr> <buffer> <Tab> bulletnotes#IsAtStartOfBullet() ? '<Esc>>>^i<Right><Right>' : '<C-z>'
   imap <silent> <expr> <buffer> <S-Tab> bulletnotes#IsAtStartOfBullet() ? '<Esc><<^i<Right><Right>' : '<S-Tab>'

   nnoremap <silent> <buffer> <leader>ft :Find <C-r><C-a><CR>
   " TODO: Make this much more robust (e.g. what if the WORD has a single quote?)
   nnoremap <silent> <buffer> <leader>gf :call bulletnotes#OpenFile('<C-r><C-a>')<CR>

   setlocal indentexpr=bulletnotes#BnGetIndent(v:lnum)

   inoremap <buffer> <C-z> <C-x><C-o>
   setlocal omnifunc=bulletnotes#Complete
endfun

fun bulletnotes#InitProject()
   let root = FindProjectRoot(getcwd(), '.bnproj')

   if root != ''
      exec "cd ".fnameescape(root)
      let g:bn_project_loaded = 1
   else
      echoerr "Can't find project root"
      return
   endif

   command! -nargs=? Inbox call bulletnotes#NewInboxItem(<f-args>)
endfun

fun bulletnotes#FindBulletStart(lnum, strict)
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
	 return bulletnotes#FindBulletStart(a:lnum - 1, a:strict)
      endif
   else
      return a:lnum
   endif
endfun

fun bulletnotes#FindBulletEnd(startline, subitems)
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

fun bulletnotes#FindBullet(subitems)
   let startline = bulletnotes#FindBulletStart(line('.'), 1)

   if startline == -1
      return {}
   endif

   let endline = bulletnotes#FindBulletEnd(startline, a:subitems)

   return {
      \ "startline": startline,
      \ "endline": endline
   \ }
endfun

fun bulletnotes#MarkBullet(subitems)
   let bullet = bulletnotes#FindBullet(a:subitems)

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

fun bulletnotes#GetIndentOfLine(lnum)
   if a:lnum < 1
      return 0
   endif

   return len(matchstr(getline(a:lnum), '^\s*'))
endfun

fun bulletnotes#BnGetIndent(lnum)
   echom a:lnum
   let bulletPattern =  '^\s*[-*.] '

   let m = matchstr(getline(a:lnum), bulletPattern)

   if m != ''
      let ind = bulletnotes#GetIndentOfLine(a:lnum)
      return float2nr(floor(ind / 4) * 4)
   endif

   let m = matchstr(getline(a:lnum - 1), bulletPattern)

   if m != ''
      return bulletnotes#GetIndentOfLine(a:lnum - 1) + 2
   endif

   return bulletnotes#GetIndentOfLine(a:lnum - 1)
endfun

fun bulletnotes#GetBulletType(lnum, default)
   let startline = bulletnotes#FindBulletStart(a:lnum, 1)

   if startline == -1
      return a:default
   else
      let lstr = getline(startline)
      return trim(lstr)[0]
   endif
endfun

fun bulletnotes#IsAtStartOfBullet()
   return strpart(getline('.'), 0, col('.') - 1) =~ '^\s*[-*.] $'
endfun

fun bulletnotes#ResolveFile(targetDescriptor, ext)
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

fun bulletnotes#OpenFile(targetDescriptor)
   let path = bulletnotes#ResolveFile(a:targetDescriptor, '.bn')

   if path != ''
      exec 'e '.path
      return
   endif

   let path = bulletnotes#ResolveFile(a:targetDescriptor, '')

   if path != ''
      call job_start(['xdg-open', path])
      return
   endif

   echoerr 'Not found: '.a:targetDescriptor
endfun

fun bulletnotes#GetDate()
   return trim(system('date +"%y%m%d-%H%M"'))
endfun

fun bulletnotes#SanitiseNoteName(name)
   let result = substitute(a:name, '\s\+', '_', 'g')
   let result = substitute(result, '[^a-zA-Z0-9_\-.]', '', 'g')
   return result
endfun


fun bulletnotes#NewInboxItem(...)
   if a:0 == 0
      let path = 'inbox/'.bulletnotes#GetDate().'.bn'

      exec 'e '.path
      if !filereadable(path)
	 " File doesn't exist - add template text
	 exec 'normal i- '
      endif
   else
      let path = 'inbox/'.bulletnotes#GetDate().'-'.bulletnotes#SanitiseNoteName(a:1).'.bn'
      exec 'e '.path

      if !filereadable(path)
	 set paste
	 " File doesn't exist - add template text
	 exec 'normal i:: '.a:1." ::\<CR>\<CR>- "
	 set nopaste
      endif
   endif
   startinsert!
endfun

fun bulletnotes#StartsWith(prefix, str)
   if len(a:str) < len(a:prefix)
      return 0
   endif

   return a:prefix ==# strpart(a:str, 0, len(a:prefix))
endfun

fun bulletnotes#Complete(findstart, base)
   if a:findstart
      let lstr = strpart(getline('.'), 0, col('.') - 1)

      let metatext = matchstr(lstr, '[#@&][^ ]*$')

      if metatext == ''
	 " Cancel completion
	 return -3
      endif

      return len(lstr) - len(metatext)
   else

   if len(a:base) == 0
      return []
   endif

   let type = a:base[0]
   echom type

   if type == '#'
      " TODO: Correct pattern
      " TODO: Order by frequency?
      let tags = split(system("ag --nofilename -o '#[a-zA-Z0-9_-]+'"), "\n\\+")
      let g:__bn_match = a:base
      call filter(tags, 'bulletnotes#StartsWith(g:__bn_match, v:val)')
      unlet g:__bn_match
      return tags
   endif

   if type == '&'
      let files = split(system("find ref/ -type f -not -name '*.swp'"))
      echom files
      call map(files, "substitute(v:val, '^ref/', '', '')")
      call map(files, "'&'.substitute(v:val, '.bn$', '', '')")
      let g:__bn_match = a:base
      call filter(files, 'bulletnotes#StartsWith(g:__bn_match, v:val)')
      call sort(files)
      unlet g:__bn_match
      return files
   endif

   if type == '@'
      let files = split(system("find inbox/ archive/ -type f -not -name '*.swp'"))
      echom files
      call map(files, "substitute(v:val, '^\\(inbox\\|archive\\)/', '', '')")
      call map(files, "'@'.substitute(v:val, '.bn$', '', '')")
      let g:__bn_match = a:base
      call filter(files, 'bulletnotes#StartsWith(g:__bn_match, v:val)')
      call sort(files)
      unlet g:__bn_match
      return files
   endif

   return []
endfun
