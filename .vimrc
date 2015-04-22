let g:pathogen_disabled = ['dwm.vim']

execute pathogen#infect()
filetype plugin indent on

" modelines (used for spellcheck)
set modeline

" Syntax highlighting
syntax on
set background=dark
colorscheme solarized
set hlsearch

" show lines and columns
set ruler
" show lines on the left
set number

" Indentation
set expandtab
set shiftwidth=4
set tabstop=4

" '80 chars' column mark
set colorcolumn=+1

" wrap
au FileType text,markdown,rst setlocal textwidth=70
au FileType tex,python setlocal textwidth=79

" file autocompletion
set wildmenu
set wildignore=*.o,*.obj,*.bak,*.exe,*.class,*.swp

" file types
autocmd BufNewFile,BufReadPost *.md set filetype=markdown

" spell check
set spell spelllang=en
autocmd Filetype gitcommit setlocal spell textwidth=72
autocmd Filetype markdown setlocal spell
autocmd Filetype tex setlocal spell
let g:tex_comment_nospell= 1

" Hard mode :)
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>
inoremap  <Up>     <NOP>
inoremap  <Down>   <NOP>
inoremap  <Left>   <NOP>
inoremap  <Right>  <NOP>

" stacked wmii
map <C-J> <C-W>j
map <C-K> <C-W>k
map <C-L> <C-W>l
map <C-H> <C-W>h
