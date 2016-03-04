set nocompatible              " be iMproved, required
filetype off                  " required

" fzf
set rtp+=~/.fzf
" FZF integration
let g:fzf_launcher = "fzf_launch %s"
let g:fzf_action = {
  \ 'ctrl-m': 'e',
  \ 'ctrl-t': 'tabedit'}
nnoremap <C-f> :FZF<cr>

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

" plugins
Plugin 'mbbill/undotree'
Plugin 'scrooloose/nerdtree.git'
Plugin 'bling/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'jeetsukumaran/vim-buffergator.git'
Plugin 'Lokaltog/vim-easymotion'
Plugin 'tpope/vim-fugitive.git'
Plugin 'aperezdc/vim-template.git'
Plugin 'evidens/vim-twig.git'
Plugin 'unblevable/quick-scope'
Plugin 'rking/ag.vim'
Plugin 'junegunn/goyo.vim'
Plugin 'othree/html5.vim'
Plugin 'tpope/vim-surround'
Plugin 'scrooloose/syntastic'
" buggy Plugin 'sirver/ultisnips'
" Plugin 'honza/vim-snippets'
Plugin 'rename'
"Plugin 'php_localvarcheck.vim' " causes pattern uses more memory than 'maxmempattern' error on large files if enabled

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

"return the syntax highlight group under the cursor ''
function! StatuslineCurrentHighlight()
    let name = synIDattr(synID(line('.'),col('.'),1),'name')
    if name == ''
        return ''
    else
        return '[' . name . ']'
    endif
endfunction

syntax on
set backspace=2
set background=dark
set hidden           " Make certain buffers hidden
set pastetoggle=<F2> " Bind pastetoggle to F2
set showmode         " Show what mode you're in
set nocompatible
set ai               " Set autoindent
set smartindent      " Use intelligent indentation
set tabstop=4        " Tab width is 4 spaces
set shiftwidth=4     " Indent also with 4 spaces
set expandtab        " Expand tabs to spaces
set textwidth=0      " Sets width of text per line, 0 for line wrapping
set wrap             " Set wrapping
set linebreak        " For some reason, wiki says this should be set when trying to disasble linebreak
set nolist           " List disables linebreak
set wrapmargin=0     " Stop inserting line break on wrap
set formatoptions+=1 " Stop wrapping
set number           " Show line number
set relativenumber   " hybrid line number
set showmatch        " Hilights matching searched
set ignorecase       " Searches are case insensitive...
set smartcase        " ... unless they contain at least one capital letter
set t_Co=256         " 256 colours
set tags=./tags;/    " Search the source tree for tags
set laststatus=2     " Always show the statusline
set encoding=utf-8   " Necessary to show Unicode glyphs
set nomodeline       " Disable reading the first and last few lines of each file for ex commands, for security reasons
set noswapfile       " no swap files
set statusline=%f\   "tail of the filename
set statusline+=\ \ %c, "cursor column
set statusline+=%l/%L "cursor line/total lines
set statusline+=\ %P "percent through file
set laststatus=2
set mouse=""         " disable mouse

nmap <silent> <A-Up> :wincmd k<CR>
nmap <silent> <A-Down> :wincmd j<CR>
nmap <silent> <A-Left> :wincmd h<CR>
nmap <silent> <A-Right> :wincmd l<CR>

" jk instead of Esc
imap jk <Esc>

filetype plugin on
filetype plugin indent on
filetype indent on   " Makes indentation different per file, good with html
filetype on

" automatically add "}" after typing "{"
inoremap {      {}<Left>
inoremap {<CR>  {<CR>}<Esc>O
inoremap {{     {
inoremap {}     {}

" w!! will write as sudo
cmap w!! w !sudo tee % >/dev/null<CR>:e!<CR><CR>
" Bind f2 to pastetoggle
nnoremap <F2> :set invpaste paste?<CR>
" Rebinding supertab to <F3>
let g:SuperTabMappingForward = '<F3>'
" swaps between header and source
map <F4> :A<CR>
" opens a definition in a new tab
map <F5> :tab split<CR>:exec("tag ".expand("<cword>"))<CR>
" opens a definition in a vspilt
map <F6> :vsp <CR>:exec("tag ".expand("<cword>"))<CR>)
" set tagbartoggle
nmap <F7> :TagbarToggle<CR>
" go to definition
map <F8> <C-]>
" maps NERDTree to F10
map <silent> <F10> :NERDTreeToggle<CR>

" paste with correct indents
nnoremap p p=`]

" Tab remapping
nnoremap tn :tabnext<CR>
nnoremap tp :tabprev<CR>
nnoremap tc :tabnew<CR>

" Resizing split
nnoremap <silent> <Leader>+ :exe "resize " . (winheight(0) * 6/2)<CR>
nnoremap <silent> <Leader>- :exe "resize " . (winheight(0) * 2/6)<CR>

" Press Space to turn off highlighting and clear any message already displayed.
:nnoremap <silent> <Space> :nohlsearch<Bar>:echo<CR>

" colors for tmux
" set term=screen-256color

" Start NERDTree on vimenter
" autocmd vimenter * NERDTree
" autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
" autocmd VimEnter * wincmd p


" tell it to use an undo file
set undofile
" set a directory to store the undo history
set undodir=~/.vim/undo/

" for templates
let g:email = 'eoghan@thejournal.ie'
let g:username = 'Eoghan Hynes'
let g:license = 'Internal use only'

let mapleader=" "


" highlights text with blue when it goes over 80 characters
highlight OverLength ctermbg=Blue ctermfg=white guibg=#592929
match OverLength /\%81v.\+/

" vim-markdown
let g:vim_markdown_folding_disabled=1

" Ctrl+P
set runtimepath^=~/.vim/bundle/ctrlp.vim
let g:ctrlp_match_window = 'bottom,order:btt,min:1,max:10,results:30'
let g:ctrlp_switch_buffer = 'Et'
nnoremap <leader>. :CtrlPTag<cr>

" no bells
set noerrorbells visualbell t_vb=


" buffergator
" Use the right side of the screen
let g:buffergator_viewport_split_policy = 'R'

" I want my own keymappings...
let g:buffergator_suppress_keymaps = 1

" Looper buffers
"let g:buffergator_mru_cycle_loop = 1

" Go to the previous buffer open
nmap <leader>jj :BuffergatorMruCyclePrev<cr>

" Go to the next buffer open
nmap <leader>kk :BuffergatorMruCycleNext<cr>

" View the entire list of buffers open
nmap <leader>bl :BuffergatorOpen<cr>

" Shared bindings from Solution #1 from earlier
nmap <leader>T :enew<cr>
nmap <leader>bq :bp <BAR> bd #<cr>

" Vim Airline
let g:airline_powerline_fonts = 1
" Enable the list of buffers
let g:airline#extensions#tabline#enabled = 1
" Enable syntastic integration
let g:airline#extensions#syntastic#enabled = 1

" Show just the filename
let g:airline#extensions#tabline#fnamemod = ':t'

" theme
let g:airline_theme = 'bubblegum'

" highlight print statements
:highlight preprint ctermbg=blue
:highlight preprint ctermfg=white
:match preprint /pre_print_r(.*);/

" UndoTree
nnoremap <F6> :UndotreeToggle<CR>

" snippets
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"
let g:UltiSnipsEditSplit="vertical"


nnoremap <Leader>rtw :%s/\s\+$//e<CR>

" syntastic recommended settings
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_ignore_files = ['\m.twig$','\m.css$']

" " " " " " " " " " " " " " " " " " " " " " " " "
" Show function names in cwindow
nmap <leader>ff :call ShowFunc("no")<cr><Esc>
nmap <leader>fa :call ShowFunc("yes")<cr><Esc>
function! ShowFunc(sort)
    let gf_s = &grepformat
    let gp_s = &grepprg
    if ( &filetype == "c" || &filetype == "php" || &filetype == "python" ||
      \ &filetype == "sh" )
      let &grepformat='%*\k%*\sfunction%*\s%l%*\s%f %m'
      let &grepprg = 'ctags -x --'.&filetype.'-types=f --sort='.a:sort
    elseif ( &filetype == "perl" )
      let &grepformat='%*\k%*\ssubroutine%*\s%l%*\s%f %m'
      let &grepprg = 'ctags -x --perl-types=s --sort='.a:sort
    elseif ( &filetype == "vim" )
      let &grepformat='%*\k%*\sfunction%*\s%l%*\s%f %m'
      let &grepprg = 'ctags -x --vim-types=f --language-force=vim --sort='.a:sort
    endif
    if (&readonly == 0) | update | endif
    silent! grep %
    cwindow 10
    redraw
    let &grepformat = gf_s
    let &grepprg = gp_s
endfunc
" " " " " " " " " " " " " " " " " " " " " " " " "
" lazy pasting to avoid :set paste :set nopaste
function! WrapForTmux(s)
  if !exists('$TMUX')
    return a:s
  endif

  let tmux_start = "\<Esc>Ptmux;"
  let tmux_end = "\<Esc>\\"

  return tmux_start . substitute(a:s, "\<Esc>", "\<Esc>\<Esc>", 'g') . tmux_end
endfunction

let &t_SI .= WrapForTmux("\<Esc>[?2004h")
let &t_EI .= WrapForTmux("\<Esc>[?2004l")

function! XTermPasteBegin()
  set pastetoggle=<Esc>[201~
  set paste
  return ""
endfunction

inoremap <special> <expr> <Esc>[200~ XTermPasteBegin()
" " " " " " " " " " " " " " " " " " " " " " " " "
" Faster scroll mode
let g:multiscroll_on = 0
function! MultiScroll()
    if g:multiscroll_on
        noremap j j
        noremap k k
        let g:multiscroll_on = 0
    else
        noremap j 5j
        noremap k 5k
        let g:multiscroll_on = 1
    endif
endfunction
map \k :call MultiScroll()<RETURN>
