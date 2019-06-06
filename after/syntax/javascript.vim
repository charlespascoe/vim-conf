" Interpolated Strings
syntax region interpolatedStringValue start="\${" end="}" contained
syntax region interpolatedString start="`" end="`" skip="\\`" contains=interpolatedStringValue
highlight def link interpolatedString String
highlight def link interpolatedStringValue Special

syntax clear javaScriptReserved
syntax keyword javaScriptReserved long transient float int synchronized protected static interface private final implements import goto export volatile double short boolean char throws native enum public byte debugger package abstract extends super of from get set async await yield as constructor
syntax keyword StorageClass var let const

syntax match separators /:\|\.\|,\|;/
syntax match typeDeclarationName contained /\<\([A-Z][a-z]*\)\+\>/
syntax match typeName /\<\([A-Z][a-z]*\)\+\>/
syntax region typeDeclaration start=/class\s\+/ end=/\s\+/ contains=typeDeclarationName keepend
syntax match functionCall /[a-z$][a-zA-Z$0-9_-]*(/me=e-1


highlight link StorageClass Statement
highlight link typeDeclaration javaScriptReserved
highlight link typeName Type
highlight separators ctermfg=214
highlight typeDeclarationName ctermfg=none
highlight functionCall ctermfg=123

highlight javaScriptParens ctermfg=39
