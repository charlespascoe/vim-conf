" Turn off autodetection; always use default of 4 spaces
let b:sleuth_automatic=0

setlocal expandtab
setlocal foldmethod=marker

call QuickSearchMap('f', 'Functions', '^\s*fun\(c\(tion\)\=\)\=')
