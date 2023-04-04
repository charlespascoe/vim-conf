setlocal shiftwidth=2
setlocal tabstop=2
setlocal softtabstop=2

setlocal foldenable
setlocal foldmethod=syntax

nmap <buffer> <leader>td <C-]>
nmap <buffer> <leader>te <Plug>(ale_next)zz
nmap <buffer> <leader>tE <Plug>(ale_previous)zz

" TODO: Improve matching
call QuickSearchMap('f', 'Functions', '\w\+(.*)\s\+{$')
call QuickSearchMap('c', 'Classes', 'class\s\+\zs\w\+')

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

    python3 init_node()
    python3 run_js_code(vim.current.buffer.number, int(vim.eval('g:repl_buf')))
    au TextChanged,TextChangedI <buffer> python3 run_js_code(vim.current.buffer.number, int(vim.eval('g:repl_buf')))

    " TODO: Stop this when the window is closed
endfun

command! RealtimeRepl call RealtimeRepl()

nmap <buffer> <leader>i <Cmd>call <SID>AddImport()<CR>

fun! s:AddImport()
    " Assumes this function is run when the cursor is some way below the imports
    let l:import_line = search('^import\s', 'bs')

    if l:import_line != 0
        call feedkeys("oim\<C-l>")
    else
        call feedkeys("ggOim\<C-l>")
    end
endfun

fun s:GetDictationContext()
    let syn = synIDattr(synIDtrans(synID(line("."),max([col(".")-1,1]),1)),"name")

    let prompt = ''
    let transforms = ['camelcase']

    if syn == 'Comment'
        let prompt = dictate#GetLeadingComment()
        let transforms = ['comment']
    elseif syn == 'String'
        let prompt = dictate#GetLeadingString()
        " TODO: Check to see if it's actually a double-quoted string and not a
        " single-quoted string or template string
        let transforms = ['default', 'dqesc']
    elseif syn == 'Function'
        let prompt = 'The function name is: '
        let transforms = ['camelcase']
    elseif syn == 'Type'
        let prompt = 'The class name is: '
        let transforms = ['pascalcase']
    endif

    return #{prompt: prompt, transforms: transforms}
endfun

let b:get_dictation_context = function('s:GetDictationContext')
