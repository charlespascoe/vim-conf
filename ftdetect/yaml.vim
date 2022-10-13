autocmd BufRead,BufNewFile *.yaml,*.yml let &ft=(search('^openapi:', 'cnw') == 0 ? 'yaml' : 'yaml.openapi')
