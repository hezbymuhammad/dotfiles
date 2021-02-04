syntax enable
filetype plugin on
filetype indent on

set number
set path=**
set nocompatible

" Set wild mode
set complete-=i
set wildignore+=**/node_modules/**,**/public/**,.*
set wildmenu
set wildmode=longest:full,full

" Search using Ag
set grepprg=ag\ --nogroup\ --nocolor
command -nargs=+ -complete=file -bar Ag silent! grep! <args>|cwindow|redraw!

" Keystrokes
nnoremap K         :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>
nnoremap <C-p>     :find<SPACE>

" Split more natural
set splitbelow
set splitright

" NERDTree's flavour
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_altv = 1
let g:netrw_winsize = 15
