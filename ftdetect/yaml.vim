autocmd BufRead,BufNewFile *.yaml,*.yml let &ft=(search('^openapi:', 'cnw') == 0 ? 'yaml' : 'yaml.openapi')
au BufNewFile,BufRead *.karabiner.yml set filetype=karabiner.yaml
au BufNewFile,BufRead docker-compose.yml set filetype=docker-compose.yaml
