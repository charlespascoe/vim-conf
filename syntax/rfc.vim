" Based on https://github.com/vim-scripts/rfc-syntax but with various
" improvements

syntax clear
syntax case match

if get(g:, 'rfc_highlight_punctuation', 1)
    syntax match rfcPunctuation /[,:;.()-]/
    hi link rfcPunctuation Operator
endif

if get(g:, 'rfc_highlight_sip_methods', 1)
    syn keyword rfcSipMethods ACK BYE CANCEL INFO INVITE MESSAGE NOTIFY OPTIONS PRACK PUBLISH REFER REGISTER SUBSCRIBE UPDATE
    hi link rfcSipMethods Type
endif

if get(g:, 'rfc_highlight_sip_response_codes', 1)
    syntax match rfcResponseCode /\c\d\@<![1-6]\(\d\{2\}\|xx\)\ze[^[:number:]]/
    hi link rfcResponseCode Number
endif

if get(g:, 'rfc_highlight_quoted_strings', 1)
    syntax region rfcQuotedString start='"' end='"' keepend contains=TOP
    hi link rfcQuotedString String
endif

syn match rfcTitle      /^\v%<30l\s{4,40}\zs\S.*$/
syn match rfcHeading    /^\v(\n)@<!\S.*$/
syn match rfcHeader     /^\v%<30l\w+.*%(\n\w+)+.*$/

syn match rfcPageHeader /^\v(\n)@<=RFC.*$/
syn match rfcPageFooter /^\S.*\ze\n/

syn match rfcReference  /\[\w\+\]/
syn match rfcRef        /(^\s\+)\@20<!\[\w\+\]/
syn match rfcRFCRef     /\v.@<=%(RFC|STD)\s+[0-9]+|ANSI\s+[0-9A-Z-.]+/ containedin=ALL
syn match rfcSectionRef /^\v\s*\zs(\d+.)+/ contained
syn match rfcPageRef    /\d\+$/ contained

syn match rfcContents   /^\v\s+(([A-Z]\.)?([0-9]+\.?)+|Appendix|Full Copyright Statement).*(\n.*)?(\s|\.)\d+$/ contains=rfcSectionRef,rfcPageRef

syn keyword rfcNote     NOTE note: Note: NOTE: Notes Notes:

" Highlight [sic] here so it won't be highlighted as rfcRef
syn match   rfcKeyword "\[sic\]"
syn match   rfcKeyword "\%(MUST\|SHALL\|SHOULD\)\%(\_[[:space:]]\+NOT\)\?"
syn keyword rfcKeyword REQUIRED RECOMMENDED MAY OPTIONAL

hi link rfcTitle      Title
hi link rfcHeading    Underlined
hi link rfcPageHeader PreProc
hi link rfcPageFooter PreProc
hi link rfcNote       Todo
hi link rfcKeyword    Keyword
hi link rfcHeader     PreProc

hi link rfcReference  Special
hi link rfcRef        Tag
hi link rfcSectionRef rfcRef
hi link rfcPageRef    rfcRef
hi link rfcRFCRef     Underlined

let b:current_syntax = "rfc"
