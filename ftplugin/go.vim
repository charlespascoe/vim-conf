" Map autocomplete trigger onto Omnicomplete
inoremap <buffer> <C-z> <C-x><C-o>

" Turn on spelling for comments
setlocal spell

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
nmap <buffer> <leader>tv <Plug>(go-vet)
nmap <silent> <buffer> <leader>tF <Esc>:GoFmt<CR>

" Update spellings
nmap <silent> <buffer>tS <Esc>:call IndexSpellings()<CR>

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

fun! IndexSpellings()
python3 << endpy
import re
import vim

# TODO: Load once + command to refresh (also run gotags, or run gotags directly)
symbols = set()

symbol_re = re.compile(r'^([A-Za-z0-9_.-]+)\t')

field_tag_re = re.compile(r'`(?:json|yaml):"([^"]+)"')

with open('tags', 'r') as tags:
    for line in tags:
        if line.startswith('!'):
            continue

        match = symbol_re.match(line)

        if match:
            symbols.add(match.group(1))

            for part in match.group(1).split('.'):
                symbols.add(part)

_cur_line = ""

for buf in vim.buffers:
    for line in buf:
        _cur_line = line

        tag_match = field_tag_re.search(_cur_line)

        if tag_match:
            for part in tag_match.group(1).split(','):
                vim.command('silent spellgood! ' + part)

        while True:
            badword, errtype = vim.eval('spellbadword(py3eval("_cur_line"))')

            if not badword:
                break

            if badword in symbols:
                vim.command('silent spellgood! ' + badword)
            else:
                _cur_line = _cur_line.replace(badword, '')

endpy
endfun
