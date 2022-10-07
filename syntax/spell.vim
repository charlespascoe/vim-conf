syntax match Control /^\/.*/
hi link Control PreProc

syntax keyword TODO contained TODO

syntax match Comment /^#.*/ contains=TODO

syntax match BadWord '^[^/].*/!=\?[0-9]*$'
hi BadWord ctermfg=196

syntax match RareWord '^[^/].*/?[0-9]*$'
hi RareWord ctermfg=13

syntax match CaseSensitiveWord '^[^/].*/=[0-9]*$'
hi link CaseSensitiveWord Special

syntax match RegionalWord '^[^/].*/[0-9]\+$'
hi link RegionalWord Special
