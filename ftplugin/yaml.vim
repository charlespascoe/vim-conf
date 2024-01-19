setlocal formatoptions+=t
setlocal foldmethod=indent
setlocal foldlevel=100

fun s:GetLeadingParagraph()
    return py3eval('dictate.get_leading_block()')
endfun

let b:get_dictation_prompt = function('s:GetLeadingParagraph')
