syntax clear  jsFuncCall
syntax match  jsFuncCall /\<\K\k*\ze[\s\n]*(/ nextgroup=jsFuncCallArgBlock
syntax region jsFuncCallArgBlock matchgroup=jsFuncCallParens start='(' end=')' contained transparent nextgroup=jsFuncCallArgBlock

hi link jsArrowFunction       Noise
hi link jsBrackets            Brackets
hi link jsBuiltins            Function
hi link jsClassDefinition     Type
hi link jsDestructuringAssignment None
hi link jsDestructuringBlock  Identifier
hi link jsDestructuringBraces Braces
hi link jsDestructuringPropertyValue Identifier
hi link jsExceptions          Type
hi link jsExportDefault       PreProc
hi link jsFuncArgCommas       Operator
hi link jsFuncArgs            Identifier
hi link jsFuncBraces          Braces
hi link jsFuncCall            FunctionCall
hi link jsFuncCallParens      SpecialChar
hi link jsFunction            Keyword
hi link jsGlobalNodeObjects   Special
hi link jsGlobalNodeObjects   Type
hi link jsGlobalObjects       Special
hi link jsGlobalObjects       Type
hi link jsIfElseBraces        Braces
hi link jsNull                Constant
hi link jsObjectBraces        Braces
hi link jsObjectKey           Identifier
hi link jsOperator            Operator
hi link jsOperatorKeyword     Statement
hi link jsParens              Parens
hi link jsRepeatBraces        Braces
hi link jsStorageClass        Keyword
hi link jsSuper               Special
hi link jsSwitchBraces        Braces
hi link jsTaggedTemplate      Special
hi link jsTemplateBraces      Operator
hi link jsTryCatchBraces      Braces
hi link jsUndefined           Constant
