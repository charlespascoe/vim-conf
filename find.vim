if executable("ag")
    fun! Find(as_regex, term)
        let l:args = a:as_regex ? "" : " -Q"
        let l:pattern = "'".substitute(a:term, "'", "'\"'\"'", "g")."'"
        lgetexpr system("ag --vimgrep".l:args." -- ".l:pattern)
        lopen
    endfun

    fun! FindSelection() range
        let [lnum1, col1] = getpos("'<")[1:2]
        let [lnum2, col2] = getpos("'>")[1:2]

        let lines = getline(lnum1, lnum2)

        let lines[-1] = lines[-1][: col2 - (&selection == 'inclusive' ? 1 : 2)]
        let lines[0] = lines[0][col1 - 1:]

        let selected_text = join(lines, "\n")

        call Find(0, selected_text)
    endfun

    command! -nargs=1 Find call Find(0, <f-args>)
    command! -nargs=1 FindReg call Find(1, <f-args>)
    command! -range FindSelection call FindSelection()

    nnoremap <Leader>* <Esc>:Find <C-R><C-W><CR>
    vnoremap <Leader>* :FindSelection<CR>
    nnoremap <Leader>l <Esc>:lclose<CR>
endif
