syntax match zshKSHFunction '\S\+\ze\s*('         nextgroup=zshFuncParentheses contained
syntax match zshFunction    '^\s*\zs\k\+\ze\s*()' nextgroup=zshFuncParentheses

syntax region zshBraces          matchgroup=Delimiter      start='{'  skip='\\}'  end='}'  fold      transparent
syntax region zshBrackets        matchgroup=Delimiter      start='\[' skip='\\\]' end='\]' fold      transparent
syntax region zshParentheses     matchgroup=Delimiter      start='('  skip='\\)'  end=')'  fold      transparent
syntax region zshFuncParentheses matchgroup=FunctionParens start='('  skip='\\)'  end=')'  contained contains=TOP

syntax match zshSemicolon /;/

syntax clear zshCase
syntax clear zshCaseIn
syntax clear zshCasePattern

syntax region  zshCase        matchgroup=Keyword start='case' end='esac' contains=TOP fold
syntax keyword zshCaseIn      in   containedin=zshCase contained
syntax match   zshCasePattern /)$/ containedin=zshCase contained

hi link zshCase        None
hi link zshCaseIn      Keyword
hi link zshCasePattern Delimiter
hi link zshCasePattern Delimiter
hi link zshFunction    Function
hi link zshOperator    Operator
hi link zshOption      Special
hi link zshSemicolon   Delimiter
hi link zshSubstDelim  Delimiter
hi link zshVariableDef Identifier
