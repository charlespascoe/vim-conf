let b:sleuth_automatic=0

setlocal tabstop=4     " a hard TAB displays as 4 columns
setlocal shiftwidth=4  " operation >> indents 4 columns; << unindents 4 columns
setlocal softtabstop=4 " insert/delete 4 spaces when hitting a TAB/BACKSPACE"
setlocal shiftround    " round indent to multiple of 'shiftwidth'
setlocal autoindent    " align the new line indent with the previous line
setlocal expandtab   " Do not insert spaces when tab is pressed
