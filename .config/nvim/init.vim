call plug#begin()

Plug 'flrnd/plastic.vim'
Plug 'scrooloose/nerdtree'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'liuchengxu/eleline.vim'
Plug 'mhinz/vim-signify'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'HerringtonDarkholme/yats.vim'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'editorconfig/editorconfig-vim'
Plug 'suan/vim-instant-markdown'
Plug 'liuchengxu/vista.vim'
Plug 'machakann/vim-sandwich'
Plug 'godlygeek/tabular'
Plug 'jiangmiao/auto-pairs'
Plug 'mileszs/ack.vim'
Plug 'chr4/nginx.vim'

" utilities
Plug 'roxma/vim-tmux-clipboard'
Plug 'justinmk/vim-sneak'
Plug 'APZelos/blamer.nvim'
Plug 'kristijanhusak/vim-carbon-now-sh'

call plug#end()

set t_Co=256
set background=dark
syntax enable
filetype plugin on
filetype indent on
set nocompatible
set complete-=i
colorscheme plastic
set nu
set autoindent
set cindent
set smartindent
set expandtab
set mouse=a
nnoremap <Leader>o o<Esc>
nnoremap <Leader>O O<Esc>

nmap cp :let @+=expand('%')<CR>

set splitbelow
set splitright

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

let g:eleline_powerline_fonts = 1

map <C-\> :NERDTreeToggle<CR>

nmap <C-p> :call fzf#run(fzf#wrap({'source': 'git ls-files --exclude-standard --others --cached'}))<CR>
set rtp+=~/.fzf

if executable('ag')
    set grepprg=ag\ --nogroup\ --nocolor\ --column
    set grepformat=%f:%l:%c%m
    let g:ackprg = 'ag --column'
endif
nnoremap K :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>
nnoremap <leader>\ :Ack<SPACE>

let g:instant_markdown_slow = 1
let g:instant_markdown_autostart = 0

function! NearestMethodOrFunction() abort
  return get(b:, 'vista_nearest_method_or_function', '')
endfunction

set statusline+=%{NearestMethodOrFunction()}
autocmd VimEnter * call vista#RunForNearestMethodOrFunction()
nnoremap <leader>p  :Vista finder<cr>

au FileType xml setlocal equalprg=xmllint\ --format\ --recover\ -\ 2>/dev/null

autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

let g:UltiSnipsExpandTrigger="<c-n>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

let g:blamer_enabled = 1
let g:blamer_delay = 1500
let g:blamer_date_format = '%d/%m/%y'
let g:blamer_template = '<author>, <committer-time> • <summary>'
