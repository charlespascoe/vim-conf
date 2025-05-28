call QuickSearchMap('s', 'Sections', '^:: .\+ ::$')

let b:delimitMate_expand_cr = 0

iabbr rsa RSA
iabbr crc CRC

" En dash shortcut
iabbr -- –

setlocal spell
setlocal conceallevel=2

call bulletnotes#InitBuffer()

let b:invert_binary_subs = [['*', '+']]

let b:get_dictation_prompt = function('dictation#GetLeadingParagraph')
