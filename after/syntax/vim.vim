syntax iskeyword @,48-57,_,192-255,#

" Remove leading whitespace from Vim line comments when indented
syntax match LeadingWhitespace /^[ \t]*/ contained
syntax match vimLineComment /^[ \t:]*".*$/  contains=@vimCommentGroup,vimCommentString,vimCommentTitle,LeadingWhitespace

syntax match   vimCommentNote /\<NOTE\ze:/ contained
syntax cluster vimCommentGroup add=vimCommentNote
hi link vimCommentNote Todo

hi vimFuncName  cterm=bold,italic  guifg=#FFF180

hi link vimFunction   Function
hi link vimUserFunc   Function
hi link vimSynType    Statement
hi link vimFgBgAttrib Special
hi link vimHiAttrib   Special
hi link vimOption     Special
hi link vimEscape     SpecialChar
hi link vimEnvvar     Identifier

syntax keyword vimSource source skipwhite nextgroup=vimPath
hi link vimSource Statement

syntax match vimPath /\S\+/ contained
hi link vimPath Constant

syn match vimEchoHL "echohl\=" skipwhite nextgroup=vimGroup,vimHiGroup,vimHLGroup,vimEchoHLNone

syntax match vimSyntaxClusterRef /@\w\+/ contained containedin=vimGroupList
hi link vimSyntaxClusterRef Identifier

syntax match vimComma /,/ containedin=vimGroupList,vimFuncArgs contained
hi link vimComma Operator

syntax match vimAmp /&/ containedin=vimGroupList
hi link vimAmp SpecialChar

syntax match vimAnd /&&/ containedin=vimGroupList
hi link vimAnd Operator

" TODO: Fix this in Vim repo
syntax keyword vimHiAttrib contained underdouble underdotted underdashed

" Include autoload functions in function highlighting
syntax match vimFunc     /\c\%(\%([sgbwtl]:\|<s[i]d>\)\=\%(\w\+\.\)*\I[a-z0-9_.]*\)\ze\s*(/ contains=vimFuncEcho,vimFuncName,vimUserFunc,vimExecute nextgroup=vimFuncArgs
syntax match vimFunc     /\c\h[a-z0-9_.]*\%(#\h[a-z0-9_.]*\)\+\ze(/                         contains=vimFuncEcho,vimFuncName,vimUserFunc,vimExecute nextgroup=vimFuncArgs
syntax match vimUserFunc /\c\h[a-z0-9_.]*\%(#\h[a-z0-9_.]*\)\+/                             contains=vimFuncEcho,vimFuncName,vimUserFunc,vimExecute nextgroup=vimFuncArgs

syntax region vimFuncArgs matchgroup=FunctionParens start='(' end=')' contained contains=vimoperStar,@vimOperGroup,vimNotation

" TODO: Raise this as a fix in Vim repo
syn keyword vimHiClear contained containedin=vimHighlightCluster clear skipwhite  nextgroup=vimHiGroup

" syn region vimSynMatchRegion contained matchgroup=vimGroupName start="\h\w*" skip=/\n\s*\\/ matchgroup=vimSep end="|\|$" contains=@vimSynMtchGroup
" syn region vimSynMatchRegion contained matchgroup=vimGroupName start="\h\w*" skip=/\n\s*\\/ matchgroup=vimSep end="|\|$" contains=@vimSynMtchGroup,vimContinue
" syn region vimSynRegion contained matchgroup=vimGroupName start="\h\w*" skip="\\\\\|\\|\|\n\s*\\/" end="|\|$" contains=@vimSynRegGroup

syntax keyword vimCommand match skipwhite nextgroup=vimMatchHiGroup
syntax match vimMatchHiGroup /\i\+/ contained skipwhite nextgroup=vimSynRegPat
hi link vimMatchHiGroup vimHiGroup

hi link vimHiKeyList Operator

hi link vimHiBang Operator

hi link vimHiTerm Identifier

" TODO: Raise this as a fix, but make the hi bang optional
syn region vimHiLink contained oneline matchgroup=vimCommand start="\(\<hi\%[ghlight]!\s\+\)\@<=\(\(def\%[ault]\s\+\)\=link\>\|\<def\>\)" end="$" contains=@vimHiCluster

syntax match vimVarHash /#/ contained containedin=vimVar
hi link vimVarHash SpecialChar

syntax match vimVarScope /\<[abglsw]:\ze\w/ containedin=vimVar,vimFBVar,vimFuncVar contained
hi link vimVarScope Special
