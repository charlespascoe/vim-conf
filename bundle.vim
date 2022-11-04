call plug#begin()

Plug 'airblade/vim-gitgutter'
Plug 'christoomey/vim-sort-motion'
Plug 'christoomey/vim-titlecase'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'davidhalter/jedi-vim'
Plug 'dkarter/bullets.vim'
Plug 'fatih/vim-go'
Plug 'habamax/vim-asciidoctor'
Plug 'junegunn/vim-easy-align'
Plug 'junegunn/vim-plug'
Plug 'kopischke/vim-fetch'
Plug 'kshenoy/vim-signature'
Plug 'mbbill/undotree'
Plug 'michaeljsmith/vim-indent-object'
Plug 'moll/vim-bbye'
Plug 'pangloss/vim-javascript'
Plug 'Raimondi/delimitMate'
Plug 'scrooloose/nerdtree'
Plug 'sirver/ultisnips'
Plug 'tommcdo/vim-exchange'
Plug 'tommcdo/vim-ninja-feet'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-obsession'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'vim-airline/vim-airline'
Plug 'vim-python/python-syntax'
Plug 'vim-scripts/ReplaceWithRegister'

com -nargs=1 DevPlug Plug (isdirectory(expand('~/repos/'..<args>)) ? '~/repos/'..<args> : 'charlespascoe/'..<args>)

DevPlug 'vim-go-syntax'
DevPlug 'vim-ninja-feet'
DevPlug 'vim-serenade'

delcom DevPlug

call plug#end()
