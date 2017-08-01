let mapleader = ","

" Allow project specific .vimrc
set exrc            " enable per-directory .vimrc files
set secure          " disable unsafe commands in local .vimrc files

set guifont=Source\ Code\ Pro\ Regular\ 12

if has('mouse')
  set mouse=a
endif

set iminsert=0    " Disable capslock"
set nobackup
set nowritebackup
set noswapfile    " http://robots.thoughtbot.com/post/18739402579/global-gitignore#comment-458413287
set history=50
set ruler         " show the cursor position all the time
set showcmd       " display incomplete commands
set incsearch     " do incremental searching
set laststatus=2  " Always display the status line
set autowrite     " Automatically :write before running commands
set relativenumber 
set number        " Show line numbers
set showmode      " Show the current mode
set tabstop=2     " Softtabs, 2 spaces
set shiftwidth=2
set shiftround
set nowrap
set expandtab
set splitbelow " pen new split panes to right and bottom, which feels more natural
set splitright
set incsearch                   " Shows the match while typing
set hlsearch                    " Highlight found searches
set nocursorcolumn           " speed up syntax highlighting
set nocursorline
set updatetime=400
" ----------------------------------------- "
" File Type settings              "
" ----------------------------------------- "
"
" Hard code tabs in Makefiles
au FileType make setlocal noexpandtab
au FileType go setlocal noexpandtab

" Spell checking
au FileType markdown,gitcommit set spell

au BufNewFile,BufRead *.vim setlocal noet ts=2 sw=2 sts=2
au BufNewFile,BufRead *.go setlocal noet ts=2 sw=2

augroup filetypedetect
    au BufNewFile,BufRead *.swift setf swift
    au BufNewFile,BufRead .tmux.conf*,tmux.conf* setf tmux
    au BufNewFile,BufRead .nginx.conf*,nginx.conf* setf nginx
augroup END
 
" Wildmenu completion {{{
set wildmenu
set wildmode=list:longest
set wildmode=list:full

set wildignore+=*.hg,*.git,*.svn                    " Version control
set wildignore+=*.aux,*.out,*.toc                " LaTeX intermediate files
set wildignore+=*.jpg,*.bmp,*.gif,*.png,*.jpeg   " binary images
set wildignore+=*.o,*.obj,*.exe,*.dll,*.manifest " compiled object files
set wildignore+=*.spl                            " compiled spelling word lists
set wildignore+=*.sw?                            " Vim swap files
set wildignore+=*.DS_Store                       " OSX bullshit
set wildignore+=*.luac                           " Lua byte code
set wildignore+=migrations                       " Django migrations
set wildignore+=go/pkg                       " Go static files
set wildignore+=go/bin                       " Go bin files
set wildignore+=go/bin-vagrant               " Go bin-vagrant files
set wildignore+=*.pyc                            " Python byte code
set wildignore+=*.orig                           " Merge resolution files


" This trigger takes advantage of the fact that the quickfix window can be
" easily distinguished by its file-type, qf. The wincmd J command is
" equivalent to the Ctrl+W, Shift+J shortcut telling Vim to move a window to
" the very bottom (see :help :wincmd and :help ^WJ).
"autocmd FileType qf wincmd J

" Strip Trailing Whitespace
nnoremap <Leader>kw :%s/\s\+$//e<CR>

" Close all but the current one
nnoremap <leader>o :only<CR>
"
"Dont show me any output when I build something
"Because I am using quickfix for errors
nmap <leader>m :make<CR><enter>

" Some useful quickfix shortcuts
":cc      see the current error
":cn      next error
":cp      previous error
":clist   list all errors
map <C-n> :cn<CR>
map <C-m> :cp<CR>

" Close quickfix easily
nnoremap <leader>a :cclose<CR>

" Remove search highlight
nnoremap <ESC><ESC> :nohl<CR>

" Center the screen
nnoremap <space> zz

" Quicker window movement
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

tnoremap <C-h> <C-\><C-n><C-w>h
" Workaround since <C-h> isn't working in neovim right now
tnoremap <C-w>h <C-\><C-n><C-w>h
tnoremap <C-j> <C-\><C-n><C-w>j
tnoremap <C-k> <C-\><C-n><C-w>k
tnoremap <C-l> <C-\><C-n><C-w>l

" Move between buffers
nnoremap <leader>h :bprev<CR>
nnoremap <leader>l :bnext<CR>
nnoremap <leader>b :b
autocmd BufWinEnter,WinEnter term://* startinsert
autocmd BufLeave term://* stopinsert

" close buffer but not window
nmap <leader>c :ene<CR>:bw #<CR>

" Forces you to not use the arrow keys
map <UP> <NOP>
map <DOWN> <NOP>
map <LEFT> <NOP>
map <RIGHT> <NOP>
inoremap <UP> <NOP>
inoremap <DOWN> <NOP>
inoremap <LEFT> <NOP>
inoremap <RIGHT> <NOP>

" Prettify json
com! JSONFormat %!python -m json.tool

" Color Theme
"set background=dark

set spelllang=en_us
set spellsuggest=best,3
set dictionary+=/usr/share/dict/words,
set dictionary+=/usr/share/dict/american-english
set dictionary+=/usr/share/dict/web2,
set dictionary+=/usr/share/dict/propernames.gz
set dictionary+=/usr/share/dict/connectives.gz
set dictionary+=/usr/share/dict/web2a.gz
set spellfile=~/.nvim/dict.custom.utf-8.add

" Load plugins
if filereadable(expand("~/.config/nvim/nvimrc.bundles"))
  source ~/.config/nvim/nvimrc.bundles
endif

" Local config
if filereadable($HOME . "~/.nvimrc.local")
  source ~/.nvimrc.local
endif

