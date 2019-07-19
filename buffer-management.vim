set hidden

nmap <silent> <leader>Tn <Esc>:tabnew<CR>
nmap <silent> <leader>bb <Esc>:b#<CR>zz
nmap <silent> <leader>bq <Esc>:call CloseBuffer()<CR>
nmap <silent> <leader>bw <Esc>:w<CR>:call CloseBuffer()<CR>
nmap <silent> <leader><space> <Esc>:b#<CR>zz


fun! CloseBuffer()
    Bdelete

    if len(getbufinfo({'buflisted':1})) == 0
        q
    en
endf

inoremap <C-s> <Esc>:wa<CR>
nnoremap <C-s> <Esc>:wa<CR>
nnoremap <C-q> <Esc>:q<CR>

command! Q wqa

command! CloseAll :bufdo bdelete

" Make it easier to close multiple buffers
nnoremap <leader>lsd :ls<cr>:bd<space>

" Always open quickfix at the bottom (full width)
autocmd filetype qf wincmd J
