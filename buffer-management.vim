set hidden

nmap <silent> <leader>t <Esc>:tabnext<CR>
nmap <silent> <leader>T <Esc>:tabprev<CR>
nmap <silent> bb <Esc>:b#<CR>
nmap <silent> bq <Esc>:call CloseBuffer() \| call SaveBuffers()<CR>
nmap <silent> bw <Esc>:w<CR>:call CloseBuffer() \| call SaveBuffers()<CR>


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
        if filereadable(proj_buff)
            execute 'edit '.fnameescape(proj_buff)
        endif
    endfor
endfun


fun! SaveBuffers()
    if !exists('g:proj_buffers_file') || g:proj_buffers_file == ''
        return
    endif

    let buffs = getbufinfo({'buflisted': 1})
    let buffs = map(buffs, 'v:val["name"]')
    let buffs = map(buffs, 'fnamemodify(v:val, ":.")')
    let buffs = filter(buffs, 'v:val != bufname("")')
    let buffs = add(buffs, bufname(''))
    let buffs = filter(buffs, 'filereadable(v:val)')

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
