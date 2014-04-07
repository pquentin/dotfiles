execute pathogen#infect()
filetype plugin indent on

" Syntax highlighting
syntax on
set background=light
colorscheme solarized

" Indentation
set expandtab
set shiftwidth=4
set tabstop=4

" file autocompletion
set wildmenu
set wildignore=*.o,*.obj,*.bak,*.exe,*.class,*.swp

" spell check in git commits
autocmd Filetype gitcommit setlocal spell textwidth=72
" latex spell check
autocmd Filetype tex setlocal spell
let g:tex_comment_nospell= 1
set spell spelllang=en

" Hard mode :)
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>
inoremap  <Up>     <NOP>
inoremap  <Down>   <NOP>
inoremap  <Left>   <NOP>
inoremap  <Right>  <NOP>
