set showmode "always show the current edit mode

filetype plugin on
filetype indent on

syntax on "syntax color highlighting

set hlsearch "highlight search results
set norestorescreen "don't restore the screen to what it was before you entered vim
set ruler "show the cursor position all the time.

"set autoindent
set expandtab "replace tabs with spaces
set shiftwidth=4 "column count for automatic indentation
set tabstop=4 "How many spaces = 1 tab

set ofu=syntaxcomplete#Complete

autocmd BufReadPost * if line("'\"") | exe "normal '\"" | endif "open the file with the cursor on the line you were last on
setlocal spell spelllang=en "red background on misspelled words in text docs.

