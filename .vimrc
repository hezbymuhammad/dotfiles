set nocompatible              " be iMproved, required
filetype off                  " required

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'

Plugin 'tpope/vim-fugitive'
Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/nerdcommenter'
Plugin 'airblade/vim-gitgutter'
Plugin 'tpope/vim-rhubarb'
Plugin 'tpope/vim-rails'
Plugin 'vim-ruby/vim-ruby'
Plugin 'slim-template/vim-slim'
Plugin 'MarcWeber/vim-addon-mw-utils'
Plugin 'tomtom/tlib_vim'
Plugin 'tpope/vim-endwise'
Plugin 'mileszs/ack.vim'
Plugin 'jiangmiao/auto-pairs'
Plugin 'tpope/vim-sleuth'
Plugin 'Xuyuanp/nerdtree-git-plugin'
Plugin 'terryma/vim-multiple-cursors'
Plugin 'tmux-plugins/vim-tmux-focus-events'
Plugin 'dracula/vim'
Plugin 'othree/html5.vim'
Plugin 'junegunn/fzf'
Plugin 'itchyny/lightline.vim'
Plugin 'w0rp/ale'
Plugin 'roxma/vim-tmux-clipboard'
Plugin 'NLKNguyen/papercolor-theme'
Plugin 'godlygeek/tabular'
Plugin 'shougo/deoplete.nvim'
Plugin 'fatih/vim-go'
Plugin 'roxma/vim-hug-neovim-rpc'
Plugin 'roxma/nvim-yarp'
Plugin 'majutsushi/tagbar'
Plugin 'suan/vim-instant-markdown'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype on
filetype plugin on    " required
filetype indent on

" basic setting
set t_Co=256
"set termguicolors
set nu
let mapleader=" "
set shiftwidth=2
set tabstop=2
set softtabstop=2
set shiftwidth=2
set autoindent
set cindent
set smartindent
set expandtab
set ttymouse=xterm2
set mouse=a
inoremap { {<CR>}<up><end><CR>
nnoremap <Leader>o o<Esc>
nnoremap <Leader>O O<Esc>
nmap <silent> <A-Up> :wincmd k<CR>
nmap <silent> <A-Down> :wincmd j<CR>
nmap <silent> <A-Left> :wincmd h<CR>
nmap <silent> <A-Right> :wincmd l<CR>

if isdirectory($HOME . '/.vim/backup') == 0
  :silent !mkdir -p ~/.vim/backup >/dev/null 2>&1
endif
set backupdir-=.
set backupdir+=.
set backupdir-=~/
set backupdir^=~/.vim/backup/
set backupdir^=./.vim-backup/
set backup

if isdirectory($HOME . '/.vim/swap') == 0
  :silent !mkdir -p ~/.vim/swap >/dev/null 2>&1
endif
set directory=./.vim-swap//
set directory+=~/.vim/swap//
set directory+=~/tmp//
set directory+=.

if exists("+undofile")
  if isdirectory($HOME . '/.vim/undo') == 0
    :silent !mkdir -p ~/.vim/undo > /dev/null 2>&1
  endif
  set undodir=./.vim-undo//
  set undodir+=~/.vim/undo//
  set undofile
endif

" Theme
syntax enable
set background=dark
let g:gruvbox_italic=1
colorscheme PaperColor
hi LineNr       term=bold cterm=bold ctermfg=2 guifg=Grey guibg=Grey90
let g:PaperColor_Theme_Options = {
  \   'theme': {
  \     'default.dark': { 
  \       'override' : {
  \         'color00' : ['#d3f4ff', '232'],
  \         'linenumber_bg' : ['#d3f4ff', '232']
  \       }
  \     }
  \   }
  \ }

" NERDtree
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
map <C-\> :NERDTreeToggle<CR>
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" Tagbar
nmap <F8> :TagbarToggle<CR>

" Fzf
nmap <C-p> :FZF<CR>
set rtp+=~/.fzf

" lightline
set laststatus=2
let g:lightline = {'colorscheme': 'Dracula'}
" This is regular lightline configuration, we just added 
" 'linter_warnings', 'linter_errors' and 'linter_ok' to
" the active right panel. Feel free to move it anywhere.
" `component_expand' and `component_type' are required.
"
" For more info on how this works, see lightline documentation.
let g:lightline = {
      \ 'active': {
      \   'right': [ [ 'lineinfo' ],
      \              [ 'percent' ],
      \              [ 'linter_warnings', 'linter_errors', 'linter_ok' ],
      \              [ 'fileformat', 'fileencoding', 'filetype' ] ]
      \ },
      \ 'component_expand': {
      \   'linter_warnings': 'LightlineLinterWarnings',
      \   'linter_errors': 'LightlineLinterErrors',
      \   'linter_ok': 'LightlineLinterOK'
      \ },
      \ 'component_type': {
      \   'linter_warnings': 'warning',
      \   'linter_errors': 'error',
      \   'linter_ok': 'ok'
      \ },
      \ }

autocmd User ALELint call lightline#update()

" ale + lightline
function! LightlineLinterWarnings() abort
  let l:counts = ale#statusline#Count(bufnr(''))
  let l:all_errors = l:counts.error + l:counts.style_error
  let l:all_non_errors = l:counts.total - l:all_errors
  return l:counts.total == 0 ? '' : printf('%d --', all_non_errors)
endfunction

function! LightlineLinterErrors() abort
  let l:counts = ale#statusline#Count(bufnr(''))
  let l:all_errors = l:counts.error + l:counts.style_error
  let l:all_non_errors = l:counts.total - l:all_errors
  return l:counts.total == 0 ? '' : printf('%d >>', all_errors)
endfunction

function! LightlineLinterOK() abort
  let l:counts = ale#statusline#Count(bufnr(''))
  let l:all_errors = l:counts.error + l:counts.style_error
  let l:all_non_errors = l:counts.total - l:all_errors
  return l:counts.total == 0 ? '✓' : ''
endfunction

" Git Gutter
if exists('&signcolumn')  " Vim 7.4.2201
    set signcolumn=yes
else
    let g:gitgutter_sign_column_always = 1
endif

function! CleanUp(...)
    if a:0  " opfunc
        let [first, last] = [line("'["), line("']")]
    else
        let [first, last] = [line("'<"), line("'>")]
    endif
    for lnum in range(first, last)
        let line = getline(lnum)

        " clean up the text, e.g.:
        let line = substitute(line, '\s\+$', '', '')

        call setline(lnum, line)
    endfor
endfunction

nmap <silent> <Leader>x :set opfunc=CleanUp<CR>g@

function! NextHunkAllBuffers()
    let line = line('.')
    GitGutterNextHunk
    if line('.') != line
        return
    endif

    let bufnr = bufnr('')
    while 1
        bnext
        if bufnr('') == bufnr
            return
        endif
        if !empty(GitGutterGetHunks())
            normal! 1G
            GitGutterNextHunk
            return
        endif
    endwhile
endfunction

function! PrevHunkAllBuffers()
    let line = line('.')
    GitGutterPrevHunk
    if line('.') != line
        return
    endif

    let bufnr = bufnr('')
    while 1
        bprevious
        if bufnr('') == bufnr
            return
        endif
        if !empty(GitGutterGetHunks())
            normal! G
            GitGutterPrevHunk
            return
        endif
    endwhile
endfunction

nmap <silent> ]c :call NextHunkAllBuffers()<CR>
nmap <silent> [c :call PrevHunkAllBuffers()<CR>

" The Silver Searcher
if executable('ag')
    " Use ag over grep
    set grepprg=ag\ --nogroup\ --nocolor\ --column
    set grepformat=%f:%l:%c%m
    let g:ackprg = 'ag --column'

    " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
    let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

    " ag is fast enough that CtrlP doesn't need to cache
    let g:ctrlp_use_caching = 0
    let g:ctrlp_working_path_mode = 0
endif
" bind K to grep word under cursor
nnoremap K :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>
" bind \ (backward slash) to grep shortcut
"command -nargs=+ -complete=file -bar Ack silent! grep! <args>|cwindow|redraw!
nnoremap \ :Ack<SPACE>

" Easyclip
nnoremap gm m
let g:EasyClipAutoFormat = 1
nmap <leader>cf <plug>EasyClipToggleFormattedPaste

" Tab navigation like Firefox.
nnoremap <C-t>     :tabnew<CR>
inoremap <C-t>     <Esc>:tabnew<CR>

" vim-slim
autocmd FileType slim setlocal foldmethod=indent
autocmd BufNewFile,BufRead *.slim set filetype=slim

" vim easypaste
let g:paste_easy_enable=0

" erb file
autocmd BufRead,BufNewFile *.erb set filetype=eruby.html

" deoplete
let g:deoplete#enable_at_startup = 1
" Let <Tab> also do completion
inoremap <silent><expr> <Tab>
\ pumvisible() ? "\<C-n>" :
\ deoplete#mappings#manual_complete()

" Close the documentation window when completion is done
autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif

" Markdown
let g:instant_markdown_slow = 1
let g:instant_markdown_autostart = 0
