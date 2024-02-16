" Map autocomplete trigger onto Omnicomplete
inoremap <buffer> <C-z> <C-x><C-o>

setlocal foldmethod=syntax

if !exists('g:spell_loaded') && filereadable('tags')
    py3file ~/.vim-conf/spell.py
    py3 load_tags()
    let g:spell_loaded = 1
endif

if exists('g:spell_loaded') && g:spell_loaded
    py3 check_spelling()
endif

fun! IndexSpellings()
    py3 gen_tags()
    py3 load_tags()
    py3 check_spelling()
endfun

if !exists("*<SID>TogglePrivate()")
    fun s:TogglePrivate()
        let l:name = expand('<cword>')

        if l:name =~ '^[A-Z]'
            let l:name = tolower(l:name[0])..l:name[1:]
        else
            let l:name = toupper(l:name[0])..l:name[1:]
        endif

        exec "GoRename" l:name
    endfun
endif

fun s:GetDictationContext()
    let syn = synIDattr(synIDtrans(synID(line("."),max([col(".")-1,1]),1)),"name")

    let prompt = ''
    let transforms = ['lowercase', 'pascalcase']

    if syn == 'Comment'
        let prompt = dictation#GetLeadingComment()
        let transforms = ['comment']
    elseif syn == 'String'
        let prompt = dictation#GetLeadingString()
        " TODO: Check to see if it's actually a double-quoted string and not a
        " raw string
        let transforms = ['default', 'dqesc']
    elseif syn == 'Function'
        let prompt = 'The function name is: '
    elseif syn == 'Type'
        let prompt = 'The class name is: '
    endif

    return #{prompt: prompt, transforms: transforms}
endfun

let b:get_dictation_context = function('s:GetDictationContext')

nmap <buffer> <leader>tt <Plug>(go-info)
nmap <buffer> <leader>td <Plug>(go-def)
nmap <buffer> <leader>tD <Plug>(go-def-type)
nmap <buffer> <leader>tr <Plug>(go-referrers)
nmap <buffer> <leader>tC <Plug>(go-coverage-toggle)
nmap <buffer> <leader>ta <Cmd>GoAlternate!<CR>
nmap <buffer> <leader>tR <Esc>:wa<CR><Plug>(go-rename)
nmap <buffer> <leader>tT <Esc>:wa<CR><Plug>(go-test)
nmap <buffer> <leader>tc <Esc>:wa<CR><Plug>(go-build)
nmap <buffer> <leader>tv <Plug>(go-vet)
nmap <buffer> <leader>tF <Cmd>GoFmt<CR>
nmap <buffer> <leader>tfs <Cmd>GoFillStruct<CR>
nmap <buffer> <leader>tP <Cmd>call <SID>TogglePrivate()<Cr>

let b:serenade_go_to_definition_command = 'GoDef'
let b:serenade_style_command = 'exec "GoFmt" | w'

" Update spellings
nmap <buffer> <leader>tS <Cmd>call IndexSpellings()<CR>

call QuickSearchMap('f', 'Functions', '\<func\>')
call QuickSearchMap('F', 'Named Functions', '^func [^(]\+')
call QuickSearchMap('t', 'Types', '^type\>')
call QuickSearchMap('s', 'Structs', '\<struct\>')
call QuickSearchMap('m', 'Methods', '^func ([^)]\+) [a-zA-Z]\+(.*)')
call QuickSearchMap('T', 'Tests', '^func Test')
call QuickSearchMap('R', 'Routes', '\.\(HEAD\\|GET\\|POST\\|PUT\\|PATCH\\|DELETE\)(')

fun! s:AddImport()
    let l:pos = getpos('.')

    normal gg

    let l:import_line = search('^import\s\+($')

    if l:import_line != 0
        normal $
        let l:end_import_line =  searchpair('(', '', ')')

        if l:end_import_line != 0
            normal O""
            startinsert
            return
        end
    end

    call setpos('.', l:pos)
endfun

nmap <buffer> <leader>i <Cmd>call <SID>AddImport()<CR>

hi SpecialKey ctermfg=236

let s:date_formats = [
            \ #{name: 'Year - 2 digits', pattern: '06'},
            \ #{name: 'Year - 4 digits', pattern: '2006'},
            \ #{name: 'Month - Numeric', pattern: '1'},
            \ #{name: 'Month - Numeric, with leading zero', pattern: '01'},
            \ #{name: 'Month - Name, short', pattern: 'Jan'},
            \ #{name: 'Month - Name, long', pattern: 'January'},
            \ #{name: 'Day', pattern: '2'},
            \ #{name: 'Day - With leading zero', pattern: '02'},
            \ #{name: 'Day - With leading whitespace', pattern: '_2'},
            \ #{name: 'Weekday - short', pattern: 'Mon'},
            \ #{name: 'Weekday - long', pattern: 'Monday'},
            \ #{name: 'Hours - 12 hour', pattern: '3'},
            \ #{name: 'Hours - 12 hour, with leading zero', pattern: '03'},
            \ #{name: 'Hours - 24 hour, with leading zero', pattern: '15'},
            \ #{name: 'Minutes', pattern: '4'},
            \ #{name: 'Minutes - With leading zero', pattern: '04'},
            \ #{name: 'Seconds', pattern: '5'},
            \ #{name: 'Seconds - with leading zero', pattern: '05'},
            \ #{name: 'Milliseconds', pattern: '.000'},
            \ #{name: 'Milliseconds - Without trailing zeros', pattern: '.999'},
            \ #{name: 'Microseconds', pattern: '.000000'},
            \ #{name: 'Microseconds - Without trailing zeros', pattern: '.999999'},
            \ #{name: 'Nanoseconds', pattern: '.000000000'},
            \ #{name: 'Nanoseconds - Without trailing zeros', pattern: '.999999999'},
            \ #{name: 'am/pm', pattern: 'pm'},
            \ #{name: 'AM/PM', pattern: 'PM'},
            \ #{name: 'Timezone', pattern: 'MST'},
            \ #{name: 'Offset (-0700)', pattern: '-0700'},
            \ #{name: 'Offset (-07)', pattern: '-07'},
            \ #{name: 'Offset (-07:00)', pattern: '-07:00'},
            \ #{name: 'Offset (Z0700)', pattern: 'Z0700'},
            \ #{name: 'Offset (Z07:00)', pattern: 'Z07:00'},
            \]

fun! s:InsertDateFormat()
    let names = []

    for item in s:date_formats
        call add(names, item.name)
    endfor

    fun! s:PickFormat(id, cmd)
        if a:cmd == -1
            return
        end

        " NOTE: cmd is 1-indexed
        let item = s:date_formats[a:cmd-1]

        call feedkeys(item.pattern)
    endfun

    call popup_menu(names, #{callback: function('s:PickFormat')})
endfun

imap <buffer> <C-g>t <C-o>:call <SID>InsertDateFormat()<CR>


fun! DumpObject(filename='')
    fun! GetModuleName()
        for l:line in readfile('go.mod')
            if l:line =~# '^module'
                return trim(l:line[len('module'):])
            end
        endfor

        return ''
    endfun

    let l:mod = a:filename == '' ? GetModuleName() : a:filename
    let l:filename = l:mod

    let l:item_name = expand('<cword>')

    let l:match = matchlist(getline('.'), 'func ([^[:space:]]\+\([^)]\+\))')

    if len(l:match) > 0
        let l:recv_type = trim(l:match[1])

        if l:recv_type =~ '^\*'
            let l:recv_type = '\'..l:recv_type
        end

        let l:item_name = '\('..l:recv_type..'\)\.'..l:item_name
    end

    if l:mod == ''
        echoerr "Couldn't figure out module name"
        return
    end

    let l:dir = expand('%:h')
    if l:dir == '.'
        let l:dir = ''
    else
        let l:dir = '/'.l:dir
    endif

    let l:path = l:mod.l:dir.'\.'.l:item_name
    let l:path = '^'.l:mod.l:dir.'\.'

    " TODO: Make this a background job
    " make! build

    let t:dump_go_winid = win_getid()
    set cursorline
    hi CursorLine ctermbg=235 cterm=bold
    hi CursorLineNr ctermbg=235 cterm=bold

    au CursorMoved <buffer> call win_execute(t:dump_term_winid, 'match CursorLine /^\s\+'..expand('%:t')..':'..line('.')..'\s.*$/ | call search("'..expand('%:t')..':'..line('.')..'", "wc") | normal zz')

    " TODO: Figure out where the binary is properly
    let l:term_buf = term_start(['go', 'tool', 'objdump', '-s', l:path, l:filename], {'vertical': 1, 'norestore': 1})

    call setbufvar(l:term_buf, '&ft', 'godump')
    let t:dump_term_winid = win_getid()
endfun

command! -nargs=? DumpObject call DumpObject(<f-args>)

if expand('%:~') =~ glob2regpat('~/gotemp/*.go')
    au BufWritePost <buffer> call RunCode()
endif

fun! RunCode()
    let l:winid = win_getid()
    let l:file = expand('%')

    if exists('t:term_winid') && len(getwininfo(t:term_winid)) > 0
        call win_gotoid(t:term_winid)
        call term_start(['go', 'run', l:file], {'curwin': 1})
    else
        call term_start(['go', 'run', l:file], {'vertical': 1})
        let t:term_winid = win_getid()
    end

    call win_gotoid(l:winid)
endfun

if expand('%:t') == 'doc.go'
    " Make package comments automatically wrap
    setlocal formatoptions+=c
endif

py3 import go_snippet_utils

fun ImportCursorKeyword()
    let g:__go_import = py3eval('go_snippet_utils.guess_import(vim.eval("expand(\"<cword>\")")) or ""')

    if g:__go_import == ""
        echoerr "Couldn't figure out import path for ".expand('<cword>')
    else
        py3 go_snippet_utils.go_import(vim.eval('g:__go_import'))
    endif
endfun

nmap <buffer> <leader>I <Cmd>call ImportCursorKeyword()<CR>
