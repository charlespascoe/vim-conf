syntax keyword Keyword await
syntax keyword csModifier async

" Interpolated Strings
syntax region interpolatedStringValue start="{" end="}" contained
syntax region interpolatedString start="$\"" end="\"" skip="\\\"" contains=interpolatedStringValue,csSpecialChar,csSpecialError,csUnicodeNumber
highlight def link interpolatedString String
highlight def link interpolatedStringValue Special
