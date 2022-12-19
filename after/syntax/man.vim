syntax match manOption /\<-[a-z0-9]\>/
syntax match manOption /\[\zs-[a-z0-9]\+\ze\]/
syntax match manOption /\<--[a-z0-9]\{2,\}\>/
hi link manOption Constant
