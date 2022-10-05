" Map autocomplete trigger onto Omnicomplete
inoremap <buffer> <C-z> <C-x><C-o>

fun! RealtimeRepl()
    let g:repl_buf = bufnr("Node REPL", 1)
    call setbufvar(g:repl_buf, '&buftype', 'nofile')
    call setbufvar(g:repl_buf, '&bufhidden', 'hide')
    call setbufvar(g:repl_buf, '&swapfile', 0)
    call setbufvar(g:repl_buf, '&buflisted', 0)
    exec "rightbelow vertical sbuffer" g:repl_buf
    exec "normal" "\<C-w>\<C-w>"
    call setbufvar(g:repl_buf, '&number', 0)
    call setbufvar(g:repl_buf, '&relativenumber', 0)
    call setbufvar(g:repl_buf, '&colorcolumn', 0)

    setlocal scrollbind
    call setbufvar(g:repl_buf, '&scrollbind', 1)

    vertical resize 80

    py3file ~/.vim-conf/realtime-repl.py

    python3 run_code(vim.current.buffer.number, int(vim.eval('g:repl_buf')))
    au TextChanged,TextChangedI <buffer> python3 run_code(vim.current.buffer.number, int(vim.eval('g:repl_buf')))

    " TODO: Stop this when the window is closed
endfun

command! RealtimeRepl call RealtimeRepl()

fun! AddImport()
    let l:import_line = search('^\(import\|from\)\s\+', 'bs')

    if l:import_line == 0
        normal ggO
    else
        normal o
    end

    startinsert
endfun

noremap <buffer> <leader>i <Cmd>call AddImport()<CR>

call QuickSearchMap('f', 'Functions', '\<def [a-zA-Z0-9_]\+(\(self\)\@!')
call QuickSearchMap('c', 'Classes', '\<class [a-zA-Z0-9_]\+')
call QuickSearchMap('m', 'Methods', '\<def [a-zA-Z0-9_]\+(self\>')
