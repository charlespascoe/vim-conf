fun! EnCompleteFuncWithKeywordFallback(findstart, base)
    if a:findstart
        return EnCompleteFunc(a:findstart, a:base)
    else
        let result = EnCompleteFunc(a:findstart, a:base)

        if len(result) == 0
            call feedkeys("\<c-e>\<c-p>", "nt")
        endif

        return result
    endif
endfun

setlocal omnifunc=EnCompleteFuncWithKeywordFallback
