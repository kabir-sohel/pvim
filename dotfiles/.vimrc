" F2 = toggle line numbering
" F3 = toggle showing invisible characters
" F4 = previous color scheme
" F5 = next color scheme
" F6 = if pm file , compile the current db pm
" F7 = open same file in vertical split
" F8(imap) = print STDERR Data::Dumper::Dumper(
" C-i => toggles number and relative number
" C-n => NerdTree


" vundle set up starts here
set nocompatible "no need to have more vi-compatibility
set backspace=2 "normal backspace
filetype off "switch of filetype detection, for vundle



"***********************************************************"
"***********Starting YCM autocomplete feature****************
"***********************************************************"

set rtp+=~/.vim/bundle/Vundle.vim
"disabling pathogen for now as its troubling me"
""runtime bundle/vim-pathogen/autoload/pathogen.vim
set runtimepath^=~/.vim/bundle/ctrlp.vim

let booking_vimrc = '~/.dotfiles/dotfiles/vimrc_booking'
""Load Some vim plugins"
execute 'source ~/.dotfiles/dotfiles/plugin_options'
execute 'source ~/.dotfiles/dotfiles/vimrc_vundle'
execute 'source ~/.dotfiles/dotfiles/vimrc_braces'
execute 'source ~/.dotfiles/dotfiles/vimrc_you_complete_me'
if !empty( glob('~/.dotfiles/dotfiles/vimrc_booking') )
    execute 'source ~/.dotfiles/dotfiles/vimrc_booking'
endif

filetype plugin indent on

"*****************Basic Sytanx***********************
syntax on                       " Syntax highlighting
set clipboard+=unnamed          " enable copy paste vim buffer global
set background=dark             " Terminal with a dark background
set t_Co=256
" colorscheme oceanblack          " Color scheme
colorscheme torte          " Color scheme
set tabstop=4                   " A tab is four spaces, but ideally 8 spaces, controlled by shiftwidth
set shiftwidth=4                " Number of spaces to use for autoindenting
set expandtab                   " Make a tab to spaces, num of spaces set in tabstop
set smarttab                    " insert tabs at the start of a line according to
" set mouse+=a                    " mouse copy avoids copying the line number
"" set list                        " show invisible characters
set listchars=tab:>·,trail:·    " but only show tabs and trailing whitespace
set number                      " Enable line numbers
set numberwidth=3               " Line number width

set autoindent
set smartindent
set cindent
"testing
"syntax on

"filetype sytanx , plugin and indentation
filetype on
filetype plugin on
filetype indent on
"dynamically set the filetype
au BufNewFile,BufRead *.pm set filetype=perl
au BufNewFile,BufRead *.cpp set filetype=cpp
au BufNewFile,BufRead *.json set filetype=perl

if has ("autocmd")
    " File type detection. Indent based on filetype. Recommended.
    filetype plugin indent on
endif

set vb " use visual bell instead of beeping
set incsearch " incremental search
"testing
set hlsearch "highlight search results
set bg=light " syntax highlighting
set cursorline
"hi CursorLine term=bold ctermbg=LightGray cterm=bold guibg=Grey40
"cterm color list -> "http://upload.wikimedia.org/wikipedia/en/1/15/Xterm_256color_chart.svg
""""hi CursorLine term=bold ctermbg=95 cterm=bold guibg=Grey40
hi CursorLine term=bold ctermbg=8 cterm=bold guibg=Grey40


highlight LineNr term=bold cterm=NONE ctermfg=blue ctermbg=NONE gui=NONE guifg=DarkGrey guibg=NONE
highlight NonText ctermfg=8 guifg=gray

" Set the current line colors begin
"testing
"set cursorline
"hi CursorLine   cterm=NONE ctermbg=DarkGray ctermfg=white guibg=darkred guifg=white
"hi CursorColumn cterm=NONE ctermbg=DarkMagenta ctermfg=white guibg=darkred guifg=white
nnoremap <Leader>c :set cursorline! cursorcolumn!<CR>
" Set the current line colors end


" Set f2 to toggle line numbers
nmap <f2> :set number! number?<cr>
" Set f3 to toggle showing invisible characters
"" Disabling showing invisible chars for now
""nmap <f3> :set list! list?<cr>
""set pastetoggle=<F3>

filetype detect
let my_filename = expand('%:t')
"Booking Start
nmap <F7> :vsplit %<CR>
imap <F8> print STDERR Data::Dumper::Dumper(
if stridx(my_filename, ".pm") >= 0
    if booking_perl
        nmap <F6> !booking-perl -wcI %<CR>
    else
        nmap <F6> !perl -wcI %<CR>
    endif

"Run perl or cpp
elseif &ft == "perl"
    nmap <F6> :!perl %<CR>
elseif &ft == "cpp"
    nmap <F6> :!g++ -Wl,-stack_size,268436000 % && ./a.out<CR>
endif
map <F10> :set syntax=perl <CR>
map <F9> :set syntax=html <CR>
map <C-n> :NERDTreeToggle<CR>

function! PasteToggle()
    if(&paste == 1)
        set nopaste
    else
        set paste
    endif
endfunc

nnoremap <F3> :call PasteToggle()<cr>

function! NumberToggle()
  if(&relativenumber == 1)
    set norelativenumber
    set number
  else
    set relativenumber
  endif
endfunc

nnoremap <C-i> :call NumberToggle()<cr>


if booking_perl
    "do nothing , already done secretely"
else
    au BufWritePost *.pl,*.pm,*.t !perl -wc %
endif
" au BufWritePost *.html,*.comp !booking-perl -I/usr/local/git_tree/main/lib  ~/.dotfiles/dotfiles/compile.pl %

" work around booking shit
source ~/.vim/cyclecolor.vim

"****************************Perl=====>Start**************************

autocmd FileType perl set autoindent|set smartindent " autoindent
autocmd FileType perl set tabstop=4|set shiftwidth=4|set expandtab|set softtabstop=4 " 4 space tabs
autocmd FileType perl set showmatch " show matching brackets
" check perl code with :make
autocmd FileType perl set makeprg=perl\ -c\ %\ $*
autocmd FileType perl set errorformat=%f:%l:%m
autocmd FileType perl set autowrite

" dont use Q for Ex mode
map Q :q
" make tab in v mode ident code
vmap <tab> >gv
vmap <s-tab> <gv

" make tab in normal mode ident code
"nmap <tab> I<tab><esc>
"nmap <s-tab> ^i<bs><esc>

" comment/uncomment blocks of code (in vmode)
vmap _c :s/^/#/gi<Enter>
vmap _C :s/^#//gi<Enter>

let perl_include_pod = 1 " includes pod

" syntax color complex things like @{${"foo"}}
let perl_extended_vars = 1

" Tidy selected lines (or entire file) with _t:
nnoremap <silent> _t :%!perltidy -q<Enter>
vnoremap <silent> _t :!perltidy -q<Enter>

" Deparse obfuscated code
nnoremap <silent> _d :.!perl -MO=Deparse 2>/dev/null<cr>
vnoremap <silent> _d :!perl -MO=Deparse 2>/dev/null<cr>
"****************************Perl=====>End**************************
"testing
"set autoindent
"set smartindent

set laststatus=2
set statusline+=%F

"ctags , created regularly , check ~/.ctags options"
set tags=tags;
""" Disable the annoying endofline char
set fileformats+=dos

"Silver Search"
let g:ackprg = 'ag --nogroup --nocolor --column'
