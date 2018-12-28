syntax region customInlineCode start="`" end="`"
syntax region inlineCode start="`" end="`"
syntax match markdownListMarker "\%(\t\| \{0,4\}\)\+[-*+]\%(\s\+\S\)\@=" contained
syntax match markdownOrderedListMarker "\%(\t\| \{0,4}\)\<\d\+\.\%(\s\+\S\)\@=" contained

highlight def link customInlineCode String
highlight def link inlineCode String
