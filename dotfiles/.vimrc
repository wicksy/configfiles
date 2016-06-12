set nocompatible

set autoread
set backspace=indent,eol,start
set fo=tcq
set hidden
set history=1000
set modeline
set number
set paste
set ruler
set showcmd
set showmode

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

filetype plugin indent on
