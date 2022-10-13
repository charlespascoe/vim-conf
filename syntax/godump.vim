syn match Entry /^  / nextgroup=fileref
syntax match FileRef /[^:]\+:\d\+/ contained contains=FileName,LineNum,Colon skipwhite nextgroup=X
syntax match FileName /[^:]\+\ze:/ contained contains=Ext
syntax match LineNum /:\@1<=\d\+/ contained
syntax match Colon /:/ contained
syntax match Ext /\.go/ contained

syntax match X /[^[:space:]]\+/ contained skipwhite nextgroup=Y
syntax match Y /[^[:space:]]\+/ contained skipwhite nextgroup=Operation
syntax match Operation /.*$/ contained

hi link FileName Type
hi link LineNum Constant
hi link Colon Operator
hi Ext ctermfg=247
hi link X Ext
hi link Y Ext
