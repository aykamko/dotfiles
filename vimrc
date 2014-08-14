set nocompatible
set encoding=utf-8 " Necessary to show Unicode glyphs

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vundle
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
filetype off

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" Vundles
Bundle 'gmarik/vundle'
Bundle 'LaTeX-Box-Team/LaTeX-Box'
Bundle 'tpope/vim-fugitive'
Bundle 'Lokaltog/vim-easymotion'
Bundle 'Lokaltog/powerline', {'rtp': 'powerline/bindings/vim/'}
Bundle 'majutsushi/tagbar'
" Bundle 'Valloric/YouCompleteMe' <-- Needs to be set up
Bundle 'tComment'
Bundle 'kien/ctrlp.vim'
Bundle 'altercation/vim-colors-solarized'
Bundle 'christoomey/vim-tmux-navigator'
Bundle 'junegunn/vim-easy-align'

call vundle#end()
filetype plugin indent on     " required

" Brief help
" :BundleList          - list configured bundles
" :BundleInstall(!)    - install (update) bundles
" :BundleSearch(!) foo - search (or refresh cache first) for foo
" :BundleClean(!)      - confirm (or auto-approve) removal of unused bundles
"
" NOTE: comments after Bundle commands are not allowed

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" General Settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
syntax enable

" Leader Key
let mapleader = ","

" Display
set ruler           " show cursor position
set nonumber        " hide line numbers
set nolist          " hide tabs and EOL chars
set showcmd         " show normal mode commands as they are entered
set noshowmode      " don't show mode becase powerline already does it
set showmatch       " flash matching delimiters
set nowrap          " don't wrap long lines

" Scrolling
set scrolloff=5     " minimum of three lines above and below cursor
set scrolljump=5    " scroll five lines at a time vertically
set sidescroll=10   " minumum columns to scroll horizontally

" Search
set nohlsearch      " don't persist search highlighting
set incsearch       " search with typeahead

" Indent
set autoindent      " carry indent over to new lines

" Clipboard
set clipboard=unnamed  " set unnamedplus to copy to system clipboard

" Mouse
set mouse=a           " enable mouse movement

" Other
set noerrorbells      " no bells in terminal

set tags=tags;/       " search up the directory tree for tags

set undolevels=1000   " number of undos stored
set viminfo='50,"50   " '=marks for x files, "=registers for x files

set modelines=0       " modelines are bad for your health

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Colorscheme
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set background=dark
colorscheme solarized
set t_Co=256            " tell vim that terminal supports 256 colors

" highlight columns 80, 81, 120, 121
highlight ColorColumn ctermbg=Black
set colorcolumn=80,81,120,121

" unhighlight search terms
highlight Search cterm=NONE ctermbg=NONE

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Indentation
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set shiftwidth=2 
set tabstop=2
set softtabstop=2
set textwidth=79
set expandtab
set backspace=indent,eol,start

autocmd FileType html setlocal textwidth=0
autocmd FileType python setlocal sw=4 ts=4 sts=4
autocmd FileType sh setlocal textwidth=0

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Line Numbering
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" toggle number/relativenumber on insert/normal mode
set number
set relativenumber
autocmd InsertEnter * :set invrelativenumber
autocmd InsertLeave * :set invrelativenumber

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Useful commands and mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" because I suck
:command! WQ wq
:command! Wq wq
:command! W w
:command! Q q

" vimrc
:command! Vrc w | e $MYVIMRC  " open vimrc in a new buffer
:command! Vso so ~/.vimrc     " source vimrc

" useful 61B macros
:command! Make !make

" quick Python script testing
:command! Pint  w | !python3 -i '%:p'
:command! Pdocv w | !python3 -m doctest -v '%:p'
:command! Pdoc  w | !python3 -m doctest '%:p'

" copy to xclip with Control-C
map <C-C> :w !xsel<CR><CR>
vmap <C-C> "*y

" reselects visual box after shift
vnoremap < <gv
vnoremap > >gv

" change working directory to current file
cmap cwd lcd %:p:h
cmap cd. lcd %:p:h

" kill any trailing whitespace on save (Credit to Facebook)
if !exists("g:fb_kill_whitespace") | let g:fb_kill_whitespace = 1 | endif
if g:fb_kill_whitespace
  fu! <SID>StripTrailingWhitespaces()
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    call cursor(l, c)
  endfu
  au FileType c,cabal,cpp,haskell,javascript,php,python,ruby,readme,tex,text
    \ au BufWritePre <buffer>
    \ :call <SID>StripTrailingWhitespaces()
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim-tmux-navigator
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use <leader>[hjkl] to move between splits
map <leader>h :wincmd h<CR>
map <leader>j :wincmd j<CR>
map <leader>k :wincmd k<CR>
map <leader>l :wincmd l<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" tComment
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use <leader>c to comment lines of code
map <leader>c :TComment<CR>
vmap <leader>c :TComment<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Powerline
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set laststatus=2   " Always show the statusline

" remove small delay when leaving insert mode
if !has('gui_running')
    set ttimeoutlen=10
    augroup FastEscape
        autocmd!
        au InsertEnter * set timeoutlen=0
        au InsertLeave * set timeoutlen=1000
    augroup END
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" LaTeX-Box
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:LatexBox_latexmk_preview_continuously="1"
map <silent> <leader>ll :Latexmk<CR>
map <silent> <Leader>ls :silent
        \ !/Applications/Skim.app/Contents/SharedSupport/displayline
        \ <C-R>=line('.')<CR> "<C-R>=LatexBox_GetOutputFile()<CR>"
        \ "%:p" <CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim-easyalign
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Start interactive EasyAlign in visual mode (e.g. vip<Enter>)
vmap <Enter> <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. <Leader>aip)
nmap <Leader>a <Plug>(EasyAlign)

""""""""""""""""""""""""""""""""""""""""""
" You Complete Me <-- Needs to be set up
""""""""""""""""""""""""""""""""""""""""""
" let g:ycm_autoclose_preview_window_after_completion = 1
" let g:ycm_min_num_identifier_candidate_chars = 4
" let g:ycm_global_ycm_extra_conf = '/home/maxim/local/bin/.ycm_extra_conf.py'
" let g:ycm_filetype_specific_completion_to_disable = {'php': 1}
" nnoremap <leader>y :YcmForceCompileAndDiagnostics<cr>
" nnoremap <leader>pg :YcmCompleter GoToDefinitionElseDeclaration<CR>
" nnoremap <leader>pd :YcmCompleter GoToDefinition<CR>
" nnoremap <leader>pc :YcmCompleter GoToDeclaration<CR>
