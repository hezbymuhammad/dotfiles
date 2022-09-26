call plug#begin()

Plug 'flrnd/plastic.vim'
Plug 'scrooloose/nerdtree'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
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
Plug 'kristijanhusak/vim-carbon-now-sh'
Plug 'nvim-lualine/lualine.nvim'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'lewis6991/gitsigns.nvim'

" LSP
Plug 'hrsh7th/nvim-cmp'
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'

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
let g:markdown_fenced_languages = ['bash=sh', 'javascript', 'js=javascript', 'json=javascript', 'typescript', 'ts=typescript', 'php', 'html', 'css', 'rust']

" custom key
nmap cp :let @+=expand('%')<CR>

" Split more natural
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

" NERDtree
map <C-\> :NERDTreeToggle<CR>

" Fzf
nmap <C-p> :call fzf#run(fzf#wrap({'source': 'git ls-files --exclude-standard --others --cached'}))<CR>
set rtp+=~/.fzf

" The Silver Searcher
if executable('ag')
    " Use ag over grep
    set grepprg=ag\ --nogroup\ --nocolor\ --column
    set grepformat=%f:%l:%c%m
    let g:ackprg = 'ag --column'
endif
" bind K to grep word under cursor
nnoremap K :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>
" bind \ (backward slash) to grep shortcut
"command -nargs=+ -complete=file -bar Ack silent! grep! <args>|cwindow|redraw!
nnoremap <leader>\ :Ack<SPACE>

" Markdown
let g:instant_markdown_slow = 1
let g:instant_markdown_autostart = 0

" xmlint
au FileType xml setlocal equalprg=xmllint\ --format\ --recover\ -\ 2>/dev/null

" yaml
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

" ultisnip
let g:UltiSnipsExpandTrigger="<c-n>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

lua require('gitsigns-custom')
lua require('evil_lualine')

" js / TS
set completeopt=menu,menuone,noselect
autocmd FileType javascript setlocal shiftwidth=4 tabstop=4
autocmd FileType typescript setlocal shiftwidth=4 tabstop=4

" LSP
lua require('cmp-custom')
lua require('denols')
