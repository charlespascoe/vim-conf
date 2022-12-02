syntax match spellControl /^\/.*/
hi link spellControl PreProc

syntax keyword spellTODO contained TODO

syntax match spellComment /^#.*/ contains=TODO
hi link spellComment Comment
setlocal commentstring=#%s

syntax match spellBadWord '^[^/].*/!=\?[0-9]*$'
hi spellBadWord ctermfg=196

syntax match spellRareWord '^[^/].*/?[0-9]*$'
hi spellRareWord ctermfg=13

syntax match spellCaseSensitiveWord '^[^/].*/=[0-9]*$'
hi link spellCaseSensitiveWord Special

syntax match spellRegionalWord '^[^/].*/[0-9]\+$'
hi link spellRegionalWord Special
