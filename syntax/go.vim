" Prefix: go
" Inspired by vim-javascript

syntax clear
" syntax sync fromstart
" syntax case match

let b:current_syntax = 'go'

" syntax match goNoise /[,]/
syntax match goComma /,/
syntax match goDot /\./
syntax match goFunCall /\<\K\k*\ze(/ nextgroup=goFuncCallParen
syntax region goFuncCallParen matchgroup=goFuncCallParens start='(' end=')' contained transparent
" TODO: Uncomment when ready
" syntax match goParensError /[)}\]]/

" Literals
syntax region goString start='"' skip=/\\"/ end='"' contains=goStringEscape,goStringFormat extend
syntax region goRawString start='`' end='`'
" TODO: Proper number matching
syntax match goNumber /\c\d\+\%(\.\d\+\)\?\%(e[-+]\d+\)\?/
syntax keyword goNil nil
" syntax match goNumber /\v\c\<\%(0\%(b[_01]\+|o[_\o]\+|x[_\x]\+|\d[_\d]*)|[1-9]\d[_\d]*\%(\.)\?)\>/


" Keywords
syntax keyword goConstKeyword const skipempty skipwhite nextgroup=goVariableDef,goConstDelcGroup
syntax keyword goVarKeyword var skipempty skipwhite nextgroup=goVariableDef,goVarDelcGroup
syntax match goVariableDef /\<\K\k*/ contained skipempty skipwhite

syntax match goShortVarDecl /^\s*\zs\K\k*\%(\s*,\s*\%(\K\k*\)\?\)*\ze\s*:=/ contains=goComma
syntax match goInlineShortVarDecl /\K\k*\%(\s*,\s*\%(\K\k*\)\?\)*\ze\s*:=/ contained contains=goComma containedin=goIfCondition

syntax match goOperator /[-+*/.!:=%&^<>|~;]\+/
syntax keyword goBooleanTrue true
syntax keyword goBooleanFalse false

syntax keyword goCommentTodo    contained TODO FIXME XXX TBD NOTE
syntax region goComment start=+//+ end=+$+ contains=goCommentTodo extend keepend
syntax region goComment start=+/\*+ end=+\*/+ contains=goCommentTodo fold extend keepend
syntax match goGenerateComment +//go:generate.*$/+

" Packages
syntax keyword goPackage package
syntax keyword goImport import skipwhite nextgroup=goImportItem,goImports

syntax region goImports matchgroup=goImportParens start='(' end=')' contained contains=goImportItem

syntax match goImportItem /\(\K\k*\s\+\)\?"[^"]*"/ contained contains=@NoSpell,goString

syntax keyword goBuiltinTypes bool byte chan complex128 complex64 error float32 float64 int int8 int16 int32 int64 map rune string uint uint8 uint16 uint32 uint64 uintptr

syntax keyword goFunc func skipempty skipwhite nextgroup=goMethodReceiver,goFuncName

" TODO: Properly highlight non-builtin receiver/param types
syntax match goMethodReceiver /([^,]\+)\ze\s\+\K\k*\s*(/ contained contains=goReceiverBlock skipempty skipwhite nextgroup=goFuncName

" TODO: Don't use goOperator
syntax region goReceiverBlock matchgroup=goReceiverParens start='(' end=')' contained contains=@goType,goReceiverParam,goReceiverType,goOperator

syntax match goReceiverParam /(\@<=\K\k*/ contained
syntax match goReceiverType /\K\k*)\@=/ contained

syntax match goFuncName /\K\k*/ contained skipwhite nextgroup=goFuncParams

" TODO: indepentent matching of param name and type
syntax region goFuncParams matchgroup=goFuncParens start='(' end=')' contained contains=@goType,goComma skipwhite nextgroup=goFuncBlock,goFuncReturnType

" TODO: Maybe handle invalid variations
" TODO: Handle newlines in multi-return type
" Note: \{-} = match 0 or more, fewest possible
syntax match goFuncReturnType /\_.\{-}\ze\s*{/ contained contains=goFuncMultiReturn,@goType skipempty skipwhite nextgroup=goFuncBlock

syntax region goFuncMultiReturn matchgroup=goFuncMultiReturnParens start='(' end=')' contained contains=@goType,goComma

syntax region goFuncBlock matchgroup=goFuncBraces start='{' end='}' contained transparent

syntax keyword goStruct struct skipempty skipwhite nextgroup=goStructBlock

" TODO: Maybe highlight tags differently
" TODO: Is there a better way of making sure nested braces work?
syntax region goStructBlock matchgroup=goStructBraces start='{' end='}' contained contains=@goType,goRawString,goBrace

syntax keyword goInterface interface skipempty skipwhite nextgroup=goInterfaceBlock
syntax region goInterfaceBlock matchgroup=goInterfaceBraces start='{' end='}' contained contains=goInterfaceFunc

syntax match goInterfaceFunc /^\s\+\zs\K\k*\ze\s*(/ contained skipempty skipwhite nextgroup=goInterfaceFuncParams
syntax region goInterfaceFuncParams matchgroup=goInterfaceFuncParens start='(' end=')' contained contains=@goType skipwhite nextgroup=goInterfaceFuncReturn
syntax match goInterfaceFuncReturn /[^\s].*\ze\s*$/ contained contains=goFuncMultiReturn,@goType


syntax keyword goFuncType func contained skipwhite nextgroup=goFuncTypeParens
syntax region goFuncTypeParens matchgroup=goFuncParens start='(' end=')' contained contains=@goType,goComma skipwhite nextgroup=@goType,goFuncTypeMultiReturnType
syntax region goFuncTypeMultiReturnType matchgroup=goFuncMultiReturnParens start='(' end=')' contained contains=@goType,goComma

" TODO: Function types
" TODO: Structs
" TODO: Composite types? Is this needed?
syntax cluster goType contains=goBuiltinTypes,goFuncType,goStruct,goBracket
syntax keyword goReturn return

syntax keyword goIf if skipempty skipwhite nextgroup=goIfCondition,goIfBlock

syntax match goIfCondition /.\+\ze\s*{/ contained contains=TOP skipempty skipwhite nextgroup=goIfBlock

syntax region goIfBlock matchgroup=goIfBraces start='{' end='}' contained transparent

" TODO: Should this be contained somehow?
syntax match goStructType /\K\k*\ze\s*{/ skipwhite nextgroup=goBrace

" Blocks
" syntax region goBracket start='\[' end='\]'
syntax region goBracket matchgroup=goBrackets start='\[' end='\]' transparent
syntax region goParen matchgroup=goParens start='(' end=')' transparent
syntax region goBrace matchgroup=goBraces start='{' end='}' transparent
syntax region goVarDelcGroup start='(' end=')' contained
syntax region goConstDelcGroup start='(' end=')' contained

" TODO: Figure out where these go


syntax match goStringEscape /\v\\%(\o{3}|x\x{2}|u\x{4}|U\x{8}|[abfnrtv\\'"])/
" TODO: float formatting, flags (https://pkg.go.dev/fmt)
syntax match goStringFormat /\v\%%([%EFGOTUXbcdefgopqstvxf])/

syntax keyword goTypeDecl type skipempty skipwhite nextgroup=goTypeDeclName

syntax match goTypeDeclName /\K\k*/ contained skipempty skipwhite nextgroup=@goType

" syntax match goStringEscapeInvalid /\v\\%(\o{3}|x\x{2}|u\x{4}|U\x{8}|[abfnrtv\\'"])@!./

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
hi link goShortVarDecl Special
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

hi link goStructType goOtherTypes

hi link goParams NONE

hi link goReceiverParam goParams

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
hi link goBraces Braces
hi link goImportParens Parens
hi link goReceiverParens FunctionParens
hi link goImportItem Special

hi link goInterfaceFunc Identifier
hi link goInterfaceFuncParens FunctionParens
