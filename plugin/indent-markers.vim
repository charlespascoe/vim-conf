" Indent marker colour and appearance is set using the SpecialKey highlight
" group

" Set indent level marker for tab-indented files
set listchars+=tab:│\  list

" Set indent level marker based on shiftwidth for space-indented files

fun s:SetIndentMarker()
    let lc = &l:listchars

    if lc == ''
        let lc = &listchars
    end

    let lcopts = filter(split(lc, ','), 'v:val !~ "^leadmultispace"')

    let sw = &l:shiftwidth

    if sw == 0
        let sw = &shiftwidth
    end

    if index(get(g:, 'indent_marker_ignore_filetypes', []), &ft) >= 0
        let sw = 0
    endif

    if sw > 0
        call add(lcopts, 'leadmultispace:│'.repeat(' ', sw-1))
    endif

    let &l:listchars = join(lcopts, ',')
endfun

au BufReadPost,BufEnter * call <SID>SetIndentMarker()
au OptionSet shiftwidth call <SID>SetIndentMarker()
