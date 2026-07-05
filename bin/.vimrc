set nocompatible

call plug#begin()
Plug 'easymotion/vim-easymotion'
Plug 'mg979/vim-visual-multi', {'branch': 'master'}
call plug#end()

set encoding=utf-8

set number
set numberwidth=5
set ruler
set autoindent
set expandtab " spaces are used for indenting lines
set tabstop=4 " will insert 4 spaces for a line indent
set shiftwidth=4 " the '>>' or '<<' operators to add or remove indentation
set clipboard+=unnamed
