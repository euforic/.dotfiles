
let mapleader = ","
set guifont=Source\ Code\ Pro\ Regular\ 12

set nocompatible
filetype off

"set ttyfast
"set ttymouse=xterm2
"set ttyscroll=3

set iminsert=0                  " Disable capslock"
set laststatus=2
set encoding=utf-8              " Set default encoding to UTF-8
set autoread                    " Automatically reread changed files without asking me anything
set autoindent                  
set backspace=indent,eol,start  " Makes backspace key more powerful.
set incsearch                   " Shows the match while typing
set hlsearch                    " Highlight found searches
set mouse=a                     "Enable mouse mode
set relativenumber
set tabstop=2                " Softtabs, 2 spaces
set expandtab
set shiftwidth=2
set noerrorbells             " No beeps
set number                   " Show line numbers
set showcmd                  " Show me what I'm typing
set noswapfile               " Don't use swapfile
set nobackup                 " Don't create annoying backup files
set splitright               " Split vertical windows right to the current windows
set splitbelow               " Split horizontal windows below to the current windows
set autowrite                " Automatically save before :next, :make etc.
set hidden
set fileformats=unix,dos,mac " Prefer Unix over Windows over OS 9 formats
set noshowmatch              " Do not show matching brackets by flickering
set noshowmode               " We show the mode with airline or lightline
set completeopt=menu,menuone
set nocursorcolumn           " speed up syntax highlighting
set nocursorline
set updatetime=300
set lazyredraw          " Wait to redraw
set pumheight=10             " Completion window max size
"http://stackoverflow.com/questions/20186975/vim-mac-how-to-copy-to-clipboard-without-pbcopy
set clipboard+=unnamedplus

" color
syntax enable
set t_Co=256

" ----------------------------------------- "
"           File Type settings              "
" ----------------------------------------- "

" Hard code tabs in Makefiles
au FileType make setlocal noexpandtab
au FileType go setlocal noexpandtab

" Spell checking
au FileType markdown,gitcommit set spell

au BufNewFile,BufRead *.vim setlocal noet ts=2 sw=2 sts=2
au BufNewFile,BufRead *.go setlocal noet ts=2 sw=2
autocmd BufNewFile,BufRead *.swift set filetype=swift

augroup filetypedetect
    au BufNewFile,BufRead *.swift setf swift
    au BufNewFile,BufRead .tmux.conf*,tmux.conf* setf tmux
    au BufNewFile,BufRead .nginx.conf*,nginx.conf* setf nginx
augroup END

" Close all but the current one
nnoremap <leader>o :only<CR>

" Remove search highlight
nnoremap <ESC><ESC> :nohl<CR>

" Move between buffers
nnoremap <leader>h :bprev<CR>
nnoremap <leader>l :bnext<CR>
nnoremap <leader>b :b
"
" Search mappings: These will make it so that going to the next one in a
" search will center on the line it's found in.
nnoremap n nzzzv
nnoremap N Nzzzv

" Same when moving up and down
noremap <C-d> <C-d>zz
noremap <C-u> <C-u>zz

" Time out on key codes but not mappings.
" Basically this makes terminal Vim work sanely.
if !has('gui_running')
  set notimeout
  set ttimeout
  set ttimeoutlen=10
  augroup FastEscape
    autocmd!
    au InsertEnter * set timeoutlen=0
    au InsertLeave * set timeoutlen=1000
  augroup END
endif

" Load plugins
if filereadable(expand("~/.config/nvim/nvimrc.bundles"))
  source ~/.config/nvim/nvimrc.bundles
endif

" Local config
if filereadable($HOME . "~/.config/nvim/veonim")
  source ~/.config/nvim/veonim
endif


" Local config
if filereadable($HOME . "~/.nvimrc.local")
  source ~/.nvimrc.local
endif
