" Vim syntax file
" Language: Ragel
" Author Charles Pascoe
" Heavily influnced by the Ragel syntax file by Adrian Thurston (e.g. naming
" convention, some groups)

" Comments
syntax match rlComment "#.*$" contained

syntax region machineSpecBlock matchgroup=beginRL start="%%{" end="}%%" contains=@rlItems
syntax region machineSpecLine matchgroup=beginRL start="%%\ze[^{]" end="$" oneline contains=@rlItems

syntax cluster rlItems contains=rlNestedCodeBlock,
    \rlArrow,
    \rlAssignment,
    \rlBuiltIns,
    \rlColon,
    \rlComment,
    \rlComplexAction,
    \rlExprKeyword,
    \rlExprOperator,
    \rlIdentifier,
    \rlKeyword,
    \rlLiteral,
    \rlNegation,
    \rlNumber,
    \rlParenBlock,
    \rlRepetition,
    \rlScanner,
    \rlSemicolon,
    \rlTransitionActions,
    \rlWriteKeyword

" Identifiers
syntax match rlIdentifier /[a-zA-Z_][a-zA-Z_0-9]*/ contained

" Basic Keywords
syntax keyword rlKeyword contained access action alphtype getkey include machine postpop prepush variable
syntax keyword rlExprKeyword contained eof err from inwhen lerr outwhen to when

syntax keyword rlWriteKeyword write contained skipwhite nextgroup=@rlWriteComponent,rlInvalidWriteOpt
syntax match rlInvalidWriteOpt /\<[^[:space:];]\+\>\%#\@<!/ contained skipwhite nextgroup=rlInvalidWriteOpt

syntax cluster rlWriteComponent contains=rlWriteData,rlWriteExec,rlWriteInit,rlWriteSimple

syntax keyword rlWriteData data contained skipwhite nextgroup=rlWriteDataOpt,rlInvalidWriteOpt
syntax keyword rlWriteDataOpt noerror nofinal noentry noprefix skipwhite nextgroup=rlWriteDataOpt,rlInvalidWriteOpt

syntax keyword rlWriteExec exec contained skipwhite nextgroup=rlWriteExecOpt,rlInvalidWriteOpt
syntax keyword rlWriteExecOpt noend contained skipwhite nextgroup=rlInvalidWriteOpt

syntax keyword rlWriteInit init contained skipwhite nextgroup=rlWriteInitOpt,rlInvalidWriteOpt
syntax keyword rlWriteInitOpt nocs contained skipwhite nextgroup=rlInvalidWriteOpt

syntax keyword rlWriteSimple start first_final error exports contained skipwhite nextgroup=rlInvalidWriteOpt


" Nested Code

" TOP refers to all top-level syntax elements as defined by the primary syntax
" definition (plus Ragel's top-level syntax items, such as '%% write', which can
" be used inside these blocks)
syntax region rlNestedCodeBlock matchgroup=rlNestedCodeBraces start='{' end='}' contained contains=TOP

" TODO: Is fstack still a thing?
" TODO: fentry
syntax keyword fsmValue fpc fc fcurs ftargs fstack contained containedin=rlNestedCodeBlock

" By making this a region, it insures that the first word is not highlighted
" unless a corresponding end semicolon is present, acting as a subtle indicator
" that it is missing.
syntax region fsmStatement matchgroup=rlKeyword start='\<f\%(hold\|goto\|call\|ncall\|ret\|nret\|entry\|next\|exec\|break\|nbreak\)\>' matchgroup=rlSemicolon end=';' oneline contained containedin=rlNestedCodeBlock

" Literals
syntax region rlLiteral start='\z(['"/]\)' skip='\\.' end='\z1i\?' oneline contained contains=rlLiteralEscape
syntax region rlLiteral start='\[' skip='\\.' end='\]' oneline contained contains=rlLiteralEscape
syntax match rlLiteralEscape /\\./ contained
syntax match rlNumber /[+-]\?\d\+/ contained
syntax match rlNumber /0x\x\+/ contained

" Built-in rules
syntax keyword rlBuiltIns contained alnum alpha any ascii cntrl digit empty extend graph lower print punct space upper xdigit zlen

" Operators and Symbols

syntax match rlSemicolon /;/ contained
syntax match rlColon /:/ contained

syntax match rlExprOperator /\([.,|&]\|--\?\|<:\|:>>\?\)/ contained
syntax match rlTransitionActions /[>@$%]/ contained
syntax match rlComplexAction /\%([>$%@]\|<>\?\)[!\^/*~]\?/ contained

syntax match rlAssignment /:\?=/ contained

syntax match rlRepetition /\*\*\?/ contained
syntax match rlRepetition /[+?]/ contained
syntax match rlRepetition /{\(\d\+,\d*\|,\d\+\)}/ contained contains=rlRepetitionNumber
syntax match rlRepetitionNumber /\d\+/ contained

syntax match rlNegation /[\^!]/ contained

syntax match rlArrow /[=-]>/ contained

" Grouping
syntax region rlParenBlock matchgroup=rlParens start='(' end=')' contained transparent
syntax region rlScanner matchgroup=rlParens start='|\*' end='\*|' contained transparent

" This actually just highlights the contents after the command and before the
" semicolon
hi link fsmStatement Special

hi link beginRL PreProc
hi link fsmValue Special
hi link rlArrow Operator
hi link rlAssignment Operator
hi link rlBuiltIns Special
hi link rlColon Noise
hi link rlComment Comment
hi link rlComplexAction Operator
hi link rlExprKeyword rlKeyword
hi link rlExprOperator Operator
hi link rlIdentifier Identifier
hi link rlInvalidWriteOpt Error
hi link rlKeyword Keyword
hi link rlLiteral Constant
hi link rlLiteralEscape Special
hi link rlNegation Operator
hi link rlNestedCodeBraces Special
hi link rlNumber Constant
hi link rlParens Parens
hi link rlRepetition Operator
hi link rlRepetitionNumber Constant
hi link rlSemicolon Noise
hi link rlTransitionActions Operator
hi link rlWriteData Special
hi link rlWriteDataOpt Special
hi link rlWriteExec Special
hi link rlWriteExecOpt Special
hi link rlWriteInit Special
hi link rlWriteInitOpt Special
hi link rlWriteKeyword rlKeyword
hi link rlWriteSimple Special
