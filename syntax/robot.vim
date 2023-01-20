syntax cluster robotCommandArgs contains=robotArgument,robotArgumentCont,robotVariable,robotComment

syntax region robotComment start='#' end='$'

syntax match robotHeader /^\*\*\* .* \*\*\*$/

syntax match robotCommand /\a\w*\%( \w\+\)*/ skipwhite nextgroup=@robotCommandArgs

syntax match robotTest /^\%(|\s\+\)\?\a\w*\%( \w\+\)*/ skipwhite nextgroup=@robotCommandArgs

syntax match robotArgument /\S\+\%( \S\+\)*/ contained skipwhite nextgroup=@robotCommandArgs

syntax region robotVariable matchgroup=Special start=/\${/ end=/}/ oneline skipwhite nextgroup=@robotCommandArgs

syntax match robotVariableAssignment /\${[^}]\+}\ze=/ contains=robotVariable nextgroup=robotAssignment

syntax match robotAssignment /=/ skipwhite nextgroup=robotCommand

syntax match robotArgumentCont /\.\.\.\ze\s\{2,\}/ skipwhite nextgroup=@robotCommandArgs

syntax match robotAutocommands /\[\%(Setup\|Teardown\)\]/ skipwhite nextgroup=robotCommand,robotVariable
syntax match robotAutocommands /^Suite Setup/ skipwhite nextgroup=robotCommand,robotVariable

hi link robotComment      Comment
hi link robotHeader       Title
hi link robotCommand      Function
hi link robotTest         Statement
hi link robotArgument     Identifier
hi link robotVariable     Identifier
hi link robotAssignment   Operator
hi link robotArgumentCont Operator
hi link robotAutocommands PreProc
