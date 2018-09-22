set hidden

nmap <silent> t <Esc>:tabnext<CR>
nmap <silent> T <Esc>:tabprev<CR>
nmap <silent> bb <Esc>:b#<CR>
nmap <silent> bq <Esc>:call CloseBuffer()<CR>
nmap <silent> bw <Esc>:w<CR>:call CloseBuffer()<CR>


fun! CloseBuffer()
    Bdelete

    if len(getbufinfo({'buflisted':1})) == 0
        q
    en
endf


" Ctrl-a saves all
inoremap <C-a> <Esc>:wa<CR>
nnoremap <C-a> <Esc>:wa<CR>

command! Q wqa

" Project Buffers
fun! ResumeBuffers()
    let buff_count = len(getbufinfo({'buflisted':1}))

    if !(buff_count == 1 && bufname(1) == '')
        return
    endif

    let proj_root = FindProjectRoot(getcwd(), '.proj_buffers')

    if proj_root == ''
        return
    endif

    let g:proj_buffers_file = proj_root.'/.proj_buffers'

    let proj_buffers = readfile(g:proj_buffers_file)

    execute 'cd '.proj_root

    for proj_buff in proj_buffers
        if filereadable(proj_buff)
            execute 'edit '.proj_buff
        endif
    endfor
endfun


fun! SaveBuffers()
    if !exists('g:proj_buffers_file') || g:proj_buffers_file == ''
        return
    endif

    let buffs = getbufinfo({'buflisted': 1})
    let buffs = map(buffs, 'v:val["name"]')
    let buffs = filter(buffs, 'filereadable(v:val)')
    let buffs = map(buffs, 'fnamemodify(v:val, ":.")')

    call writefile(buffs, g:proj_buffers_file)
endfun


autocmd VimEnter * call ResumeBuffers()
autocmd VimLeavePre * call SaveBuffers()
