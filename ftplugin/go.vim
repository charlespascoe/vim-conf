" Map autocomplete trigger onto Omnicomplete
inoremap <buffer> <C-z> <C-x><C-o>

" Turn on spelling for comments
setlocal spell

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

nmap <buffer> <leader>tt <Plug>(go-info)
nmap <buffer> <leader>td <Plug>(go-def)
nmap <buffer> <leader>tD <Plug>(go-doc)
nmap <buffer> <leader>tr <Plug>(go-referrers)
nmap <buffer> <leader>tC <Plug>(go-coverage-toggle)
nmap <buffer> <leader>ta <Esc>:GoAlternate!<CR>
nmap <buffer> <leader>tR <Esc>:wa<CR><Plug>(go-rename)
nmap <buffer> <leader>tT <Esc>:wa<CR><Plug>(go-test)
nmap <buffer> <leader>tI <Plug>(go-import)
nmap <buffer> <leader>tc <Esc>:wa<CR><Plug>(go-build)
nmap <buffer> <leader>tv <Plug>(go-vet)
nmap <silent> <buffer> <leader>tF <Esc>:GoFmt<CR>
nmap <buffer> <leader>tfs <Esc>:GoFillStruct<CR>

" Update spellings
nmap <silent> <buffer> <leader>tS <Esc>:call IndexSpellings()<CR>

call QuickSearchMap('f', 'Functions', '\<func\>')
call QuickSearchMap('F', 'Named Functions', '^func [^(]\+')
call QuickSearchMap('t', 'Types', '^type\>')
call QuickSearchMap('s', 'Structs', '\<struct\>')
call QuickSearchMap('m', 'Methods', '^func ([^)]\+) [a-zA-Z]\+(.*)')
call QuickSearchMap('T', 'Tests', '^func Test')
call QuickSearchMap('R', 'Routes', '\.\(HEAD\\|GET\\|POST\\|PUT\\|PATCH\\|DELETE\)(')

fun! AddImport()
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

nmap <silent> <buffer> <leader>i <Esc>:call AddImport()<CR>

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
