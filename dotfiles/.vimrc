set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

Plugin 'hdima/python-syntax'
Plugin 'chase/vim-ansible-yaml'
Plugin 'pearofducks/ansible-vim'
Plugin 'powerline/powerline'
Plugin 'ekalinin/dockerfile.vim'
Plugin 'rodjek/vim-puppet'
Plugin 'glench/vim-jinja2-syntax'
Plugin 'altercation/vim-colors-solarized'
Plugin 'preservim/nerdtree'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"

" Plugin settings
autocmd vimenter * NERDTree
let python_highlight_all = 1
set rtp+=${HOME}/.vim/bundle/powerline/powerline/bindings/vim

set autoread
set backspace=indent,eol,start
set background=dark
colorscheme solarized
set binary
set exrc
set fo=tcq
set hidden
set history=1000
set laststatus=2
set modeline
set noeol
set nostartofline
set number
set paste
set ruler
set secure
set showcmd
set showmode
set ttyfast
set wildmenu

syntax on

set autoindent
set expandtab
set shiftwidth=2
set smartindent
set smarttab
set softtabstop=2
set tabstop=2

highlight comment ctermfg=cyan
highlight LiteralTabs ctermbg=darkgreen guibg=darkgreen
match LiteralTabs /\s\  /
highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen
match ExtraWhitespace /\s\+$/

set ignorecase
set incsearch
set hlsearch
set smartcase

" filetype plugin indent on
