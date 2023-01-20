" Disable folding by default, but enable it based on filetype
set nofoldenable
set foldcolumn=0

fun! FoldText()
    return substitute(getline(v:foldstart), '\t', repeat(' ', &l:tabstop), 'g')
endfun


set foldtext=FoldText()
set fillchars+=fold:\ ,foldsep:│,foldopen:▼,foldclose:▶,
set foldlevel=100

fun! s:CheckAnyClosedFolds()
    " Only check for folds in normal windows
    if win_gettype() != ''
        return
    endif

    let g:deepest_fold = 0

    let l:winview = winsaveview()
    folddoclosed let g:deepest_fold = max([g:deepest_fold, foldlevel('.')])

    if g:deepest_fold > 0
        call winrestview(l:winview)
        let &l:foldcolumn = min([g:deepest_fold+1, 5])
    else
        setlocal foldcolumn=0
    endif
endfun

au SessionLoadPost,CursorHold * call <SID>CheckAnyClosedFolds()
