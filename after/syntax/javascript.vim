" Interpolated Strings
syntax region interpolatedStringValue start="\${" end="}" contained
syntax region interpolatedString start="`" end="`" skip="\\`" contains=interpolatedStringValue
highlight def link interpolatedString String
highlight def link interpolatedStringValue Special

syntax region regexp start='/' end='/[gi]*' skip='\\/'
highlight link regexp Constant

syntax match comment /\/\/.*$/
highlight link comment Comment


" Reserved words
syntax clear javaScriptReserved
syntax keyword javaScriptReserved long transient float int synchronized protected static interface private final implements import goto volatile double short boolean char throws native enum public byte debugger package abstract extends super of get set async await yield as constructor
syntax match javaScriptReserved /\(\s\|^\)\(from\|export\)\(\s\|$\)/

syntax keyword javaScriptIdentifier global

" Storage
syntax keyword StorageClass var let const
highlight link StorageClass Statement

" Assignment and Operators
syntax match jsAssignment /=/
syntax match jsOperators /<\|>\|<<\|>>\|\(<\|>\)=\|\(=\|!\)==\?\|!\|+\|-\|\*\|%\|&\||/
syntax match jsSeparators /:\|\.\|,\|;\|=>/
highlight jsAssignment ctermfg=202
highlight jsOperators ctermfg=214
highlight jsSeparators ctermfg=214

" Types
syntax match typeDeclarationName contained /\<\([A-Z][a-z]*\)\+\>/
syntax match typeName /\<\([A-Z][a-z]*\)\+\>/
syntax region typeDeclaration start=/class\s\+/ end=/\s\+/ contains=typeDeclarationName keepend
highlight link typeDeclaration javaScriptReserved
highlight link typeName Type
highlight typeDeclarationName ctermfg=none
highlight link javaScriptNull Type

" Functions
syntax match jsFunctionName /[a-z$][a-zA-Z$0-9_-]*(/me=e-1
highlight jsFunctionName ctermfg=none
syntax match jsFunctionCall /[a-z$][a-zA-Z$0-9_-]*(/me=e-1
highlight jsFunctionCall ctermfg=123

syntax clear javaScriptFunction
syntax match javaScriptFunction /function\s\+/ nextgroup=jsFunctionName
highlight link javaScriptFunction Identifier

" Constants
highlight link javaScriptValue Constant

" Parens etc.
highlight javaScriptParens ctermfg=39

syntax match shebang /^#!.*$/
highlight link shebang Comment
