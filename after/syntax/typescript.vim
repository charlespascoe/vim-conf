" syntax clear typescriptReserved
" syntax clear typescriptSource
" highlight link typeDeclaration typescriptReserved
" syntax keyword typescriptReserved constructor declare as module abstract enum int short export static byte extends long super char final native synchronized float package throws goto private transient debugger implements protected volatile double import public namespace get set keyof
" syntax match typescriptReserved /\(\s\|^\)\(from\|export\)\(\s\|$\)/
" highlight link typescriptReserved Statement

" Assignment and Operators
syntax match tsOperators /\(<\|>\)=\|\(=\|!\)==\?\|!\|+\|-\|\*\|%\|&\||/
syntax match tsSeparators /:\|\.\|,\|;\|?\|=>/
highlight link tsOperators Operator
highlight link tsSeparators Operator

" Types
syntax match typeDeclarationName contained /\<\([A-Z][a-z]*\)\+\>/
syntax match typeName /\<\([A-Z][a-z]*\)\+\>/
syntax region typeDeclaration start=/\(class\|interface\|type\)\s\+/ end=/\s\+/ contains=typeDeclarationName keepend
highlight link typeName Type
highlight typeDeclarationName ctermfg=none

" Functions
syntax match tsFunctionCall /[a-z$][a-zA-Z$0-9_-]*(/me=e-1 nextgroup=tsFunctionCallParens
highlight link tsFunctionCall Function
syntax region tsFunctionCallParens matchgroup=FunctionParens start='(' end=')' contained transparent

" Parens etc.
highlight! link typescriptParens Delimiter

syntax match shebang /^#!.*$/
highlight link shebang Comment

hi link typescriptBraces Delimiter
