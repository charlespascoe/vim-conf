set hidden

nmap <silent> <leader>d <Esc>:Bdelete<CR>
nmap <silent> <leader><BS> <Esc>:q<CR>
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
nnoremap <C-c> <Esc>:wqa<CR>
inoremap <C-c> <Esc>:wqa<CR>

command! CloseAll :bufdo bdelete

" Always open quickfix at the bottom (full width)
autocmd filetype qf wincmd J
