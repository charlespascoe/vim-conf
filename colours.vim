syntax enable

highlight Constant ctermfg=1
highlight Statement ctermfg=3
highlight Visual cterm=reverse ctermbg=black
highlight SpellBad cterm=reverse ctermfg=9 ctermbg=15
highlight Pmenu ctermfg=15 ctermbg=17
highlight PmenuSel ctermfg=11 ctermbg=21
highlight Search ctermbg=52
highlight CursorLine cterm=none

" Change line number colours to indicate mode
function! InsertModeChanged(mode)
   if a:mode == 'i'
        highlight LineNr ctermfg=45
        highlight CursorLineNr ctermfg=33
    elseif a:mode == 'r'
        highlight LineNr ctermfg=202
        highlight CursorLineNr ctermfg=196
    else
        highlight LineNr ctermfg=244
        highlight CursorLineNr ctermfg=238
    endif
endfunction


autocmd InsertEnter * call InsertModeChanged(v:insertmode)
autocmd InsertLeave * call InsertModeChanged('')
call InsertModeChanged('')
