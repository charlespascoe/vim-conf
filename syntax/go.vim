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

" TODO: Maybe have highlighting for built-in functions etc?

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
syntax region goString start='"' skip=/\\"/ end='"' contains=goStringEscape,goDoubleQuoteEscape,goStringFormat extend
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

" TODO: Is it possible to reduce duplication here?
syntax match goShortVarDecl /^\s*\zs\K\k*\%(\s*,\s*\%(\K\k*\)\?\)*\ze\s*:=/ contains=goComma,goUnderscore
syntax match goInlineShortVarDecl /\K\k*\%(\s*,\s*\%(\K\k*\)\?\)*\ze\s*:=/ contained contains=goComma,goUnderscore containedin=goIfCondition

" Packages
syntax keyword goPackage package
syntax keyword goImport import skipwhite nextgroup=goImportItem,goImports
syntax region goImports matchgroup=goImportParens start='(' end=')' contained contains=goImportItem
syntax match goImportItem /\(\([\._]\|\K\k*\)\s\+\)\?"[^"]*"/ contained contains=@NoSpell,goString

" Functions
syntax match goFunCall /\<\K\k*\ze(/ nextgroup=goFuncCallParen
syntax region goFuncCallParen matchgroup=goFuncCallParens start='(' end=')' contained transparent

syntax keyword goFunc func skipempty skipwhite nextgroup=goMethodReceiver,goFuncName

syntax match goMethodReceiver /([^,]\+)\ze\s\+\K\k*\s*(/ contained contains=goReceiverBlock skipempty skipwhite nextgroup=goFuncName
syntax region goReceiverBlock matchgroup=goReceiverParens start='(' end=')' contained contains=goReceiverParam,goReceiverType
syntax match goReceiverParam /(\@<=\K\k*/ contained
syntax match goReceiverType /\*\?\K\k*)\@=/ contained contains=@goType

syntax match goFuncName /\K\k*/ contained skipwhite nextgroup=goFuncParams
" TODO: indepentent matching of param name and type
syntax region goFuncParams matchgroup=goFuncParens start='(' end=')' contained contains=@goType,goComma skipwhite nextgroup=goFuncReturnType,goFuncMultiReturn,goFuncBlock
syntax match goFuncReturnType /\s*\zs(\@<!\%(\%(interface\|struct\)\s*{\|[^{]\)\+{\@<!/ contained contains=@goType skipempty skipwhite nextgroup=goFuncBlock
syntax region goFuncMultiReturn matchgroup=goFuncMultiReturnParens start='(' end=')' extend contained contains=@goType,goComma skipempty skipwhite nextgroup=goFuncBlock
syntax region goFuncBlock matchgroup=goFuncBraces start='{' end='}' contained transparent

syntax keyword goReturn return

" Structs
syntax keyword goStruct struct skipempty skipwhite nextgroup=goStructBlock
syntax region goStructBlock matchgroup=goStructBraces start='{' end='}' keepend extend contained contains=goEmbeddedType,goStructField,goComment,goStructTag,goDot,goSemicolon
syntax region goStructTag start='\z([`"]\)' end='\z1' contained
syntax match goStructField /\%(_\|\K\k*\)\%(,\s*\%(_\|\K\k*\)\)*/ contained skipwhite contains=goComma,goUnderscore nextgroup=@goType
" TODO: Highlight pointer for pointer embedded types
syntax match goEmbeddedType /\K\k*\%#\@<!$/ contained

" It is techically possible to have a space between a struct name and the
" braces, but it causes odd behaviour elsewhere
syntax match goStructValue /\K\k*\ze{/ skipwhite nextgroup=goBrace

" Interfaces
syntax keyword goInterface interface skipempty skipwhite nextgroup=goInterfaceBlock
syntax region goInterfaceBlock matchgroup=goInterfaceBraces start='{' end='}' extend contained keepend contains=goEmbeddedType,goInterfaceFunc,goComment
syntax match goInterfaceFunc /\K\k*\ze\s*(/ contained skipwhite nextgroup=goInterfaceFuncParams
syntax region goInterfaceFuncParams matchgroup=goInterfaceFuncParens start='(' end=')' contained contains=@goType skipwhite nextgroup=@goType,goInterfaceFuncMultiReturn
syntax region goInterfaceFuncMultiReturn matchgroup=goFuncMultiReturnParens start='(' end=')' contained contains=@goType,goComma

" Types
syntax keyword goTypeDecl type skipempty skipwhite nextgroup=goTypeDeclName
syntax match goTypeDeclName /\K\k*/ contained skipempty skipwhite nextgroup=@goType

syntax match goPointer /*/ contained nextgroup=@goType

syntax cluster goType contains=goBuiltinTypes,goFuncType,goStruct,goInterface,goMap,goSliceOrArray,goChannel,goNonBuiltinType,goPointer

syntax match goNonBuiltinType /\K\k*/ contained
hi link goNonBuiltinType Type

syntax keyword goBuiltinTypes bool byte chan complex128 complex64 error float32 float64 int int8 int16 int32 int64 map rune string uint uint8 uint16 uint32 uint64 uintptr
" syntax keyword goBuiltinTypes bool byte complex128 complex64 error float32 float64 int int8 int16 int32 int64 map rune string uint uint8 uint16 uint32 uint64 uintptr

syntax keyword goFuncType func contained skipwhite nextgroup=goFuncTypeParens
syntax region goFuncTypeParens matchgroup=goFuncParens start='(' end=')' contained contains=@goType,goComma skipwhite nextgroup=@goType,goFuncTypeMultiReturnType
syntax region goFuncTypeMultiReturnType matchgroup=goFuncMultiReturnParens start='(' end=')' contained contains=@goType,goComma

syntax keyword goMap map skipempty skipwhite nextgroup=goMapKeyType
syntax region goMapKeyType matchgroup=goMapBrackets start='\[' end='\]' contained contains=@goType skipempty nextgroup=@goType

syntax match goSliceOrArray /\[\%(\d\+\|\.\.\.\)\?\]\K\@=/ contains=goNumber,goDot nextgroup=@goType

syntax match goChannel /<-chan\|chan\%(<-\)\?/ contains=goOperator skipwhite nextgroup=@goType

" If
syntax keyword goIf if skipempty skipwhite nextgroup=goIfCondition,goIfBlock
syntax match goIfCondition /.\+\ze\s*{/ contained contains=TOP skipempty skipwhite nextgroup=goIfBlock
syntax region goIfBlock matchgroup=goIfBraces start='{' end='}' contained transparent

" For TODO: Finish
syntax keyword goFor for skipempty skipwhite nextgroup=goInlineShortVarDecl,goForBlock
syntax region goForBlock matchgroup=goForBraces start='{' end='}' contained transparent
syntax keyword goRange range

" Select TODO

" Labels TODO

" Defer TODO

" Other
syntax keyword goIota iota

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
hi link goBuiltinTypes Type
hi link goFunc Keyword
hi link goFuncName Identifier
hi link goStruct Keyword
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
hi link goStructTag PreProc

hi link goUnderscore Special

hi link goStructType goOtherTypes

hi link goParams NONE

hi link goReceiverParam goParams
hi link goFor Keyword
hi link goRange Keyword

hi link goRuneLiteral Constant
hi link goMap goBuiltinTypes

" Keep this, but have an option to change it to 'Constant'
hi link goInvalidRuneLiteral Error

hi link goPointer Operator
hi link goSliceOrArray Special
hi link goEmbeddedType Special
hi link goDot Operator
hi link goSemicolon Operator
hi link goStructValue Type
hi link goChannel Type
hi link goIota Special

" TODO: This isn't standard
hi link goFuncParens FunctionParens
hi link goInterfaceBraces Braces
hi link goParens Parens
hi link goFuncCallParens Parens
hi link goFuncMultiReturnParens Parens
hi link goFuncBraces Braces
hi link goStructBraces Braces
hi link goBrackets Brackets
hi link goIfBraces Braces
hi link goForBraces Braces
hi link goBraces Braces
hi link goImportParens Parens
hi link goReceiverParens FunctionParens
hi link goImportItem Special
hi link goMapBrackets Special

hi link goInterfaceFunc Identifier
hi link goInterfaceFuncParens FunctionParens
