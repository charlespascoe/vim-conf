hi link pythonFunctionCall FunctionCall

hi link pythonClassVar Special

syntax region pythonBracketBlock matchgroup=Delimiter start='\[' end='\]' transparent extend
syntax region pythonParenBlock   matchgroup=Delimiter start='('  end=')'  transparent extend
syntax region pythonBraceBlock   matchgroup=Delimiter start='{'  end='}'  transparent extend

syntax clear pythonRawString
syntax region pythonCustomRawString start='r"\(""\)' skip='\\"' end='"\z1'
hi link pythonCustomRawString String

hi link pythonStrFormat Operator
