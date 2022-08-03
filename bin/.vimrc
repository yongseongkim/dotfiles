set nocompatible
filetype off
set rtp+=$HOME/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'git@github.com:easymotion/vim-easymotion.git'
Plugin 'git@github.com:terryma/vim-multiple-cursors.git'
call vundle#end()
filetype plugin indent on

set encoding=utf-8

set number
set numberwidth=5
set ruler

set clipboard+=unnamed
"set easymotion
"set multiple-cursors
