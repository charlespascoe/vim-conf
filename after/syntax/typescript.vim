syntax clear typescriptReserved
syntax clear typescriptSource
highlight link typeDeclaration typescriptReserved
syntax keyword typescriptReserved constructor declare as module abstract enum int short export static byte extends long super char final native synchronized float package throws goto private transient debugger implements protected volatile double import public namespace get set keyof
syntax match typescriptReserved /\(\s\|^\)\(from\|export\)\(\s\|$\)/
highlight link typescriptReserved Statement



" Assignment and Operators
syntax match tsAssignment /=/
syntax match tsOperators /\(<\|>\)=\|\(=\|!\)==\?\|!\|+\|-\|\*\|%\|&\||/
syntax match tsSeparators /:\|\.\|,\|;\|=>/
highlight tsAssignment ctermfg=202
highlight tsOperators ctermfg=214
highlight tsSeparators ctermfg=214

" Types
syntax match typeDeclarationName contained /\<\([A-Z][a-z]*\)\+\>/
syntax match typeName /\<\([A-Z][a-z]*\)\+\>/
syntax region typeDeclaration start=/\(class\|interface\|type\)\s\+/ end=/\s\+/ contains=typeDeclarationName keepend
highlight link typeName Type
highlight typeDeclarationName ctermfg=none

" Functions
syntax match functionCall /[a-z$][a-zA-Z$0-9_-]*(/me=e-1
highlight functionCall ctermfg=123

syntax match tsFunctionName /[a-z$][a-zA-Z$0-9_-]*(/me=e-1
highlight tsFunctionName ctermfg=none
syntax match tsFunctionCall /[a-z$][a-zA-Z$0-9_-]*(/me=e-1
highlight tsFunctionCall ctermfg=123

syntax clear typescriptFuncKeyword
syntax match typescriptFuncKeyword /function\s\+/ nextgroup=tsFunctionName
highlight link typescriptFuncKeyword Identifier

" Parens etc.
highlight typescriptParens ctermfg=39
