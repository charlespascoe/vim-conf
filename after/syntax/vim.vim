" Remove leading whitespace from Vim line comments when indented
syntax match LeadingWhitespace /^[ \t]*/ contained
syntax match vimLineComment /^[ \t:]*".*$/  contains=@vimCommentGroup,vimCommentString,vimCommentTitle,LeadingWhitespace
