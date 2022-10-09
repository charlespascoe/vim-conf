" Prefix: go
" Inspired by vim-javascript

syntax clear
" syntax sync fromstart
" syntax case match

" TODO: Add support for general interfaces
" (https://go.dev/ref/spec#General_interfaces)
" TODO: Add support for defining multiple types at once
" (https://go.dev/ref/spec#Underlying_types)
" TODO: Const and Var group declarations
" TODO: Simplify basic keywords into one syntax group (maybe?)

" TODO: Maybe have highlighting for built-in functions etc?
" TODO: Check performance of lookbehinds
" TODO: Check correct use of 'skipempty'

let b:current_syntax = 'go'

syntax match goDot /\./
syntax match goSemicolon /;/
syntax match goComma /,/
syntax match goOperator /[-+*/!:=%&^<>|~]\+/
syntax keyword goUnderscore _

" Comments
syntax keyword goCommentTodo    contained TODO FIXME XXX TBD NOTE
syntax region goComment start=+//+ end=+$+ contains=goCommentTodo extend keepend
syntax region goComment start=+/\*+ end=+\*/+ contains=goCommentTodo fold extend keepend
syntax match goGenerateComment +//go:generate.*$/+

" Literals
syntax region goString start='"' skip=/\\"/ end='"\|$' extend contains=goStringEscape,goDoubleQuoteEscape,goStringFormat
syntax match goStringEscape /\v\\%(\o{3}|x\x{2}|u\x{4}|U\x{8}|[abfnrtv\\"])/ contained
syntax region goInvalidRuneLiteral start=+'+ end=+'+ keepend contains=goRuneLiteral
syntax match goRuneLiteral /\v'%([^\\]|\\%(\o{3}|x\x{2}|u\x{4}|U\x{8}|[abfnrtv\\']))'/
syntax region goRawString start='`' end='`'
" TODO: Proper number matching
" TODO: Fix numbers matching in int64 etc.
syntax match goNumber /\c\d\+\%(\.\d\+\)\?\%(e[-+]\d+\)\?/
syntax keyword goNil nil
syntax keyword goBooleanTrue true
syntax keyword goBooleanFalse false
" TODO: float formatting, flags (https://pkg.go.dev/fmt)
syntax match goStringFormat /\v\%%([%EFGOTUXbcdefgopqstvxf])/

" Simple Blocks
syntax region goBracket matchgroup=goBrackets start='\[' end='\]' transparent
syntax region goParen matchgroup=goParens start='(' end=')' transparent
syntax region goBrace matchgroup=goBraces start='{' end='}' transparent

" Constants and Variables
syntax keyword goConstKeyword const skipempty skipwhite nextgroup=goVariableDef,goConstDelcGroup
syntax keyword goVarKeyword var skipempty skipwhite nextgroup=goVariableDef,goVarDelcGroup
syntax region goVarDelcGroup start='(' end=')' contained
syntax region goConstDelcGroup start='(' end=')' contained
" TODO: Rename to something else
syntax match goVariableDef /\<\K\k*/ contained skipempty skipwhite nextgroup=@goType

" TODO: Is it possible to reduce duplication here? Remember performance!
syntax match goShortVarDecl /^\s*\zs\K\k*\%(\s*,\s*\%(\K\k*\)\?\)*\ze\s*:=/ contains=goComma,goUnderscore
syntax match goInlineShortVarDecl /\K\k*\%(\s*,\s*\%(\K\k*\)\?\)*\ze\s*:=/ contained contains=goComma,goUnderscore

" Packages
syntax keyword goPackage package
syntax keyword goImport import skipwhite nextgroup=goImportItem,goImports
syntax region goImports matchgroup=goImportParens start='(' end=')' contained contains=goImportItem
syntax match goImportItem /\(\([\._]\|\K\k*\)\s\+\)\?"[^"]*"/ contained contains=@NoSpell,goString

" Functions
syntax match goFunCall /\<\K\k*\ze(/ nextgroup=goFuncCallParen
syntax region goFuncCallParen matchgroup=goFuncCallParens start='(' end=')' contained transparent

syntax keyword goFunc func skipempty skipwhite nextgroup=goMethodReceiver,goFuncName,goFuncParams

syntax match goVariadic /\.\.\./ contained skipwhite nextgroup=@goType

syntax match goParam /^\s*\zs\K\k*/ contained skipempty skipwhite nextgroup=goParam,goVariadic,@goType
syntax match goParam /[(,]\@<=\s*\zs\K\k*/ contained skipempty skipwhite nextgroup=goParam,goVariadic,@goType

syntax match goFuncName /\K\k*/ contained skipwhite nextgroup=goFuncParams
syntax region goFuncParams matchgroup=goFuncParens start='(' end=')' contained contains=goParam,goComma skipwhite nextgroup=goFuncReturnType,goFuncMultiReturn,goFuncBlock
syntax match goFuncReturnType /\s*\zs(\@<!\%(\%(interface\|struct\)\s*{\|[^{]\)\+{\@<!/ contained contains=@goType skipempty skipwhite nextgroup=goFuncBlock
" TODO: Support named return values
syntax region goFuncMultiReturn matchgroup=goFuncMultiReturnParens start='(' end=')' extend contained contains=@goType,goComma skipempty skipwhite nextgroup=goFuncBlock
syntax region goFuncBlock matchgroup=goFuncBraces start='{' end='}' contained transparent

syntax match goMethodReceiver /([^,]\+)\ze\s\+\K\k*\s*(/ contained contains=goReceiverBlock skipempty skipwhite nextgroup=goFuncName
syntax region goReceiverBlock matchgroup=goReceiverParens start='(' end=')' contained contains=goParam

syntax keyword goReturn return

" Structs
" TODO: goStruct or goStructType?
syntax keyword goStructType struct skipempty skipwhite nextgroup=goStructTypeBlock
syntax region goStructTypeBlock matchgroup=goStructTypeBraces start='{' end='}' keepend extend contained contains=goEmbeddedType,goStructTypeField,goComment,goStructTypeTag,goDot,goSemicolon
syntax region goStructTypeTag start='\z([`"]\)' end='\z1' contained
syntax match goStructTypeField /\%(_\|\K\k*\)\%(,\s*\%(_\|\K\k*\)\)*/ contained skipwhite contains=goComma,goUnderscore nextgroup=@goType
" TODO: Highlight pointer for pointer embedded types
syntax match goEmbeddedType /\K\k*\%#\@<!$/ contained

" It is techically possible to have a space between a struct name and the
" braces, but it causes odd behaviour elsewhere
syntax match goStructValue /\K\k*\ze{/ skipwhite contains=@goType nextgroup=goBrace

" Interfaces
syntax keyword goInterface interface skipempty skipwhite nextgroup=goInterfaceBlock
" TODO: Maybe don't just put goOperator in here
syntax region goInterfaceBlock matchgroup=goInterfaceBraces start='{' end='}' extend contained keepend contains=goEmbeddedType,goOperator,goInterfaceFunc,goComment
syntax match goInterfaceFunc /\K\k*\ze\s*(/ contained skipwhite nextgroup=goInterfaceFuncParams
syntax region goInterfaceFuncParams matchgroup=goInterfaceFuncParens start='(' end=')' contained contains=goParam,goComma skipwhite nextgroup=@goType,goInterfaceFuncMultiReturn
" TODO: Support named return values
syntax region goInterfaceFuncMultiReturn matchgroup=goFuncMultiReturnParens start='(' end=')' contained contains=@goType,goComma

" Types
syntax keyword goTypeDecl type skipempty skipwhite nextgroup=goTypeDeclName
syntax match goTypeDeclName /\K\k*/ contained skipempty skipwhite nextgroup=@goType

syntax match goPointer /*/ contained nextgroup=@goType

syntax cluster goType contains=goSimpleBuiltinTypes,goFuncType,goStructType,goInterface,goMap,goSliceOrArrayType,goChannel,goNonPrimitiveType,goPointer,goTypeParens

syntax match goNonPrimitiveType /\K\k*/ contained

syntax keyword goSimpleBuiltinTypes any bool byte complex128 complex64 error float32 float64 int int8 int16 int32 int64 rune string uint uint8 uint16 uint32 uint64 uintptr

syntax keyword goFuncType func contained skipwhite nextgroup=goFuncTypeParens
syntax region goFuncTypeParens matchgroup=goFuncParens start='(' end=')' contained contains=@goType,goComma skipwhite nextgroup=@goType,goFuncTypeMultiReturnType
" TODO: Support named return values
syntax region goFuncTypeMultiReturnType matchgroup=goFuncMultiReturnParens start='(' end=')' contained contains=@goType,goComma

syntax region goTypeParens start='(' end=')' contained contains=@goType

syntax keyword goMap map skipempty skipwhite nextgroup=goMapKeyType
syntax region goMapKeyType matchgroup=goMapBrackets start='\[' end='\]' contained contains=@goType skipempty nextgroup=@goType

syntax match goSliceOrArrayType /\[\%(\d\+\|\.\.\.\)\?\]/ contained contains=goNumber,goDot skipwhite nextgroup=@goType

syntax match goSliceOrArray /\k\@<=\[\%(\d\+\|\.\.\.\)\?\]\ze[*([:keyword:]]/ contains=goNumber,goDot skipwhite nextgroup=goSliceItemType

"@goType
syntax match goSliceItemType /\%(\%(interface\|struct\)\s*{\|\_[^{]\)\+\ze{/ contained contains=@goType skipwhite nextgroup=goSliceItems
syntax region goSliceItems matchgroup=goSliceBraces start='{' end='}' contained transparent

syntax match goChannel /<-chan\|chan\%(<-\)\?/ contains=goOperator skipwhite nextgroup=@goType

" Make and New
" TODO: Don't match if method?
syntax keyword goMakeBuiltin make skipwhite nextgroup=goNewMakeBlock
syntax region goNewMakeBlock matchgroup=goParens start='(' end=')' contained
syntax match goNewMakeType /\%(\<make(\)\@<=[^,]\+\ze[,)]/ contained contains=@goType containedin=goNewMakeBlock

" Make and New
" TODO: Don't match if method?
syntax keyword goNewBuiltin new skipwhite nextgroup=goNewBlock
syntax region goNewBlock matchgroup=goParens start='(' end=')' contained contains=@goType

" TODO: Field access

" If
" TODO: Figure out how to remove goInlineShortVarDecl; this could simplify if,
" for, and switch
syntax keyword goIf if skipempty skipwhite nextgroup=goInlineShortVarDecl
syntax keyword goElse else

" For
syntax keyword goFor for skipempty skipwhite nextgroup=goInlineShortVarDecl
syntax keyword goRange range

" Switch and Select
syntax keyword goSwitch switch skipwhite nextgroup=goInlineShortVarDecl
syntax keyword goSelect select
syntax keyword goSwitchKeywords case fallthrough default

" Labels TODO

" Misc
syntax keyword goDefer defer
syntax keyword goIota iota
syntax region goTypeAssertion matchgroup=goParens start=/\.\@<=(/ end=/)/ contains=@goType,goTypeDecl

"Highlighting
hi link goBooleanFalse Constant
hi link goBooleanTrue Constant
hi link goFunCall FunctionCall
hi link goImport Keyword
hi link goPackage Keyword
hi link goRawString Constant
hi link goStringEscape Special
hi link goConstKeyword StorageClass
hi link goVarKeyword StorageClass
hi link goString Constant
hi link goNumber Constant
hi link goOperator Operator
hi link goSimpleBuiltinTypes Type
hi link goFunc Keyword
hi link goFuncName Identifier
hi link goStructType Keyword
hi link goReturn Statement
hi link goNil Constant
hi link goStringFormat Special
hi link goShortVarDecl Identifier
hi link goInlineShortVarDecl goShortVarDecl
hi link goIf Keyword
hi link goTypeDecl Keyword
hi link goTypeDeclName Identifier
hi link goComma Operator
hi link goOtherTypes Type
hi link goInterface Keyword
hi link goComment Comment
hi link goGenerateComment PreProc
hi link goCommentTodo Todo
hi link goReceiverType Type
hi link goFuncType goFunc
" TODO: Figure out what this should be
hi link goStructTypeTag PreProc

hi link goUnderscore Special

hi link goParams NONE

hi link goReceiverParam goParams
hi link goFor Keyword
hi link goRange Keyword

hi link goRuneLiteral Constant
hi link goMap goSimpleBuiltinTypes
hi link goElse Keyword

" Keep this, but have an option to change it to 'Constant'
hi link goInvalidRuneLiteral Error

hi link goPointer Operator
hi link goSliceOrArray Special
hi link goSliceOrArrayType Special
hi link goEmbeddedType Special
hi link goDot Operator
hi link goSemicolon Operator
" hi link goStructValue Type
hi link goChannel Type
hi link goIota Special
hi link goDefer Keyword
hi link goSwitch Keyword
hi link goSwitchKeywords goSwitch
hi link goSelect Keyword
"hi link goNonPrimitiveType Type
hi goNonPrimitiveType ctermfg=121
hi link goVariadic Operator

hi link goBuiltins Special
hi link goNewBuiltin goBuiltins
hi link goMakeBuiltin goBuiltins

" TODO: This isn't standard
hi link goFuncParens FunctionParens
hi link goInterfaceBraces Braces
hi link goParens Parens
hi link goFuncCallParens Parens
hi link goFuncMultiReturnParens Parens
hi link goFuncBraces Braces
hi link goStructTypeBraces Braces
hi link goBrackets Brackets
hi link goIfBraces Braces
hi link goForBraces Braces
hi link goBraces Braces
hi link goImportParens Parens
hi link goReceiverParens FunctionParens
hi link goImportItem Special
hi link goMapBrackets Special
hi link goSliceBraces Braces
hi link goTypeParens goParens

hi link goInterfaceFunc Identifier
hi link goInterfaceFuncParens FunctionParens
