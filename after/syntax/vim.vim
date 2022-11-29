" Remove leading whitespace from Vim line comments when indented
syntax match LeadingWhitespace /^[ \t]*/ contained
syntax match vimLineComment /^[ \t:]*".*$/  contains=@vimCommentGroup,vimCommentString,vimCommentTitle,LeadingWhitespace

hi link vimSynType Statement
hi link vimFgBgAttrib Special
hi link vimHiAttrib Special
hi link vimOption Special
hi link vimEscape SpecialChar
hi link vimEnvvar Identifier

syntax keyword vimSource source skipwhite nextgroup=vimPath
hi link vimSource Statement

syntax match vimPath /\S\+/ contained
hi link vimPath Constant
