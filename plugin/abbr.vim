" Varioys abbreviations

cabbr ps PlugSync
cabbr pu PlugUpdate

cabbr m messages

cabbr <expr> eh 'e '..expand('%:h')..'/'

" This prevents eh abbr from having a space when expanding
cmap <expr> <Space> (getcmdtype() == ':' && getcmdline() == 'eh') ? "\<C-]>" : "\<Space>"