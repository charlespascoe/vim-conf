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
    let g:deepest_fold = 0

    let l:winview = winsaveview()
    folddoclosed let g:deepest_fold = max([g:deepest_fold, foldlevel('.')])

    if g:deepest_fold > 0
        call winrestview(l:winview)
        let &l:foldcolumn = g:deepest_fold+1
    else
        setlocal foldcolumn=0
    endif
endfun

au SessionLoadPost,CursorHold * call <SID>CheckAnyClosedFolds()
