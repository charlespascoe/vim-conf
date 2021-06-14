set hidden

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

" keepjumps leaves `` etc. unchanged during the command;
" useful for plugins (like vim-go) that do stuff like this on change
inoremap <C-s> <Esc>:keepjumps wa<CR>
nnoremap <C-s> <Esc>:keepjumps wa<CR>
nnoremap <C-q> <Esc>:q<CR>

nnoremap <silent> ZX <Esc>:wqa<CR>

command! Q wqa

command! CloseAll :bufdo bdelete

" Make it easier to close multiple buffers

" Always open quickfix at the bottom (full width)
autocmd filetype qf wincmd J
