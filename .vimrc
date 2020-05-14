" plugins
call plug#begin('~/.vim/plugged')
Plug 'tpope/vim-sensible'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'  " :Gbrowse github
Plug 'tommcdo/vim-fubitive'  " :Gbrowse bitbucket
Plug 'altercation/vim-colors-solarized'
Plug 'editorconfig/editorconfig-vim'
Plug 'elzr/vim-json'
Plug 'scrooloose/nerdtree'
Plug 'christoomey/vim-tmux-navigator'
Plug 'rust-lang/rust.vim'
Plug 'dense-analysis/ale'
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'
Plug 'itchyny/lightline.vim'
Plug 'psf/black'
call plug#end()

set nocompatible
set encoding=utf8

" modelines (used for spellcheck language)
" but first find a way to only enable it for my blog:
" https://news.ycombinator.com/item?id=20098691
" set nomodeline

" Syntax highlighting
syntax on
set background=dark
colorscheme solarized
set hlsearch
autocmd BufNewFile,BufRead *.jsonl set filetype=json

" incremental search
set incsearch

" no delay
set timeoutlen=1000 ttimeoutlen=0

" show lines and columns
set ruler
" show lines on the left
set number
" keep ale column open to avoid blinking
let g:ale_sign_column_always = 1

" Indentation
set expandtab
set smarttab
set shiftround
set shiftwidth=4
set tabstop=12
autocmd Filetype json setlocal expandtab shiftwidth=2 softtabstop=2

" column, but no wrap
au FileType text,markdown,rst setlocal textwidth=70
au FileType tex,python,javascript,htmldjango setlocal textwidth=88
set formatoptions-=t
set colorcolumn=+1

" file autocompletion
set wildmenu
set wildignore=*.o,*.obj,*.bak,*.exe,*.class,*.swp

" black
map <C-P> :Black<cr>
imap <C-P> <c-o>:Black<cr>
" autocmd BufWritePre */Projects/*.py execute ':Black'

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

" NERDTree
map <C-n> :NERDTreeToggle<CR>

" disable quote concealing from vim json
let g:vim_json_syntax_conceal = 0

" copy paste
set clipboard=unnamed


" GitGutter
let g:gitgutter_sign_added = '∙'
let g:gitgutter_sign_modified = '∙'
let g:gitgutter_sign_removed = '∙'
let g:gitgutter_sign_modified_removed = '∙'

" Lightline
let g:lightline = {
\ 'colorscheme': 'wombat',
\ 'active': {
\   'left': [['mode', 'paste'], ['gitbranch', 'readonly', 'relativepath', 'modified']],
\   'right': [['lineinfo'], ['percent'], ['readonly', 'linter_warnings', 'linter_errors', 'linter_ok']]
\ },
\ 'component_expand': {
\   'linter_warnings': 'LightlineLinterWarnings',
\   'linter_errors': 'LightlineLinterErrors',
\   'linter_ok': 'LightlineLinterOK'
\ },
\ 'component_type': {
\   'readonly': 'error',
\   'linter_warnings': 'warning',
\   'linter_errors': 'error'
\ },
\ 'component_function': {
\   'gitbranch': 'fugitive#head'
\ },
\ }

function! LightlineLinterWarnings() abort
  let l:counts = ale#statusline#Count(bufnr(''))
  let l:all_errors = l:counts.error + l:counts.style_error
  let l:all_non_errors = l:counts.total - l:all_errors
  return l:counts.total == 0 ? '' : printf('%d ◆', all_non_errors)
endfunction

function! LightlineLinterErrors() abort
  let l:counts = ale#statusline#Count(bufnr(''))
  let l:all_errors = l:counts.error + l:counts.style_error
  let l:all_non_errors = l:counts.total - l:all_errors
  return l:counts.total == 0 ? '' : printf('%d ✗', all_errors)
endfunction

function! LightlineLinterOK() abort
  let l:counts = ale#statusline#Count(bufnr(''))
  let l:all_errors = l:counts.error + l:counts.style_error
  let l:all_non_errors = l:counts.total - l:all_errors
  return l:counts.total == 0 ? '✓ ' : ''
endfunction

autocmd User ALELint call s:MaybeUpdateLightline()

" Update and show lightline but only if it's visible (e.g., not in Goyo)
function! s:MaybeUpdateLightline()
  if exists('#lightline')
    call lightline#update()
  end
endfunction

" \aj and \ak to get next/previous ale error
nmap <silent> <leader>aj :ALENext<cr>
nmap <silent> <leader>ak :ALEPrevious<cr>

" disable pylint
let g:ale_linters = {'python': ['flake8', 'mypy']}
