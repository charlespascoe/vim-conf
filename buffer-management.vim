set hidden

nmap <silent> <leader>d <Cmd>Bdelete<CR>
nmap <silent> <leader><BS> <Cmd>q<CR>
nmap <silent> <leader><space> <Cmd>b#<CR>zz
nmap <leader>w <C-w>p
nmap <C-w>\| <C-w>v
nmap <C-w>\ <C-w>s

fun! CloseBuffer()
    Bdelete

    if len(getbufinfo({'buflisted':1})) == 0
        q
    en
endf

" keepjumps leaves `` etc. unchanged during the command; useful for plugins
" (like vim-go) that do stuff like this on change (these need to be '<Esc>:'
" because they must always return to normal mode and clear any other pending
" actions)
inoremap <silent> <C-s> <Esc>:keepjumps wa<CR>
nnoremap <silent> <C-s> <Esc>:keepjumps wa<CR>
nnoremap ZX <Cmd>wqa<CR>

" Deletes the session file before quitting
nnoremap ZQ <Cmd>Obsession! \| wqa<CR>

command! CloseAll :bufdo bdelete

" Always open quickfix at the bottom (full width)
autocmd filetype qf wincmd J
