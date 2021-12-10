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
