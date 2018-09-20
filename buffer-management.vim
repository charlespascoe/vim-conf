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

command Q wqa
