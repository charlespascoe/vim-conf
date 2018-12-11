set hidden

nmap <silent> <leader>Tt <Esc>:tabnext<CR>
nmap <silent> <leader>TT <Esc>:tabprev<CR>
nmap <silent> <leader>bb <Esc>:b#<CR>
nmap <silent> <leader>bq <Esc>:call CloseBuffer() \| call SaveBuffers()<CR>
nmap <silent> <leader>bw <Esc>:w<CR>:call CloseBuffer() \| call SaveBuffers()<CR>


fun! CloseBuffer()
    Bdelete

    if len(getbufinfo({'buflisted':1})) == 0
        q
    en
endf


inoremap <C-s> <Esc>:wa<CR>
nnoremap <C-s> <Esc>:wa<CR>

command! Q wqa

" Project Buffers
fun! ResumeBuffers()
    let proj_root = FindProjectRoot(getcwd(), '.proj_buffers')

    if proj_root == ''
        return
    endif

    let g:proj_buffers_file = proj_root.'/.proj_buffers'

    if !filereadable(g:proj_buffers_file)
        unlet g:proj_buffers_file
        return
    endif

    let proj_buffers = readfile(g:proj_buffers_file)

    execute 'cd '.proj_root

    for proj_buff in proj_buffers
        let f = substitute(proj_buff, ':[0-9]\+$', '', 'g')
        let l = substitute(matchstr(proj_buff, ':[0-9]\+$'), '^:', '', 'g')
        if filereadable(f)
            execute 'edit '.fnameescape(f)
            execute l
            normal zz
        endif
    endfor
endfun


fun! SaveBuffers()
    if !exists('g:proj_buffers_file') || g:proj_buffers_file == ''
        return
    endif

    let buffs = getbufinfo({'buflisted': 1})
    let buffs = filter(buffs, 'filereadable(v:val["name"]) && fnamemodify(v:val["name"], ":.") != bufname("")')
    let buffs = map(buffs, 'fnamemodify(v:val["name"], ":.") . ":" . v:val["lnum"]')
    let buffs = add(buffs, fnamemodify(bufname(''), ":.") . ":" . line('.'))

    call writefile(buffs, g:proj_buffers_file)
endfun

fun! InitBuffers()
    let buff_count = len(getbufinfo({'buflisted':1}))

    if !(buff_count == 1 && bufname(1) == '')
        return
    endif

    call ResumeBuffers()
endfun

autocmd VimEnter * nested call InitBuffers()

autocmd VimLeavePre * call SaveBuffers()

autocmd BufCreate * call SaveBuffers()
