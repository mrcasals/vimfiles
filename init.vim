let mapleader = ","

" ===========================
" List of plugins
" Install with `:PlugInstall`
" ===========================

" vim-plug setup
call plug#begin('~/.config/nvim/bundle')

Plug 'preservim/nerdtree'
Plug 'jistr/vim-nerdtree-tabs'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-endwise'
Plug 'Townk/vim-autoclose'
Plug 'tomtom/tcomment_vim'
Plug 'tpope/vim-fugitive'

Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-rails'
Plug 'dense-analysis/ale'

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

Plug 'vim-airline/vim-airline'

Plug 'christoomey/vim-tmux-navigator'
Plug 'benmills/vimux'

" Color scheme
Plug 'chriskempson/base16-vim'
Plug 'dawikur/base16-vim-airline-themes'
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
" Search results centered please
nnoremap <silent> n nzz
nnoremap <silent> N Nzz

" Terminal
" Close the terminal split
tnoremap <leader>d <C-\><C-n>:q!<CR>

" ===========================
" Plugins config
" ===========================

" NERDTree config
nmap <silent> <leader>p :NERDTreeTabsToggle<cr>%

" Ag.vim config
nmap <leader>a :Ag<Space>

" TComment
map <Leader>co :TComment<CR>

" Fugitive (Git client)
vmap <leader>gb :Gblame<CR>

" fzf
nmap <leader>o :Files<CR>

" ale syntax checkers/linters
let g:ale_linters = {'ruby': ['rubocop']}
let g:ale_fixers = {'ruby': ['rubocop']}
let g:ale_fix_on_save = 0
let g:ale_lint_on_save = 1
nmap <leader>l :ALEFix<CR>

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
" Stop showing the current mode (as in `-- INSERT --`) since we have the bar
set noshowmode

" Strip trailing whitespace on buffer save/write
autocmd BufWritePre * :%s/\s\+$//e

" Set base16
if filereadable(expand("~/.vimrc_background"))
  let base16colorspace=256
  source ~/.vimrc_background
endif

" Make invisible characters visible using these alternatives
set list listchars=tab:»\ ,trail:·,nbsp:\|,precedes:<,extends:>

nmap <leader>rl :call RunSpecInLine()<CR>
nmap <leader>rb :call RunSpecFile()<CR>
nmap <leader>rr :call RunLastSpec()<CR>

function! RunExternalCommand(command)
  call VimuxRunCommand(a:command)
endfunction

" Run tests
let s:last_test = ""
function! RunSpecInLine()
  if InSpecFile()
    let s:last_test = @% . ":" . line(".")
    call RunExternalCommand("bin/rspec ". bufname("%") .":" . line("."))
  endif
endfunction

function! RunSpecFile()
  if InSpecFile()
    let s:last_test = @%
    call RunExternalCommand("bin/rspec " . bufname("%"))
  endif
endfunction

function! RunLastSpec()
  call RunExternalCommand("bin/rspec " . s:last_test)
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
