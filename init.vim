let mapleader = ","

" ===========================
" List of plugins
" Install with `:PlugInstall`
" ===========================

" vim-plug setup
call plug#begin('~/.config/nvim/bundle')

Plug 'preservim/nerdtree'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-endwise'
Plug 'Townk/vim-autoclose'
Plug 'tomtom/tcomment_vim'
Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-fugitive'

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

Plug 'tpope/vim-dispatch'

Plug 'vim-airline/vim-airline'

" Color scheme
Plug 'phanviet/vim-monokai-pro'
call plug#end()

" ===========================
" Remappings
" ===========================

" General remappings
nmap <leader>w :w!<CR>
nmap <leader>q :qa<CR>
imap jk <ESC>
nnoremap ; :

" Buffer remappings
noremap <tab> :bn<CR>
noremap <S-tab> :bp<CR>
nmap <leader>d :bd<CR>
nmap <leader>D :bufdo bd<CR>

" Splits
nnoremap <leader>v :vs<CR> <C-w>l
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Search
noremap <leader><space> :set hlsearch! hlsearch?<cr>

" ===========================
" Plugins config
" ===========================

" NERDTree config
nmap <silent> <leader>p :NERDTreeToggle<cr>%

" Ag.vim config
nmap <leader>a :Ag<Space>

" TComment
map <Leader>co :TComment<CR>

" Fugitive (Git client)
vmap <leader>gb :Gblame<CR>

" fzf
nmap <leader>o :Files<CR>

" ===========================
" Commands and settings
" ===========================

" Highlights current line
set cursorline
" Adds line numbers
set number
" Replace tabs with spaces
set expandtab
" Set tab character as 2 spaces
set tabstop=2
" Sets how many spaces the << action indents
set shiftwidth=2
" Round << to the nearest shiftwidth
set shiftround
" Remove _ from the keywords list, so they're considered a different word
set iskeyword-=_
" Set terminal window
set title
" Ignore case on search
set ignorecase

" Strip trailing whitespace on buffer save/write
autocmd BufWritePre * :%s/\s\+$//e

" Set monokai-pro as default color scheme
if $COLORTERM ==# 'truecolor'
  set termguicolors
endif
try
  colorscheme monokai_pro
catch /^Vim\%((\a\+)\)\=:E185/
  colorscheme default
endtry

" Make invisible characters visible using these alternatives
set list listchars=tab:»\ ,trail:·,nbsp:\|,precedes:<,extends:>

nmap <leader>rl :call RunSpecInLine()<CR>
nmap <leader>rb :call RunSpecFile()<CR>
nmap <leader>rr :call RunLastSpec()<CR>

" Run tests
let s:last_test = ""
function! RunSpecInLine()
  if InSpecFile()
    let s:last_test = @% . ":" . line(".")
    execute ":Dispatch bin/rspec %:" . line(".")
  endif
endfunction

function! RunSpecFile()
  if InSpecFile()
    let s:last_test = @%
    execute ":Dispatch bin/rspec %"
  endif
endfunction

function! RunLastSpec()
  execute ":Dispatch echo bin/rspec " . s:last_test
endfunction

function! InSpecFile()
  return match(expand("%"), "_spec.rb$") != -1
endfunction

" Rename current file
function! RenameFile()
  let old_name = expand('%')
  let new_name = input('New file name: ', expand('%'))
  if new_name != '' && new_name != old_name
    exec ':saveas ' . new_name
    exec ':silent !rm ' . old_name
    redraw!
  endif
endfunction
map <leader>n :call RenameFile()<cr>
