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

fun s:FormatDictatedText(text)
    if synIDattr(synIDtrans(synID(line("."),max([col(".")-1,1]),1)),"name") =~ '^\%(Comment\|String\|Constant\)$'
        return ''
    endif

    " echom synIDattr(synID(line("."),col("."),1),"name")

    let result = substitute(substitute(a:text, '\<\a', '\U&', 'g'), '\W', '', 'g')

    " let synName = synIDattr(synID(line("."),max([col(".")-1,1]),1),"name")

    " echom "SYN" synName

    " if len(result) > 0 && synName =~ '\v^go%(Func%(Block|Params|Parens|Call%(Parens|Args)))$'
    if len(result) > 0
        let result = tolower(result[0])..result[1:]
    endif

    return result
endfun

let b:format_dictated_text = function('s:FormatDictatedText')

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

fun s:FormatDictatedText(text)
    if synIDattr(synIDtrans(synID(line("."),max([col(".")-1,1]),1)),"name") =~ '^\%(Comment\|String\|Constant\)$'
        return ''
    endif

    echom synIDattr(synID(line("."),col("."),1),"name")

    let result = substitute(substitute(a:text, '\<\a', '\U&', 'g'), '\W', '', 'g')
    " TODO: only do this conditionally - perhaps it's worth doing the formatting
    " in the daemon rather than doing it here
    let result = tolower(result[0])..result[1:]

    return result
endfun

fun s:GetDictationPrompt()
    let syn = synIDattr(synIDtrans(synID(line("."),max([col(".")-1,1]),1)),"name")

    if syn == 'Comment'
        return dictate#GetLeadingComment()
    elseif syn == 'String'
        return dictate#GetLeadingString()
    elseif syn == 'Function'
        return 'The function name is:'
    endif

    return ''
endfun

let b:format_dictated_text = function('s:FormatDictatedText')
let b:get_dictation_prompt = function('s:GetDictationPrompt')
