" Indent marker colour and appearance is set using the SpecialKey highlight
" group

" Set indent level marker for tab-indented files
set listchars+=tab:│\  list

" Set indent level marker based on shiftwidth for space-indented files

fun s:GetShiftwidth()
    for v in [&l:shiftwidth, &shiftwidth, &l:tabstop, &tabstop]
        if v != 0
            return v
        endif
    endfor

    return 0
endfun

fun s:SetIndentMarker()
    let lc = &l:listchars

    if lc == ''
        let lc = &listchars
    end

    let lcopts = filter(split(lc, ','), 'v:val !~ "^leadmultispace"')

    if index(get(g:, 'indent_marker_ignore_filetypes', []), &ft) >= 0
        let sw = 0
    else
        let sw = s:GetShiftwidth()
    endif

    if sw > 0
        call add(lcopts, 'leadmultispace:│'.repeat(' ', sw-1))
    endif

    let &l:listchars = join(lcopts, ',')
endfun

au BufReadPost,BufEnter * call <SID>SetIndentMarker()
au OptionSet shiftwidth call <SID>SetIndentMarker()
