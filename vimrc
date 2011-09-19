set showmode
filetype indent on
syntax on
"set autoindent
set hlsearch
set norestorescreen
set ruler
set expandtab
set shiftwidth=4
set tabstop=4

filetype plugin on
set ofu=syntaxcomplete#Complete

autocmd BufReadPost * if line("'\"") | exe "normal '\"" | endif
setlocal spell spelllang=en

"augroup BEGIN
"   au! BufRead,BufNewFile *.docbook source ~/.vim/xmledit.vba
"   au! BufRead,BufNewFile *.docbook source ~/.vim/dbhelper.vim 
"augroup END
