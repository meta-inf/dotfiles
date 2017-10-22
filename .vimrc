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
" Deoplete
if (has('nvim') && has('python3'))
	Plug 'Shougo/deoplete.nvim'
	Plug 'zchee/deoplete-jedi'
endif
call plug#end()


"
" COMMONS
" 

set t_Co=16777216
if (has("termguicolors"))
 set termguicolors
endif
colors tender 
let g:airline_theme = 'tender'
" set t_Co=256
" colors bubblegum-256-dark
" let g:airline_theme = "bubblegum"

syntax on
set bg=dark
set ts=4 
set sw=4
set noet
set cin
set cc=80
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

" Use some 8-bit colors when launched from cmd.exe
if has("win32") && !has("gui_running")
	colors pablo
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

let g:tex_flavor=1 " use latex

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
noremap <leader>bj :bnex<CR>
noremap <leader>bk :bpre<CR>

" copy filename, line number and current line
noremap <leader>yf :let @"="\n".expand("%:p")."\n".line(".").": ".getline(line("."))<Enter>

" laptop keyboard mapping
if hostname() == "dc-arch"
	noremap <PageDown> <End>
	noremap <PageUp> <Home>
	inoremap <PageDown> <End>
	inoremap <PageUp> <Home>
	vnoremap <PageDown> <End>
	vnoremap <PageUp> <Home>
endif

" encoding
set fileencodings=utf-8,ucs-bom,gb18030,gbk,gb2312,cp936
set termencoding=utf-8
set encoding=utf-8


"
" PLUGINS
"

" ALE
"
if exists("g:ale_completion_delay")
	error
	let g:airline#extensions#ale#enabled = 1
	let g:ale_completion_enabled = 1
	let g:ale_python_autopep8_executable = 'python3 -m autopep8'
endif

" deoplete
"
if (has('nvim') && has('python3'))
	let g:deoplete#enable_at_startup = 1
	" Re-generate popup menu when needed
	inoremap <expr><C-h>
	\ deoplete#smart_close_popup()."\<C-h>"
	inoremap <expr><BS>
	\ deoplete#smart_close_popup()."\<C-h>"
	
	" Close the documentation window when completion is done
	autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif
	
	" deoplete-clang
	let g:deoplete#sources#clang#libclang_path = "/usr/lib/libclang.so"
	let g:deoplete#sources#clang#clang_header = "/usr/lib/clang"

	" Python stuff
	let g:deoplete#sources#jedi#server_timeout = 40
	let g:deoplete#sources#jedi#python_path = '/usr/bin/python3'
	let g:python_host_prog = '/usr/bin/python3'
	let g:deoplete#sources#jedi#show_docstring = 1
	
	" <Tab> completion:
	" 1. If popup menu is visible, select and insert next item
	" 2. Otherwise, if within a snippet, jump to next input
	" 3. Otherwise, if preceding chars are whitespace, insert tab char
	" 4. Otherwise, start manual autocomplete
	imap <silent><expr><Tab> pumvisible() ? "\<C-n>"
		\ : (<SID>is_whitespace() ? "\<Tab>"
		\ : deoplete#mappings#manual_complete())
	
	smap <silent><expr><Tab> pumvisible() ? "\<C-n>"
		\ : (<SID>is_whitespace() ? "\<Tab>"
		\ : deoplete#mappings#manual_complete())
	
	inoremap <expr><S-Tab>  pumvisible() ? "\<C-p>" : "\<C-h>"
endif

function! s:is_whitespace() "{{{
	let col = col('.') - 1
	return ! col || getline('.')[col - 1] =~? '\s'
endfunction "}}}


" airline
let g:airline#extensions#tabline#enabled = 1
set laststatus=2


" vim-instant-markdown


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
	setlocal colorcolumn=100
	setlocal ts=4
	setlocal sw=4
	setlocal et
	setlocal ai
endfunction

autocmd FileType c,cpp call CFamilySetup()
autocmd FileType ocaml call OCamlSetup()
autocmd FileType python call PythonSetup()
autocmd FileType asm setlocal ts=8 noet
autocmd FileType html,javascript setlocal ts=2 et sw=2 ai

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

