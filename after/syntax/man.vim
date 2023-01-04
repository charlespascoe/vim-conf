syntax match manOption /^\s\+--\?\>/
syntax match manOption /--\?$/
syntax match manOption /"\zs--\?\ze"/
syntax match manOption /'\zs--\?\ze'/
syntax match manOption /\<-[a-z0-9]\>/
syntax match manOption /\<--[a-z0-9]\{2,\}\>/
syntax match manOption /\[\zs-[a-z0-9]\+\ze\]/
hi link manOption Constant

syntax match manArg /\[[^]]\+\]/ containedin=manOptionDesc
syntax match manArg /{[^}]\+}/
hi link manArg Identifier
