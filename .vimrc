call plug#begin('~/.vim/plugged')

Plug 'tpope/vim-fugitive'
Plug 'scrooloose/nerdtree'
Plug 'scrooloose/nerdcommenter'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-rails'
Plug 'vim-ruby/vim-ruby'
Plug 'slim-template/vim-slim'
Plug 'MarcWeber/vim-addon-mw-utils'
Plug 'tomtom/tlib_vim'
Plug 'tpope/vim-endwise'
Plug 'mileszs/ack.vim'
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-sleuth'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'terryma/vim-multiple-cursors'
Plug 'tmux-plugins/vim-tmux-focus-events'
Plug 'dracula/vim'
Plug 'othree/html5.vim'
Plug 'junegunn/fzf'
Plug 'roxma/vim-tmux-clipboard'
Plug 'godlygeek/tabular'
Plug 'shougo/deoplete.nvim'
Plug 'fatih/vim-go'
Plug 'tpope/vim-surround'
Plug 'roxma/vim-hug-neovim-rpc'
Plug 'roxma/nvim-yarp'
Plug 'majutsushi/tagbar'
Plug 'suan/vim-instant-markdown'
Plug 'wakatime/vim-wakatime'
Plug 'jparise/vim-graphql'
Plug 'leafgarland/typescript-vim'
Plug 'peitalin/vim-jsx-typescript'

call plug#end()

filetype on
filetype plugin on    " required
filetype indent on

" basic setting
set t_Co=256
colorscheme dracula
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

" Expert mode
nnoremap <Left> :echoe "Use h"<CR>
nnoremap <Right> :echoe "Use l"<CR>
nnoremap <Up> :echoe "Use k"<CR>
nnoremap <Down> :echoe "Use j"<CR>

" Make it obvious where 80 characters is
set textwidth=80
set colorcolumn=+1

" Theme
syntax enable
"set background=dark
let g:gruvbox_italic=1
hi LineNr       term=bold cterm=bold ctermfg=2 guifg=Grey guibg=Grey90

" NERDtree
map <C-\> :NERDTreeToggle<CR>

" Tagbar
nmap <F8> :TagbarToggle<CR>

" Fzf
nmap <C-p> :FZF<CR>
set rtp+=~/.fzf

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

call deoplete#custom#option({
      \'max_list': 10,
      \'auto_complete_delay': 20,
      \})
" Let <Tab> also do completion
inoremap <silent><expr> <Tab>
\ pumvisible() ? "\<C-n>" :
\ deoplete#mappings#manual_complete()

" Close the documentation window when completion is done
autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif

" Markdown
let g:instant_markdown_slow = 1
let g:instant_markdown_autostart = 0

" wakatime
let g:wakatime_PythonBinary = '/usr/local/bin/python'  " (Default: 'python')

" Typescript
autocmd BufNewFile,BufRead *.tsx,*.jsx set filetype=typescript.tsx
hi tsxTagName guifg=#E06C75
hi tsxCloseString guifg=#F99575
hi tsxCloseTag guifg=#F99575
hi tsxAttributeBraces guifg=#F99575
hi tsxEqual guifg=#F99575

" yellow
hi tsxAttrib guifg=#F8BD7F cterm=italic

" light-grey
hi tsxTypeBraces guifg=#999999
" dark-grey
hi tsxTypes guifg=#666666
hi ReactState guifg=#C176A7
hi ReactProps guifg=#D19A66
hi Events ctermfg=204 guifg=#56B6C2
hi ReduxKeywords ctermfg=204 guifg=#C678DD
hi WebBrowser ctermfg=204 guifg=#56B6C2
hi ReactLifeCycleMethods ctermfg=204 guifg=#D19A66
