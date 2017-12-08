setlocal spell
setlocal wrap
syntax region inlineCode start="`" end="`"
highlight def link inlineCode String
