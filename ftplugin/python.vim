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
