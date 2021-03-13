" Map autocomplete trigger onto Omnicomplete
inoremap <buffer> <C-z> <C-x><C-o>

nmap <buffer> <leader>tt <Plug>(go-info)
nmap <buffer> <leader>td <Plug>(go-def)
nmap <buffer> <leader>tD <Plug>(go-doc)
nmap <buffer> <leader>tr <Plug>(go-referrers)
nmap <buffer> <leader>tc <Plug>(go-coverage-toggle)
nmap <buffer> <leader>tR <Esc>:wa<CR><Plug>(go-rename)
nmap <buffer> <leader>tT <Esc>:wa<CR><Plug>(go-test)
nmap <buffer> <leader>tI <Plug>(go-import)
nmap <buffer> <leader>tf $ca" ()<Left><CR><C-r>"
nmap <buffer> <leader>tb <Esc>:wa<CR><Plug>(go-build)
nmap <silent> <buffer> <leader>tF <Esc>:GoFmt<CR>


call QuickSearchMap('f', 'Functions', '\<func\>')
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
