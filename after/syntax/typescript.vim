syntax clear typescriptReserved
syntax keyword typescriptReserved constructor declare as module abstract enum int short export static byte extends long super char final native synchronized float package throws goto private transient debugger implements protected volatile double import public namespace from get set keyof

syntax match separators /:\|\.\|,\|\;/
syntax match typeDeclarationName contained /\<\([A-Z][a-z]*\)\+\>/
syntax match typeName /\<\([A-Z][a-z]*\)\+\>/
syntax region typeDeclaration start=/\(class\|interface\|type\)\s\+/ end=/\s\+/ contains=typeDeclarationName keepend

highlight link intersection Statement
highlight link StorageClass Statement
highlight link typeDeclaration typescriptReserved
highlight link typeName Type
highlight link union Statement
highlight separators ctermfg=214
highlight typeDeclarationName ctermfg=none

highlight link typescriptFuncKeyword Statement
highlight typescriptParens ctermfg=39
