" Based on https://github.com/vim-scripts/rfc-syntax but with various
" improvements

syntax clear
syntax case match

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
    syntax match rfcQuoteBracket /(")/
    hi link rfcQuotedString String
endif

" This seems to be the only way of checking that a heading occurs with a blank
" leading and preceeding line
syn match rfcEmptyLine /^$/        skipempty nextgroup=rfcHeading
syn match rfcHeading   /^\S.*\ze\n\n/ contained

syn match rfcTitle      /^\v%<30l\s{4,40}\zs\S.*$/
syn match rfcHeader     /^\v%<30l\w+.*%(\n\s*\w.*)+.*/

syn match rfcPageHeader /^\v(\n)@<=RFC.*$/
syn match rfcPageFooter /^\S.*\ze\n/

syn match rfcReference  /\[[[:alnum:]-]\+\]/
syn match rfcRef        /(^\s\+)\@20<!\[\w\+\]/
syn match rfcRFCRef     /\v.@<=%(RFC|STD)\_[[:space:]]+[0-9]+|ANSI\s+[0-9A-Z-.]+/ contains=rfcLeadingWs containedin=ALL
syn match rfcSectionRef /^\v\s*\zs(\d+\.?)+/ contained
syn match rfcSectionRef /^\v\s*\zs[A-Z]\.(\d+\.?)*/ contained
syn match rfcPageRef    /\d\+$/ contained

syn match rfcContents /^\v\s+(\d+\.?)+.*(\n.*)?(\s|\.)\d+$/            contains=rfcSectionRef,rfcPageRef skipwhite skipempty nextgroup=rfcContents
syn match rfcContents /^\v\s+[A-Z]\.(\d+\.?)*.*(\n.*)?(\s|\.)\d+$/     contains=rfcSectionRef,rfcPageRef skipwhite skipempty nextgroup=rfcContents
syn match rfcContents /^\v\s+([[:alnum:]'-]+)[^.].*(\n.*)?(\s|\.)\d+$/ contains=rfcSectionRef,rfcPageRef skipwhite skipempty nextgroup=rfcContents contained

syntax match rfcListItem /^\(\s\+\)\zs\%([o-]\|\d\d\?\.\)\ze\s.*\n\%(\n\|\1\s\s\)/

syn match rfcNote       /\cnotes\?:/
syn match rfcWarning       /\cwarning:/

syntax include @abnf syntax/abnf.vim
syntax region rfcAbnf start='^\s*\a[[:alnum:][:digit:]-]*\s\+=\s\+' end='\ze\n$' keepend contains=@abnf

syntax region rfcUrl matchgroup=Special start='<\zehttps\?://' end='>' contains=rfcLeadingWs

" Highlight [sic] here so it won't be highlighted as rfcRef
syn match   rfcKeyword "\[sic\]"
syn match   rfcKeyword "\%(MUST\|SHALL\|SHOULD\)\%(\_[[:space:]]\+NOT\)\?"
syn keyword rfcKeyword REQUIRED RECOMMENDED MAY OPTIONAL

syntax match rfcLeadingWs /^\s\+/ contained

hi link rfcTitle      Title
hi link rfcHeading    Underlined
hi link rfcPageHeader PreProc
hi link rfcPageFooter PreProc
hi link rfcNote       Todo
hi link rfcWarning      rfcNote
hi link rfcKeyword    Keyword
hi link rfcHeader     PreProc

hi link rfcReference  Special
hi link rfcRef        Tag
hi link rfcSectionRef rfcRef
hi link rfcPageRef    rfcRef
hi link rfcRFCRef     Underlined
hi link rfcUrl Underlined
hi link rfcLeadingWs Ignore
hi link rfcListItem SpecialChar

let b:current_syntax = "rfc"
