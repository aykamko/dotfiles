set nocompatible
filetype off

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" Vundles
Bundle 'gmarik/vundle'
Bundle 'LaTeX-Box-Team/LaTeX-Box'
Bundle "mattn/emmet-vim"
Bundle 'tpope/vim-fugitive'
Bundle 'scrooloose/nerdtree'
Bundle 'Lokaltog/vim-easymotion'
Bundle 'Lokaltog/vim-powerline'
Bundle 'tpope/vim-sensible'
Bundle 'ervandew/supertab'
Bundle 'majutsushi/tagbar'
Bundle 'tComment'
Bundle 'tpope/vim-unimpaired'
Bundle 'kien/ctrlp.vim'
Bundle 'altercation/vim-colors-solarized'

filetype plugin indent on     " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :BundleList          - list configured bundles
" :BundleInstall(!)    - install (update) bundles
" :BundleSearch(!) foo - search (or refresh cache first) for foo
" :BundleClean(!)      - confirm (or auto-approve) removal of unused bundles
"
" see :h vundle for more details or wiki for FAQ
" NOTE: comments after Bundle commands are not allowed.
" Put your stuff after this line


let mapleader = ","
syntax on

set clipboard+=unnamed
set mouse=a

set background=dark
colorscheme solarized
set t_Co=256 "Explicitly tell Vim that the terminal supports 256 colors"

set shiftwidth=4 softtabstop=4 expandtab
set relativenumber
autocmd InsertEnter * :set number
autocmd InsertLeave * :set relativenumber

" command to open vimrc in a new buffer
:command! Vrc w | e $MYVIMRC
:command! Vso so ~/.vimrc

" useful 61B macros
:command! Make !make

" tComment leader key mapping
let g:tcommentMapLeaderOp1 = ',c'
let g:tcommentMapLeaderOp2 = ',C'

set nowrap "wrap long lines"
set scrolloff=3 "minimum lines to keep above and below cursor"
set scrolljump=5 "lines to scroll when cursor leaves screen"

" Use <leader>[hjkl] to move between splits
map <leader>h :wincmd h<CR>
map <leader>j :wincmd j<CR>
map <leader>k :wincmd k<CR>
map <leader>l :wincmd l<CR>

" unmapped arrow keys
"noremap  <Up> ""
"noremap! <Up> <Esc>
"noremap  <Down> ""
"noremap! <Down> <Esc>
"noremap  <Left> ""
"noremap! <Left> <Esc>
"noremap  <Right> ""
"noremap! <Right> <Esc>

" quick Python script testing
:command! Pint  w | !python3 -i '%:p'
:command! Pdocv w | !python3 -m doctest -v '%:p'
:command! Pdoc  w | !python3 -m doctest '%:p'

set laststatus=2   " Always show the statusline
set encoding=utf-8 " Necessary to show Unicode glyphs
let g:Powerline_symbols = 'fancy'

"change working directory to current file"
cmap cwd lcd %:p:h
cmap cd. lcd %:p:h

" Toggle numbering for copy/paste
nnoremap <C-C> :set invrelativenumber<CR>

" Highlights the 80 and 81st columns
" highlight ColorColumn ctermbg=green
set colorcolumn=81,82

"NERDTree Window Width
let g:NERDTreeWinSize = 40

"NERDTree settings
nnoremap <leader>n :NERDTreeToggle<CR>
nnoremap <leader>m :NERDTreeFind<CR>

" Store the bookmarks file
let NERDTreeBookmarksFile = expand("~.vim/NERDTreeBookmarks")

" Show the bookmarks table on startup
let NERDTreeShowBookmarks = 1

" Show hidden files, too
let NERDTreeShowFiles = 1
let NERDTreeShowHidden = 1

" Quit on opening files from the tree
" let NERDTreeQuitOnOpen = 1

" Highlight the selected entry in the tree
let NERDTreeHighlightCursorline = 1

" Don't display these kinds of files
let NERDTreeIgnore=[ '\.pyc$', '\.pyo$', '\.py\$class$', '\.obj$',
             \ '\.o$', '\.so$', '\.egg$', '^\.git$', '\.class$' ]

" Open if no files specified
autocmd vimenter * if !argc() | NERDTree | endif

"Close if last buffer onpen
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

" Tagbar settings
nnoremap <leader>t :TagbarOpen<CR><C-w>l
nnoremap <leader>T :TagbarClose<CR>

" Move between tabs in Vim with h and l

nnoremap <C-h> :tabprevious<CR>
nnoremap <C-l> :tabnext<CR>
nnoremap <silent> <A-j> :execute 'silent! tabmove ' . (tabpagenr()-2)<CR>
nnoremap <silent> <A-l> :execute 'silent! tabmove ' . tabpagenr()<CR>

" reselects visual box after shift
vnoremap < <gv
vnoremap > >gv

" LaTeX-Box stuff
let g:LatexBox_latexmk_preview_continuously="1"
map <silent> <leader>ll :Latexmk<CR>
map <silent> <Leader>ls :silent
        \ !/Applications/Skim.app/Contents/SharedSupport/displayline
        \ <C-R>=line('.')<CR> "<C-R>=LatexBox_GetOutputFile()<CR>"
        \ "%:p" <CR>
