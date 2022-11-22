if &diff
    syntax off
else
    syntax enable
endif

set termguicolors
colorscheme custom

" Change line number colours to indicate mode
function! InsertModeChanged(mode)
    if a:mode == 'i'
        highlight LineNr ctermfg=45 guifg=#00d7ff
        highlight CursorLineNr ctermfg=33 guifg=#0087ff
    elseif a:mode == 'r' || a:mode == 'v'
        highlight LineNr ctermfg=202 guifg=#ff5f00
        highlight CursorLineNr ctermfg=196 guifg=#ff0000
    else
        highlight LineNr ctermfg=244 guifg=#808080
        highlight CursorLineNr ctermfg=238 guifg=#444444
    endif
endfunction


autocmd InsertEnter * call InsertModeChanged(v:insertmode)
autocmd InsertLeave * call InsertModeChanged('')
call InsertModeChanged('')

" Trailing Whitespace
highlight TrailingWhitespace ctermfg=1 guifg=#870000 ctermbg=none cterm=underline
match TrailingWhitespace /\s\+$/
au InsertEnter * match TrailingWhitespace /\s\+\%#\@<!$/
au InsertLeave * match TrailingWhitespace /\s\+$/
