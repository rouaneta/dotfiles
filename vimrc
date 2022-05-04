syntax on
set number
set backspace=indent,eol,start
set tabstop=2 shiftwidth=2 expandtab
set autoindent
set conceallevel=2
if has("multi_byte")
  set encoding=utf-8
  setglobal fileencoding=utf-8
else
  echoerr "Sorry, this version of (g)vim was not compiled with +multi_byte"
endif

call plug#begin('~/.vim/plugged')
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'
Plug 'itchyny/vim-highlighturl'
call plug#end()

let g:vim_markdown_folding_disabled=1
let g:vim_markdown_new_list_item_indent=0
