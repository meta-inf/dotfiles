" Last updated: 2016/8/13
"
"
" VIM-PLUG
" 

" function! DoRemote(arg)
"   UpdateRemotePlugins
" endfunction
"
call plug#begin('~/.config/nvim/bundle')
" airline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
" pandoc; :set spell
Plug 'vim-pandoc/vim-pandoc'
Plug 'vim-pandoc/vim-pandoc-syntax'
" Plug 'meta-inf/vim-instant-markdown'
" git
Plug 'tpope/vim-fugitive'
" themes
Plug 'blueshirts/darcula'
Plug 'tomasr/molokai'
Plug 'baskerville/bubblegum'
Plug 'jacoborus/tender.vim'
" pipe
Plug 'krisajenkins/vim-pipe'
Plug 'kien/ctrlp.vim'
Plug 'spinks/vim-leader-guide'
" CoC
let node_version = system("node -v")
if has("nvim") && node_version[0] == "v" && str2nr(node_version[1:2]) >= 12
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
endif
Plug 'Vimjas/vim-python-pep8-indent'

call plug#end()


"
" COMMONS
" 

let g:airline_theme = 'tender'
" Use some 8-bit colors when launched from cmd.exe
if has("win32") && !has("gui_running")
	colors pablo
else
    set t_Co=16777216
    " set t_Co=256
    if (has("termguicolors"))
     set termguicolors
    endif
    colors bubblegum-256-dark
endif

" gui
if has("gui_running")
	if has("gui_gtk2")
		set gfn=Consolas\ 13
	elseif has("gui_win32")
		set gfn=Consolas:h13:cANSI
		set guifontwide=SimHei:h13:cANSI
	endif
	set guioptions-=T
	set guioptions-=m
	set guioptions-=r
endif

syntax on
" set bg=dark
set et ai ts=4 sw=4
" set noet cin
set cc=96
set nu
set hlsearch
set incsearch
set cole=0
set mouse=a
set showcmd
set wildmenu
set backspace=indent,eol,start

let mapleader = ' '
let maplocalleader = '\'

let g:tex_flavor=1 " use latex

if has('nvim')
	tnoremap <Esc> <C-\><C-n><C-w>w
endif

" w!!
if !has("win32") && !has("win64")
	cmap w!! w !sudo tee > /dev/null %
endif

" toggle linenumber / wrap
nnoremap <F2> :set nonumber! number?<CR>
nnoremap <F4> :set wrap! wrap?<CR>

" cd to current dir
noremap <C-C> :cd %:p:h<CR>

" tab switching: [C-](J|K) to whatever shown pre/next on tabline, <Spc>bj/k to
" pre/next buffer 
fu SwitchP()
	if tabpagenr('$') == 1
		bpre
	else
		tabp
	endif	
endfu

fu SwitchN()
	if tabpagenr('$') == 1
		bnex
	else
		tabn
	endif
endfu

noremap J :call SwitchP()<CR>
noremap K :call SwitchN()<CR>
noremap <C-J> :call SwitchP()<CR>
noremap <C-K> :call SwitchN()<CR>
inoremap <C-J> <Esc>:call SwitchP()<CR>a
inoremap <C-K> <Esc>:call SwitchN()<CR>a
vnoremap <C-J> <Esc>:call SwitchP()<CR>v
vnoremap <C-K> <Esc>:call SwitchN()<CR>v


" encoding
set fileencodings=utf-8,ucs-bom,gb18030,gbk,gb2312,cp936
set termencoding=utf-8
set encoding=utf-8


"
" PLUGINS
"

" airline
let g:airline#extensions#tabline#enabled = 1
set laststatus=2

" leader-guide
nnoremap <silent> <leader> :<c-u>LeaderGuide '<Space>'<CR>
vnoremap <silent> <leader> :<c-u>LeaderGuideVisual '<Space>'<CR>

if has_key(plugs, 'coc.nvim')
    source ~/dotfiles/coc-rc.vim
endif

"
" LANGUAGE-SPECIFIC CONFIGURATIONS
" 

function CFamilySetup()
	" We don't have `go to` features atm ...
endfunction

" Merlin for OCaml. Untested.
if exists("has_merlin")
	let g:opamshare = substitute(system('opam config var share'),'\n$','','''')
	execute "set rtp+=" . g:opamshare . "/merlin/vim"
endif

function OCamlSetup()
	setlocal ts=2 sw=2 et nocin ai
	" Merlin bindings; merlin has set <leader>t by default.
	nnoremap <buffer> <leader>L :Locate<CR>
	nnoremap <buffer> <F9> :ErrorCheck<CR>
	nnoremap <LocalLeader>r <Plug>(MerlinRename)
	nnoremap <LocalLeader>R <Plug>(MerlinRenameAppend)
endfunction

function PythonSetup()
	setlocal et ai
    set fdm=indent foldlevel=99
endfunction

autocmd FileType c,cpp call CFamilySetup()
autocmd FileType ocaml call OCamlSetup()
autocmd FileType python call PythonSetup()
autocmd FileType asm setlocal ts=8 noet
autocmd FileType html,javascript setlocal ts=2 et sw=2 ai
au FileType haskell setlocal ts=2 et sw=2 ai

function PandocSetup()
	setlocal cole=0 sw=4 ts=4 nospell et " ts,sw>=4 is required
	" Pandoc Plugin
	let g:pandoc#syntax#conceal#cchar_overrides = {"list" : "+"}
	let g:pandoc#syntax#conceal#blacklist = ["subscript", "superscript"]
	let g:pandoc#modules#disabled = ["spell"]
	" Comment
	inoremap <buffer> <C-F> <!--<Space><Space>--><Left><Left><Left><Left>
	" Compile
	nnoremap <buffer> <F10> :!ruby ~/tools/comppandoc.rb %:p<CR>
	inoremap <buffer> <F10> <Esc>:!ruby ~/tools/comppandoc.rb %:p<CR>a
	vnoremap <buffer> <F10> :!ruby ~/tools/comppandoc.rb %:p<CR>
	nnoremap <buffer> <F12> :!ruby ~/tools/compbeamer.rb %:p<CR>
	inoremap <buffer> <F12> <Esc>:!ruby ~/tools/compbeamer.rb %:p<CR>a
	vnoremap <buffer> <F12> :!ruby ~/tools/compbeamer.rb %:p<CR>
	" Build table
	vnoremap <buffer> <C-T> :call <SID>table()<cr>
	nnoremap <buffer> <F5>t yyp:s/\v\S.{-}\ze(\s{2}\S\|$)/\=substitute(submatch(0),'.','-','g')/g<CR>
	nnoremap <buffer> <S-F5>T yyP:s/\v\S.{-}\ze(\s{2}\S\|$)/\=substitute(submatch(0),'.','-','g')/g<CR>
endfunction

function LatexSetup()
	nnoremap <buffer> <F10> :!xelatex %:p<CR>
	inoremap <buffer> <F10> <Esc>:!xelatex %:p<CR>a
	vnoremap <buffer> <F10> <Esc>:!xelatex %:p<CR>v
endfunction

autocmd FileType pandoc,markdown call PandocSetup()
autocmd FileType tex call LatexSetup()

" Build table in pandoc. TODO: broken in NeoVim
function! s:table() range
	exe "'<,'>Tab /|"
	exe "'<,'>Tab /<bar>"
	let hsepline= substitute(substitute(getline("."),'[^\x00-\xff]',"--","g"),'[^|]','-','g')
	exe "norm! o" .  hsepline
	exe "'<,'>s/-|/ |/g"
	exe "'<,'>s/|-/| /g"
	exe "'<,'>s/^| \\|\\s*|$\\||//g"
endfunction

