if executable("ag")
    fun! Find(as_regex, term)
        let l:args = a:as_regex ? "" : " -Q"
        let l:pattern = shellescape(a:term)
        " NOTE: lgetexpr has a bug where after a while, it doesn't work at all
        " or only includes certain lines, though I'm not sure what triggers it.
        let l:results = systemlist("ag --vimgrep".l:args." -- ".l:pattern)
        let l:title = (a:as_regex ? 'FindReg' : 'Find').' '.a:term
        call setloclist(0, l:results, 'r')
        call setloclist(0, [], 'a', {'title': l:title, 'efm:': '%f:%l:%c:'})
        lopen
    endfun

    fun! FindSelection() range
        let [lnum1, col1] = getpos("'<")[1:2]
        let [lnum2, col2] = getpos("'>")[1:2]

        let l:lines = getline(lnum1, lnum2)

        let l:lines[-1] = l:lines[-1][: col2 - (&selection == 'inclusive' ? 1 : 2)]
        let l:lines[0] = l:lines[0][col1 - 1:]

        let l:selected_text = join(l:lines, "\n")

        call Find(0, l:selected_text)
    endfun

    command! -nargs=1 Find call Find(0, <f-args>)
    command! -nargs=1 FindReg call Find(1, <f-args>)
    command! -range FindSelection call FindSelection()

    nnoremap <Leader>* <Cmd>call Find(0, expand('<cword>'))<CR>
    vnoremap <Leader>* <Cmd>FindSelection<CR>
    nnoremap <Leader>l <Cmd>lclose<CR>
endif
