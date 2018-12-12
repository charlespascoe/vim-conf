" Set complete options
setlocal completeopt=longest,menuone

imap <expr> <Up> pumvisible() ? '<C-p>' : '<Up>'
imap <expr> <Down> pumvisible() ? '<C-n>' : '<Down>'

" TODO: Fix
"imap <expr> <BS> pumvisible() ? (col('.') > 1 ? '<Esc>i<Right><BS>' : '<Esc>i<BS>') : '<BS>'
