""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim-plug
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Skip initialization for vim-tiny or vim-small.
if !1 | finish | endif
if has('vim_starting')
  if &compatible
    set nocompatible " be iMproved
  endif
  set encoding=utf-8 " necessary to show Unicode glyphs
endif

" autoinstall vim-plug
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall
endif

call plug#begin('~/.vim/bundle/')

" TODO: test
Plug 'takac/vim-hardtime'

Plug 'ConradIrwin/vim-bracketed-paste'
Plug 'Lokaltog/vim-easymotion'
Plug 'airblade/vim-gitgutter'
Plug 'christoomey/vim-tmux-navigator'
Plug 'itchyny/lightline.vim'
Plug 'kana/vim-textobj-user'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'tomtom/tcomment_vim'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-surround'
Plug 'unblevable/quick-scope'
Plug 'wellle/targets.vim'

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': 'yes \| ./install' }

Plug 'mattn/webapi-vim' | Plug 'mattn/gist-vim', { 'on': 'Gist' }

Plug 'junegunn/vim-easy-align',    { 'on': ['<Plug>(EasyAlign)', 'EasyAlign'] }
Plug 'rking/ag.vim'

Plug 'Glench/Vim-Jinja2-Syntax',   { 'for': 'jinja' }
Plug 'LaTeX-Box-Team/LaTeX-Box',   { 'for': 'tex' }
Plug 'a.vim',                      { 'for': ['c', 'cpp'] }
Plug 'fatih/vim-go',               { 'for': 'go' }
Plug 'jason0x43/vim-js-indent',    { 'for': 'javascript' }
Plug 'kchmck/vim-coffee-script',   { 'for': 'coffeescript' }
Plug 'klen/python-mode',           { 'for': 'python' }
Plug 'leafgarland/typescript-vim', { 'for': 'typescript' }
Plug 'mattn/emmet-vim',            { 'for': ['jinja', 'html'] }
Plug 'nono/vim-handlebars',        { 'for': ['jinja', 'html'] }
Plug 'tpope/vim-rails',            { 'for': 'ruby' }
Plug 'vim-scripts/sh.vim--Cla',    { 'for': ['sh', 'zsh', 'bash'] }

" load on InsertEnter
Plug 'Valloric/YouCompleteMe', { 'on': [], 'do': './install.sh --clang-compiler --gocode-compiler' }
fu! <SID>LoadYCM()
  hi! YCMLoadingLine ctermfg=red
  let curline = line('.')
  let loadline = matchaddpos('YCMLoadingLine', [curline - 1, curline, curline + 1], 12)
  redraw
  echo "Loading YCM..."
  call plug#load('YouCompleteMe')
  call youcompleteme#Enable()
  silent! call matchdelete(loadline)
  redraw!
endfu
augroup plug_on_insertenter
  autocmd!
  autocmd InsertEnter * call <SID>LoadYCM() | autocmd! plug_on_insertenter
augroup END

" load on BufWritePre
Plug 'scrooloose/syntastic' , { 'on': [] }
augroup plug_on_bufwritepre
  autocmd!
  " BUG: must load extraTodo syntax from here again, because loading Syntastic
  " will clear the extraTodo syn group
  autocmd BufWritePre *
        \  call plug#load('syntastic') | call ExtraTodoHi()
        \| autocmd! plug_on_bufwritepre
augroup END

call plug#end()
filetype plugin indent on " required

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" General Settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let mapleader = ' '

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
set clipboard=unnamed,unnamedplus  " set unnamed to copy to system clipboard

" Mouse
set mouse=a           " enable mouse movement

" Other
set noerrorbells      " no bells in terminal

set tags=tags;/       " search up the directory tree for tags

set undolevels=1000   " number of undos stored
set viminfo='50,"50   " '=marks for x files, "=registers for x files

set modelines=0       " modelines are bad for your health

" hack to always display sign column
augroup DisplaySignCol
  au!
  au BufEnter * sign define dummy
  au BufEnter * exe 'sign place 9999 line=1 name=dummy buffer='.bufnr('')
augroup END

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Colorscheme
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
syntax enable

let g:hybrid_use_iTerm_colors = 1
colorscheme hybrid-ayk
set t_Co=256            " tell vim that terminal supports 256 colors

" highlight columns 79, 80, 119, 120
highlight ColorColumn ctermbg=235
set colorcolumn=79,80,119,120

" unhighlight search terms
highlight Search cterm=NONE ctermbg=NONE

" unhighlight sign column
highlight SignColumn cterm=NONE ctermbg=NONE

" add some extra keywords to Todo highlight group
fu! ExtraTodoHi()
  syn keyword extraTodo HACK INFO BUG NOTE containedin=.*Comment.*
  hi def link extraTodo Todo
endfu
augroup extraTodoHi
  au!
  au BufEnter * call ExtraTodoHi() | autocmd! extraTodoHi
augroup END

" change cursor color on insert mode (iTerm only)
if $TERM_PROGRAM =~ 'iTerm'
  if !empty($TMUX)
    let &t_EI = "\033Ptmux;\033\033]Plc4c8c6\033\\"
    let &t_SI = "\033Ptmux;\033\033]Plc8a0d1\033\\"
  else
    let &t_EI = "\033]Plc4c8c6\033\\"
    let &t_SI = "\033]Plc8a0d1\033\\"
  endif
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Line Numbering
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" toggle number/relativenumber on insert/normal mode
set number
set relativenumber
autocmd InsertEnter * :set invrelativenumber
autocmd InsertLeave * :set invrelativenumber

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Indentation
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set shiftwidth=4
set tabstop=4
set softtabstop=4
set expandtab
set backspace=indent,eol,start

" vim-indent-guides
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_auto_colors = 0
let g:indent_guides_start_level = 2
hi IndentGuidesOdd ctermbg=NONE
hi IndentGuidesEven ctermbg=234

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Useful commands and mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" because I suck
command! WQ wq
command! Wq wq
command! W w
command! Q q

" vimrc
command! Vrc w | e $MYVIMRC  " open vimrc in a new buffer
command! Vso so ~/.vimrc     " source vimrc

" copy to xclip with Control-C
map <C-C> :w !xsel<CR><CR>
vmap <C-C> "*y

" reselects visual box after shift
vnoremap < <gv
vnoremap > >gv

" repeat macro in register q
nnoremap Q @q

" paste in insert mode
" (depends on clipboard setting)
inoremap <C-p> <C-R>+

" prettify JSON
command! Prettify %!python -m json.tool

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
  let g:fb_kill_whitespace_blacklist = []
  au BufWritePre <buffer> if index(g:fb_kill_whitespace_blacklist, &ft) < 0
        \| :call <SID>StripTrailingWhitespaces()
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
command! -bang -nargs=? QFix call QFixToggle(<bang>0)
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

" vim-tmux aware killpane
fu! TmuxAwareKillpane()
  if $TMUX == '' || winnr('$') > 1
    silent :q
  else
    call system('tmux kill-pane')
  endif
endfu
nmap <silent> <C-X> :call TmuxAwareKillpane()<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" quick-scope
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Source: https://gist.github.com/cszentkiralyi/dc61ee28ab81d23a67aa
" Only enable the quick-scope plugin's highlighting when using the f/F/t/T movements
let g:qs_enable = 0
let g:qs_enable_char_list = [ 'f', 'F', 't', 'T' ]

function! Quick_scope_selective(movement)
    let needs_disabling = 0
    if !g:qs_enable
        QuickScopeToggle
        redraw
        let needs_disabling = 1
    endif
    let letter = nr2char(getchar())
    if needs_disabling
        QuickScopeToggle
    endif
    return a:movement . letter
endfunction

for i in g:qs_enable_char_list
  execute 'noremap <expr> <silent>' . i . " Quick_scope_selective('". i . "')"
endfor

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
      \   'colorscheme': 'Tomorrow_Night',
      \   'active': {
      \     'left': [ [ 'mode', 'paste' ], [ 'fileinfo', 'syntastic' ] ],
      \     'right': [ [ 'lineinfo' ], [ 'fugitive' ], ['filetype'] ]
      \   },
      \   'inactive': {
      \     'left': [ [ 'fileinfo' ] ],
      \     'right': [ [ 'lineinfo' ], [ 'fugitive' ], ['filetype'] ]
      \   },
      \   'component': {
      \     'fugitive': '%{exists("*fugitive#head")?fugitive#head(5):""}'
      \   },
      \   'component_function' : {
      \     'mode': 'LLMode',
      \     'fileinfo': 'LLFileinfo',
      \   },
      \   'component_expand' : {
      \     'syntastic': 'SyntasticStatuslineFlag',
      \   },
      \   'component_type': {
      \     'syntastic': 'error',
      \   },
      \ }

" mode
function! LLMode()
  let fname = expand('%:t')
  return winwidth(0) > 60 ? lightline#mode() : ''
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
  return ('' != LLReadonly() ? LLReadonly() . ' ' : '') .
        \ ('' != LLTrucatedFilePath() ? LLTrucatedFilePath() : '[No Name]') .
        \ ('' != LLModified() ? ' ' . LLModified() : '')
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
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_min_num_identifier_candidate_chars = 4
let g:ycm_confirm_extra_conf = 0
let g:ycm_global_ycm_extra_conf = '/Users/Aleks/.vim/ycm_extra_conf.py'
nnoremap <leader>yy :YcmForceCompileAndDiagnostics<cr>
nnoremap <leader>fg :YcmCompleter GoToDefinitionElseDeclaration<CR>
nnoremap <leader>ff :YcmCompleter GoToDefinition<CR>
nnoremap <leader>fc :YcmCompleter GoToDeclaration<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Syntastic
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:syntastic_java_javac_custom_classpath_command =
      \ "ant -q path -s | grep echo | cut -f2- -d] | tr -d ' ' | tr ':' '\n'"
let g:syntastic_stl_format = '%E{✖ %e, ␤:%fe}%B{; }%W{♺ %w, ␤:%fw}'

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
" fzf
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <silent> <C-P> :FZF<CR>

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
command! PylintToggle call _PylintToggle()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ag.vim
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:ag_working_path_mode='r'

" source: http://stackoverflow.com/a/6271254
fu! GetVisualSelection()
  let [lnum1, col1] = getpos("'<")[1:2]
  let [lnum2, col2] = getpos("'>")[1:2]
  let lines = getline(lnum1, lnum2)
  let lines[-1] = lines[-1][: col2 - (&selection == 'inclusive' ? 1 : 2)]
  let lines[0] = lines[0][col1 - 1:]
  return join(lines, "\n")
endfu

" redefine Ag to accept visual selections
fu! AgSelection(bang, args, hasrange)
  if a:hasrange > 0
    let selection = GetVisualSelection()
    call ag#Ag(a:bang, a:args == '' ? selection : a:args.' '.selection) | return
  endif
  call ag#Ag(a:bang, a:args)
endfu
augroup plug_on_insertenter
  autocmd!
  autocmd InsertEnter * call <SID>LoadYCM() | autocmd! plug_on_insertenter
augroup END

augroup redefine_ag
  autocmd!
  autocmd! BufEnter *
        \  exec "command! -bang -nargs=* -range=0 -complete=file Ag call AgSelection('grep<bang>', <q-args>, <count>)"
        \| autocmd! redefine_ag
augroup END

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim-easymotion
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" enable easymotion with one leaderkey press
map <Leader> <Plug>(easymotion-prefix)

" vim-sneak
fu! EasyMotion_S_Secondchar()
  call EasyMotion#S(2,1,2)
  normal l
endfu

nmap s <Plug>(easymotion-s2)
nmap <silent> S :call EasyMotion_S_Secondchar()<CR>

nmap <Leader>s <Plug>(easymotion-sn)

" blue and green ayyy lmao
hi EasyMotionTarget ctermfg=39
hi EasyMotionTarget2First ctermfg=40
hi link EasyMotionTarget2Second EasyMotionTarget2First

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Text Objects
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" targets.vim
let g:targets_argTrigger = ','

" vim-textobj-user.vim
" textobj for current line
" Copied from: https://github.com/kana/vim-textobj-user
call textobj#user#plugin('line', {
      \   '-': {
      \     'select-a': 'al', 'select-a-function': 'TextobjCurrentLineA',
      \     'select-i': 'il', 'select-i-function': 'TextobjCurrentLineI',
      \   },
      \ })

function! TextObjCurrentLineA()
  normal! 0
  let head_pos = getpos('.')
  normal! $
  let tail_pos = getpos('.')
  return ['v', head_pos, tail_pos]
endfunction

function! TextobjCurrentLineI()
  normal! ^
  let head_pos = getpos('.')
  normal! g_
  let tail_pos = getpos('.')
  let non_blank_char_exists_p = getline('.')[head_pos[2] - 1] !~# '\s'
  return
  \ non_blank_char_exists_p
  \ ? ['v', head_pos, tail_pos]
  \ : 0
endfunction

" textobj to turn foo_bar_baz into foo_baz *and* quuxSpamEggs into quuxEggs
" Copied from: https://github.com/Julian/vim-textobj-variable-segment/blob/master/plugin/textobj/variable-segment.vim
call textobj#user#plugin('variable', {
    \ '-': {
    \     'select-a': 'as',  'select-a-function': 'TextobjSelectSegmentA',
    \     'select-i': 'is',  'select-i-function': 'TextobjSelectSegmentI',
    \ }})

function! TextobjSelectSegment(object_type, right_boundary)
    let left_boundaries = ['_\+\i', '\<', '\l\u', '\u\u\ze\l', '\a\d', '\d\a']
    call search(join(left_boundaries, '\|'), 'bce')
    let start_position = getpos('.')

    call search('\>', 'c')
    let word_end = getpos('.')
    call setpos('.', start_position)

    call search(a:right_boundary, 'c')
    for _ in range(v:count1 - 1)
        if getpos('.') != word_end
            call search(a:right_boundary)
        endif
    endfor
    let end_position = getpos('.')

    return ['v', start_position, end_position]
endfunction

function! TextobjSelectSegmentA()
    let right_boundaries = ['_', '\l\u', '\u\u\l', '\a\d', '\d\a', '\i\>']
    let right_boundary = join(right_boundaries, '\|')
    let [type, start_position, end_position] = TextobjSelectSegment('a', right_boundary)
    let [_, start_line, start_column, _] = start_position

    call search('\i\>', 'c')
    if end_position == getpos('.') &&
     \ getline(start_line)[start_column - 2] =~# '_'
        let start_position[2] -= 1
    endif

    let was_small_camel = match(expand('<cword>'), '^_*\l.*\u') != -1
    if was_small_camel
        call search('\<', 'bc')
        let [_, _, word_start, _] = getpos('.')

        if start_column - 2 <= word_start ||
         \ getline(start_line)[:start_column - 2] =~# '^_*$'
            call setpos('.', end_position)
            normal! l~
        endif
    endif

    return [type, start_position, end_position]
endfunction

function! TextobjSelectSegmentI()
    let right_boundaries = ['\i_', '\l\u', '\u\u\l', '\a\d', '\d\a', '\i\>']
    return TextobjSelectSegment('i', join(right_boundaries, '\|'))
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim-hardtime
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:hardtime_default_on = 0
let g:hardtime_maxcount = 2
let g:hardtime_timeout = 5000

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim-go
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
au FileType go
      \ exec "nnoremap <leader>gf :GoDef<CR>"

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Filetype
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
autocmd BufNewFile,BufReadPost *.md set filetype=markdown
autocmd BufNewFile,BufReadPost *.hn set filetype=horn
autocmd FileType javascript setl sw=2 sts=2 et
