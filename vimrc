set showmode "always show the current edit mode

filetype plugin on
filetype indent on

syntax on "syntax color highlighting

set hlsearch "highlight search results
set norestorescreen "don't restore the screen to what it was before you entered vim
set ruler "show the cursor position all the time.
"set autoread "update when an open file has been changed somewhere else

"set autoindent
set expandtab "replace tabs with spaces
set shiftwidth=4 "column count for automatic indentation
set tabstop=4 "How many spaces = 1 tab

set ofu=syntaxcomplete#Complete

"open the file with the cursor on the line you were last on
autocmd BufReadPost * if line("'\"") | exe "normal '\"" | endif
"red background on misspelled words in text docs.
setlocal spell spelllang=en

" Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

" Ignore case when searching
set ignorecase
" When searching try to be smart about cases 
set smartcase
" Makes search act like search in modern browsers
set incsearch

" Show matching brackets when text indicator is over them
set showmatch
" " How many tenths of a second to blink when matching brackets
set mat=2

" Turn backup off, since most stuff is in SVN, git etc. anyway...
set nobackup
set nowb
set noswapfile

" Search mappings: These will make it so that going to the next one in a
" " search will center on the line it's found in.
map N Nzz
map n nzz

" Enable mouse support in console
set mouse=a
