syntax keyword javascriptStatement of from get set async await yield as
syntax keyword javaScriptType Buffer

" Interpolated Strings
syntax region interpolatedStringValue start="\${" end="}" contained
syntax region interpolatedString start="`" end="`" skip="\\`" contains=interpolatedStringValue
highlight def link interpolatedString String
highlight def link interpolatedStringValue Special

" Regex
"syntax region customRegexCharacterClass start="\[" end="\]" skip="\/" contained
"syntax region customRegex start="/" end="/" skip="\\/" contains=customRegexCharacterClass

"highlight def link customRegex String
