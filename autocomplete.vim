" Map C-z to C-p (allows it to be overriden to C-x C-o - Omnicomplete - in
" some files)
inoremap <C-z> <C-p>

" Set complete options
setlocal completeopt=longest,menuone

fun! ShouldAutocomplete()
    return pumvisible() || !(strpart(getline('.'), 0, col('.') - 1) =~ '^\s*$')
endfun

" Map tab to C-z (custom autocomplete) if autocomplete menu is open or there
" is already text on the current line
imap <expr> <Tab> ShouldAutocomplete() ? '<C-z>' : '<Tab>'
imap <expr> <Up> pumvisible() ? '<C-p>' : '<Up>'
imap <expr> <Down> pumvisible() ? '<C-n>' : '<Down>'

" TODO: Fix
"imap <expr> <BS> pumvisible() ? (col('.') > 1 ? '<Esc>i<Right><BS>' : '<Esc>i<BS>') : '<BS>'
