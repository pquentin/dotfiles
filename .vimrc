let g:pathogen_disabled = ['dwm.vim']

execute pathogen#infect()
filetype plugin indent on

set nocompatible

" modelines (used for spellcheck)
set modeline

" Syntax highlighting
syntax on
set background=dark
colorscheme solarized
set hlsearch
autocmd BufNewFile,BufRead *.jsonl set filetype=json

" incremental search
set incsearch

" show lines and columns
set ruler
" show lines on the left
set number

" Indentation
set expandtab
set smarttab
set shiftround
set shiftwidth=4
set tabstop=12
autocmd Filetype json setlocal expandtab shiftwidth=2 softtabstop=2

" column, but no wrap
au FileType text,markdown,rst setlocal textwidth=70
au FileType tex,python,javascript,htmldjango setlocal textwidth=79
set formatoptions-=t
set colorcolumn=+1

" file autocompletion
set wildmenu
set wildignore=*.o,*.obj,*.bak,*.exe,*.class,*.swp

" yapf
map <C-P> :call yapf#YAPF()<cr>
imap <C-P> <c-o>:call yapf#YAPF()<cr>

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

" NERDTree
map <C-n> :NERDTreeToggle<CR>
