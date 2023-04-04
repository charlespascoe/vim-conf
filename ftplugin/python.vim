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
call QuickSearchMap('m', 'Methods', '^\s\+\Kdef [a-zA-Z0-9_]\+(self\>')

let b:ale_fix_on_save = 1

fun s:GetDictationContext()
    let syn = synIDattr(synIDtrans(synID(line("."),max([col(".")-1,1]),1)),"name")

    let prompt = ''
    let transforms = ['snakecase']

    if syn == 'Comment'
        let prompt = dictate#GetLeadingComment()
        let transforms = ['comment']
    elseif syn == 'String'
        let prompt = dictate#GetLeadingString()
        " TODO: Check to see if it's actually a double-quoted versus a
        " single-quoted string
        let transforms = ['default', 'dqesc']
    elseif syn == 'Function'
        let prompt = 'The function name is:'
        let transforms = ['snakecase']
    elseif syn == 'Type'
        let prompt = 'The class name is:'
        let transforms = ['pascalcase']
    endif

    return #{prompt: prompt, transforms: transforms}
endfun

let b:get_dictation_context = function('s:GetDictationContext')
