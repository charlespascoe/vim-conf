setlocal textwidth=80
setlocal spell
setlocal comments=://

" TODO: Fix this momumental hack
fun! FixFormatOptions(timer)
    " Use textwidth for line formatting
    setlocal formatoptions+=t
endfun

" In the few free minutes I had, I was unable to figure out how to override
" asciidoctor's default formatoptions, so I quickly put this together.
" This needs a proper solution.
call timer_start(200, 'FixFormatOptions')

let b:get_dictation_prompt = function('dictate#GetLeadingParagraph')
