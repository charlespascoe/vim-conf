call plug#begin()

com -nargs=1 DevPlug Plug (isdirectory(expand('~/repos/'..<args>)) ? '~/repos/'..<args> : 'charlespascoe/'..<args>)

DevPlug 'vim-duplicate'
DevPlug 'vim-go-syntax'
DevPlug 'vim-ninja-feet'
DevPlug 'vim-serenade'

delcom DevPlug

if isdirectory(expand('~/go/src/vim-chatgpt'))
    Plug '~/go/src/vim-chatgpt'
else
    Plug 'charlespascoe/vim-chatgpt'
endif

Plug 'junegunn/fzf', #{do: { -> fzf#install() }}
Plug 'junegunn/fzf.vim'

Plug 'vim-python/python-syntax'
Plug 'davidhalter/jedi-vim'

Plug 'airblade/vim-gitgutter'
Plug 'christoomey/vim-sort-motion'
Plug 'christoomey/vim-titlecase'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'dense-analysis/ale'
Plug 'dkarter/bullets.vim'
Plug 'dracula/vim', #{as: 'dracula'}
Plug 'fatih/vim-go'
Plug 'github/copilot.vim'
Plug 'habamax/vim-asciidoctor'
Plug 'junegunn/vim-easy-align'
Plug 'junegunn/vim-plug'
Plug 'kopischke/vim-fetch'
Plug 'kshenoy/vim-signature'
Plug 'leafgarland/typescript-vim'
Plug 'ludovicchabant/vim-gutentags'
Plug 'mbbill/undotree'
Plug 'michaeljsmith/vim-indent-object'
Plug 'moll/vim-bbye'
Plug 'pangloss/vim-javascript'
Plug 'preservim/vim-markdown'
Plug 'Quramy/tsuquyomi'
Plug 'Raimondi/delimitMate'
Plug 'scrooloose/nerdtree'
Plug 'sirver/ultisnips'
Plug 'tommcdo/vim-exchange'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-obsession'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'vim-airline/vim-airline'
Plug 'vim-scripts/ReplaceWithRegister'

call plug#end()

com! PlugSync source ~/.vim-conf/bundle.vim | PlugClean | PlugInstall
