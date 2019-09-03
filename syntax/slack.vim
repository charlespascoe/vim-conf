syn match slackMessageIndicator '=== Message ==='
syn match slackMessageHeader '^[^(]\+ (\d\{4\}/\d\{2\}/\d\{2\} \d\{2\}:\d\{2\}):' contains=slackName,slackDate,slackTime,slackOwnName
syn match slackName '^[^(]\+' contained
syn match slackDate '\d\{4\}/\d\{2\}/\d\{2\}' contained
syn match slackTime '\d\{2\}:\d\{2\}' contained
syn match slackOwnName 'charles.pascoe' contained
syn match slackMention '@[^  ]\+' contains=slackMentionAt,slackMentionName
syn match slackMentionAt '@' contained
syn match slackMentionName '[^@  ]\+' contained

hi slackMessageHeader ctermfg=27
hi slackName ctermfg=39
hi slackOwnName ctermfg=51
hi slackDate ctermfg=34
hi slackTime ctermfg=34
hi slackMessageIndicator ctermfg=226 cterm=bold
hi slackMentionAt ctermfg=226
hi slackMentionName ctermfg=228

" Formatting

syntax region slackBold start="*" end="*"
syntax region slackItalic start="_" end="_"
syntax region slackCode start="`" end="`"
syntax region slackStrike start="\~" end="\~"
syntax region slackIcon start=":" skip="[a-zA-Z_]\+" end=":" excludenl

hi slackBold cterm=bold
hi slackItalic cterm=italic
hi slackStrike cterm=italic ctermfg=250
hi slackCode ctermfg=196
