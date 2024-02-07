" Map C-z to C-p (allows it to be overriden to C-x C-o - Omnicomplete - in
" some files)
inoremap <C-z> <C-p>

" Set complete options
set completeopt=longest,menu

" Remove tag completion (use open files or omnicomplete)
set complete-=t

fun! ShouldAutocomplete()
    let pat = get(b:, 'autocomplete_on_whitespace', 0) ? '^\s*$' : '\%(^\|\s\)$'
    return pumvisible() || !(strpart(getline('.'), 0, col('.') - 1) =~ pat)
endfun

" Map tab to C-z (custom autocomplete) if autocomplete menu is open or there
" is already text on the current line
imap <expr> <Tab> ShouldAutocomplete() ? '<C-z>' : '<Tab>'

" Arrow keys to cycle and select options
imap <expr> <Up> pumvisible() ? '<C-p>' : '<Up>'
imap <expr> <Down> pumvisible() ? '<C-n>' : '<Down>'

" Cancel autocomplete on backspace OR delete comment leader OR default to delimitMate mapping
" (TODO: Fix delimitMate problem; this imap set before delimitMate does on
" line 330, meaning it doesn't set its own binding. Need to find way of
" setting after delimitMate)
" autocmd BufRead,BufNew * imap <expr> <buffer> <BS> pumvisible() ? '<C-e>' : (AfterCommentLeader() ? '<C-w>' : '<Plug>delimitMateBS')
imap <expr> <BS> pumvisible() ? '<C-e>' : (AfterCommentLeader() ? '<C-w>' : '<Plug>delimitMateBS')

function! AfterCommentLeader()
    let comment_leader = trim(split(&commentstring, '%s', 1)[0])

    let before_cursor = py3eval('vim.current.buffer[vim.current.window.cursor[0]-1][0:vim.current.window.cursor[1]]')

    " The '\V' flag means that everything except backslash-escaped characters
    " are treated literally
    return before_cursor =~ '\V\^\s\*' .. escape(comment_leader, '\') .. '\s\*\$'
endfunction
