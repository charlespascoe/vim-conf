syntax match manOption /^\s\+--\?\>/
syntax match manOption /--\?$/
syntax match manOption /"\zs--\?\ze"/
syntax match manOption /'\zs--\?\ze'/
syntax match manOption /\<-[a-z0-9]\>/
syntax match manOption /\<--[a-z0-9]\{2,\}\>/
syntax match manOption /\<--[a-z0-9]\+\%(-[a-z0-9]\+\)\+\>/
syntax match manOption /\[\zs-[a-z0-9]\+\ze\]/
hi link manOption Constant

syntax region manArg start=/\[/ end=/\]/ oneline contains=manArg containedin=manOptionDesc
syntax region manArg start=/{/  end=/}/  oneline contains=manArg containedin=manOptionDesc
hi     link   manArg Identifier
