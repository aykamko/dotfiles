"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" NeoBundle
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Skip initialization for vim-tiny or vim-small.
if !1 | finish | endif
if has('vim_starting')
  if &compatible
    set nocompatible " be iMproved
  endif

  set runtimepath+=~/.vim/bundle/neobundle.vim/ " init NeoBundle
  set encoding=utf-8 " necessary to show Unicode glyphs
endif

call neobundle#begin(expand('~/.vim/bundle/'))

NeoBundleFetch 'Shougo/neobundle.vim'
" NeoBundle 'Valloric/YouCompleteMe'
NeoBundle 'Glench/Vim-Jinja2-Syntax'
NeoBundle 'Glench/Vim-Jinja2-Syntax'
NeoBundle 'LaTeX-Box-Team/LaTeX-Box'
NeoBundle 'Lokaltog/vim-easymotion'
NeoBundle 'Lokaltog/vim-easymotion'
NeoBundle 'a.vim'
NeoBundle 'airblade/vim-gitgutter'
NeoBundle 'airblade/vim-gitgutter'
NeoBundle 'altercation/vim-colors-solarized'
NeoBundle 'christoomey/vim-tmux-navigator'
NeoBundle 'christoomey/vim-tmux-navigator'
NeoBundle 'itchyny/lightline.vim'
NeoBundle 'jalcine/cmake.vim'
NeoBundle 'jason0x43/vim-js-indent'
NeoBundle 'jason0x43/vim-js-indent'
NeoBundle 'junegunn/vim-easy-align'
NeoBundle 'junegunn/vim-easy-align'
NeoBundle 'kchmck/vim-coffee-script'
NeoBundle 'kchmck/vim-coffee-script'
NeoBundle 'kien/ctrlp.vim'
NeoBundle 'klen/python-mode'
NeoBundle 'leafgarland/typescript-vim'
NeoBundle 'leafgarland/typescript-vim'
NeoBundle 'majutsushi/tagbar'
NeoBundle 'mattn/emmet-vim'
NeoBundle 'nono/vim-handlebars'
NeoBundle 'rking/ag.vim'
NeoBundle 'scrooloose/syntastic'
NeoBundle 'tpope/vim-fugitive'

call neobundle#end()
filetype plugin indent on " required
NeoBundleCheck " check for uninstalled bundles

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

" hack to always display sign column
autocmd BufEnter * sign define dummy
autocmd BufEnter * execute 'sign place 9999 line=1 name=dummy buffer=' . 
            \ bufnr('')

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Colorscheme
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:hybrid_use_iTerm_colors = 1
" colorscheme hybrid-ayk
set t_Co=256            " tell vim that terminal supports 256 colors

" highlight columns 79, 80, 119, 120
highlight ColorColumn ctermbg=235
set colorcolumn=79,80,119,120

" unhighlight search terms
highlight Search cterm=NONE ctermbg=NONE

" unhighlight sign column
highlight SignColumn cterm=NONE ctermbg=NONE

" highlight some extra keywords
syn match extraTodo contained "\<\(HACK\|INFO\|NOTE\):"
hi! def link extraTodo Todo

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

" prettify JSON
:command! Prettify %!python -m json.tool

" remove small delay when leaving insert mode
if !has('gui_running')
    set ttimeoutlen=10
    augroup FastEscape
        autocmd!
        au InsertEnter * set timeoutlen=0
        au InsertLeave * set timeoutlen=1000
    augroup END
endif

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

" set buffer to unmodifiable if read-only
if !exists("g:update_modifiable") | let g:update_modifiable = 1 | endif
if g:update_modifiable
  fu! <SID>UpdateModifiable()
    if !exists("b:setmodifiable")
      let b:setmodifiable = 0
    endif
    if &readonly
      if &modifiable
        setlocal nomodifiable
        let b:setmodifiable = 1
      endif
    else
      if b:setmodifiable
        setlocal modifiable
      endif
    endif
  endfu
  autocmd BufReadPost * call <SID>UpdateModifiable()
endif

" quickfix toggle
command -bang -nargs=? QFix call QFixToggle(<bang>0)
function! QFixToggle(forced)
  if exists("g:qfix_win") && a:forced == 0
    cclose
  else
    copen 10
  endif
endfunction
" used to track the quickfix window per buffer
augroup QFixToggle
 autocmd!
 autocmd BufWinEnter quickfix let g:qfix_win = bufnr("$")
 autocmd BufWinLeave * if exists("g:qfix_win") && expand("<abuf>") == g:qfix_win | unlet! g:qfix_win | endif
augroup END
nmap <leader>q :QFix<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" tComment
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use <leader>c to comment lines of code
map <leader>c :TComment<CR>
vmap <leader>c :TComment<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Lightline
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set laststatus=2   " Always show the statusline
let g:lightline = {
            \ 'colorscheme': 'Tomorrow_Night',
            \ 'active': {
                \ 'left': [ [ 'mode', 'paste' ],
                \           [ 'fileinfo', 'syntastic' ],
                \           [ 'ctrlpmark' ] ],
                \ 'right': [ [ 'lineinfo' ], [ 'fugitive' ], ['filetype'] ] 
            \ },
            \ 'inactive': {
                \ 'left': [ [ 'fileinfo' ] ],
                \ 'right': [ [ 'lineinfo' ], [ 'fugitive' ], ['filetype'] ] 
            \ },
            \ 'component': {
                \ 'fugitive': '%{exists("*fugitive#head")?fugitive#head(5):""}'
            \ },
            \ 'component_function' : {
                \ 'mode': 'LLMode',
                \ 'fileinfo': 'LLFileinfo',
                \ 'ctrlpmark': 'CtrlPMark',
            \ },
            \ 'component_expand' : {
                \ 'syntastic': 'SyntasticStatuslineFlag',
            \ },
            \ 'component_type': {
                \ 'syntastic': 'error',
            \ },
            \ }

" mode
function! LLMode()
    let fname = expand('%:t')
    return fname == 'ControlP' ? 'CtrlP' :
                \ winwidth(0) > 60 ? lightline#mode() : ''
endfunction

" filename and fileinfo
let g:pathname_depth = 3
function! LLModified()
    return &ft =~ 'help' ? '' : &modified ? '+' : &modifiable ? '' : '-'
endfunction
function! LLReadonly()
    return &ft !~? 'help' && &readonly ? 'RO' : ''
endfunction
function! LLTrucatedFilePath()
    let depth = g:pathname_depth ? g:pathname_depth : 10
    let fullpath = expand('%:p:~')
    let truncpath = matchstr(fullpath, 
        \ printf('\(\~\)\?\(/[0-9a-zA-Z_~\-. ]\+\)\{,%d}/[0-9a-zA-Z_\-. ]\+$', 
        \ depth))
    return truncpath
endfunction
function! LLFileinfo()
    let fname = expand('%:t')
    return fname == 'ControlP' ? g:lightline.ctrlp_item :
        \ ('' != LLReadonly() ? LLReadonly() . ' ' : '') .
        \ ('' != LLTrucatedFilePath() ? LLTrucatedFilePath() : '[No Name]') .
        \ ('' != LLModified() ? ' ' . LLModified() : '')
endfunction

" ctrlpmark
function! CtrlPMark()
  if expand('%:t') =~ 'ControlP'
    call lightline#link('iR'[g:lightline.ctrlp_regex])
    return lightline#concatenate([g:lightline.ctrlp_prev, 
                \ g:lightline.ctrlp_item , g:lightline.ctrlp_next], 0)
  endif
  return ''
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" LaTeX-Box
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:LatexBox_custom_indent=0
let g:LatexBox_latexmk_preview_continuously=1
let g:LatexBox_show_warnings=2
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

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" a.vim
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" toggle between .h and .c with <leader>a
nnoremap <Leader>a :A<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" You Complete Me
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" let g:ycm_autoclose_preview_window_after_completion = 1
" let g:ycm_min_num_identifier_candidate_chars = 4
" let g:ycm_confirm_extra_conf = 0
" let g:ycm_global_ycm_extra_conf = '/Users/Aleks/.vim/ycm_extra_conf.py'
" nnoremap <leader>y :YcmForceCompileAndDiagnostics<cr>
" nnoremap <leader>fg :YcmCompleter GoToDefinitionElseDeclaration<CR>
" nnoremap <leader>ff :YcmCompleter GoToDefinition<CR>
" nnoremap <leader>fc :YcmCompleter GoToDeclaration<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Syntastic
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:syntastic_java_javac_custom_classpath_command =
    \ "ant -q path -s | grep echo | cut -f2- -d] | tr -d ' ' | tr ':' '\n'"
let g:syntastic_stl_format = '%E{!(%e) → %fe}%B{, }%W{?(%w) → %fw}'

" disable tex because its annoying
" disable python because pythonmode
let g:syntastic_tex_checkers=[]
let g:syntastic_python_checkers=[]

" hack to get syntastic to update lightline on syntax check
let g:syntastic_mode_map = { "mode": "passive" }
augroup SyntasticLightline
    autocmd!
    autocmd BufWritePost * call s:syntastic_lightline()
augroup END
function! s:syntastic_lightline()
    SyntasticCheck
    call lightline#update()
endfunction

" highlights
hi SpellBad ctermbg=NONE guibg=#1d1f21
hi SpellCap ctermbg=NONE guibg=#1d1f21

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" CtrlP
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <leader>m :CtrlP<CR>
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/]\.(git|hg|svn)$',
  \ 'file': '\v\.(exe|so|dll|class)$',
  \ }
let g:ctrlp_status_func = {
  \ 'main': 'CtrlPStatusFunc_1',
  \ 'prog': 'CtrlPStatusFunc_2',
  \ }

function! CtrlPStatusFunc_1(focus, byfname, regex, prev, item, next, marked)
  let g:lightline.ctrlp_regex = a:regex
  let g:lightline.ctrlp_prev = a:prev
  let g:lightline.ctrlp_item = a:item
  let g:lightline.ctrlp_next = a:next
  return lightline#statusline(0)
endfunction

function! CtrlPStatusFunc_2(str)
  return lightline#statusline(0)
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" pymode
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:pymode_lint_signs = 1
let g:pymode_lint_on_write = 1
let g:pymode_lint_cwindow = 0
let g:pymode_rope_completion = 0
let g:pymode_folding = 0
let g:pymode_lint_ignore = "E501" " ignore 80 char limit

function! _PylintToggle()
    let g:pymode_lint = !g:pymode_lint
endfunction
:command! PylintToggle call _PylintToggle()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Indentation
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set shiftwidth=4
set tabstop=4
set softtabstop=4
set expandtab
set backspace=indent,eol,start

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Filetype
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" autocmd BufNewFile,BufReadPost *.md set filetype=markdown
autocmd BufNewFile,BufReadPost *.hn set filetype=horn
autocmd FileType html setl sw=4 ts=4 sts=4 et
autocmd FileType ruby setl sw=2 ts=2 sts=2 et
autocmd FileType jinja setl sw=4 ts=4 sts=4 et

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" tmux-navigator
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <c-j> <NOP>
nnoremap <c-k> <NOP>
nnoremap <c-h> <NOP>
nnoremap <c-l> <NOP>
