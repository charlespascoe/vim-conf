syntax enable

colorscheme custom

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
