" Map C-z to C-p (allows it to be overriden to C-x C-o - Omnicomplete - in
" some files)
inoremap <C-z> <C-p>

" Set complete options
set completeopt=longest,menu

fun! ShouldAutocomplete()
    return pumvisible() || !(strpart(getline('.'), 0, col('.') - 1) =~ '^\s*$')
endfun

" Map tab to C-z (custom autocomplete) if autocomplete menu is open or there
" is already text on the current line
imap <expr> <Tab> ShouldAutocomplete() ? '<C-z>' : '<Tab>'

" Arrow keys to cycle and select options
imap <expr> <Up> pumvisible() ? '<C-p>' : '<Up>'
imap <expr> <Down> pumvisible() ? '<C-n>' : '<Down>'

" Cancel autocomplete on backspace
" (TODO: Fix delimitMate problem (this imap set before delimitMate does on
" line 330, meaning it doesn't set its own binding. Need to find way of
" setting after delimitMate)
autocmd BufRead * imap <expr> <buffer> <BS> pumvisible() ? '<C-e>' : '<Plug>delimitMateBS'
