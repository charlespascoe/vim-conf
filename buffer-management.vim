set hidden

nmap <silent> <leader>Tn <Esc>:tabnew<CR>
nmap <silent> <leader>bb <Esc>:b#<CR>zz
nmap <silent> <leader>bq <Esc>:call CloseBuffer()<CR>
nmap <silent> <leader>bw <Esc>:w<CR>:call CloseBuffer()<CR>
nmap <silent> \| <Esc>:b#<CR>zz


fun! CloseBuffer()
    Bdelete

    if len(getbufinfo({'buflisted':1})) == 0
        q
    en
endf

inoremap <C-s> <Esc>:wa<CR>
nnoremap <C-s> <Esc>:wa<CR>

command! Q wqa

command! CloseAll :bufdo bdelete
