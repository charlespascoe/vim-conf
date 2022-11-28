hi link pythonFunctionCall FunctionCall

hi link pythonClassVar Special

syntax region pythonBracketBlock matchgroup=Delimiter start='\[' end='\]' transparent extend
syntax region pythonParenBlock   matchgroup=Delimiter start='('  end=')'  transparent extend
syntax region pythonBraceBlock   matchgroup=Delimiter start='{'  end='}'  transparent extend
