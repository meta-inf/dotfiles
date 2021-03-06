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
Plug 'tpope/vim-sleuth'
" themes
Plug 'blueshirts/darcula'
Plug 'tomasr/molokai'
Plug 'baskerville/bubblegum'
Plug 'jacoborus/tender.vim'
" pipe
Plug 'krisajenkins/vim-pipe'
Plug 'kien/ctrlp.vim'
Plug 'hecal3/vim-leader-guide'
" Deoplete
if has('nvim')
	Plug 'Shougo/deoplete.nvim'
	if has('python3')
		Plug 'zchee/deoplete-jedi'
	endif
endif
" Haskell stuff
if (has('nvim') && executable("stack"))
	let g:haskell_ready = 1
	Plug 'parsonsmatt/intero-neovim'
	" Plug 'eagletmt/neco-ghc'
endif
Plug 'Vimjas/vim-python-pep8-indent'
call plug#end()



"
" COMMONS
" 

set t_Co=16777216
if (has("termguicolors"))
 set termguicolors
endif
" colors tender 
let g:airline_theme = 'tender'
" set t_Co=256
if $TERM == "screen-256color"
	colors tender
else
	colors delek
endif
" let g:airline_theme = "bubblegum"

syntax on
" set bg=dark
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


"
" Leader guide
"

call leaderGuide#register_prefix_descriptions("<Space>", "g:lmap")
nnoremap <silent> <leader> :<c-u>LeaderGuide '<Space>'<CR>
vnoremap <silent> <leader> :<c-u>LeaderGuideVisual '<Space>'<CR>

" Define prefix dictionary
let g:lmap =  {}

" Second level dictionaries:
let g:lmap.b = { 
			\'name' : 'Buffer',
			\'j' : ['bpre', 'Prev'],
			\'k' : ['bnex', 'Next'],
			\}

let g:lmap.t = { 
			\'name' : 'Tab',
			\'j' : ['call SwitchP()', 'Prev'],
			\'k' : ['call SwitchN()', 'Next'],
			\}

let g:lmap.m = { 'name' : 'Misc' }
noremap <leader>yf :let @"="\n".expand("%:p")."\n".line(".").": ".getline(line("."))<Enter>
let g:lmap.m.f = ['let @"="\n".expand("%:p")."\n".line(".").": ".getline(line("."))', 'Copy filename etc']


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

if exists("g:haskell_ready")

  " let g:haskellmode_completion_ghc = 0
  " autocmd FileType haskell setlocal omnifunc=necoghc#omnifunc

  augroup interoMaps
    au!
    " Maps for intero. Restrict to Haskell buffers so the bindings don't collide.
  
    " Background process and window management
    au FileType haskell nnoremap <silent> <leader>is :InteroStart<CR>
    au FileType haskell nnoremap <silent> <leader>ik :InteroKill<CR>
  
    " Open intero/GHCi split horizontally
    au FileType haskell nnoremap <silent> <leader>io :InteroOpen<CR>
    " Open intero/GHCi split vertically
    au FileType haskell nnoremap <silent> <leader>iov :InteroOpen<CR><C-W>H
    au FileType haskell nnoremap <silent> <leader>ih :InteroHide<CR>
  
    " Reloading (pick one)
    " Automatically reload on save
    au BufWritePost *.hs InteroReload
    " Manually save and reload
    au FileType haskell nnoremap <silent> <leader>wr :w \| :InteroReload<CR>
  
    " Load individual modules
    au FileType haskell nnoremap <silent> <leader>il :InteroLoadCurrentModule<CR>
    au FileType haskell nnoremap <silent> <leader>if :InteroLoadCurrentFile<CR>
  
    " Type-related information
    " Heads up! These next two differ from the rest.
    au FileType haskell map <silent> <leader>t <Plug>InteroGenericType
    au FileType haskell map <silent> <leader>T <Plug>InteroType
    au FileType haskell nnoremap <silent> <leader>it :InteroTypeInsert<CR>
  
    " Navigation
    au FileType haskell nnoremap <silent> <leader>jd :InteroGoToDef<CR>
  
    " Managing targets
    " Prompts you to enter targets (no silent):
    au FileType haskell nnoremap <leader>ist :InteroSetTargets<SPACE>
  augroup END
  
  " Intero starts automatically. Set this if you'd like to prevent that.
  " let g:intero_start_immediately = 0
  
  " Enable type information on hover (when holding cursor at point for ~1 second).
  let g:intero_type_on_hover = 1
  
  " Change the intero window size; default is 10.
  let g:intero_window_size = 10
  
  " Sets the intero window to split vertically; default is horizontal
  " let g:intero_vertical_split = 1
  
  " OPTIONAL: Make the update time shorter, so the type info will trigger faster.
  set updatetime=1000
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
	if !exists("g:pyDefault")
		let g:pyDefault = "PS2()"
	endif
	call eval(g:pyDefault)
	setlocal et ai
endfunction

function PS1()
	let g:pyDefault = "PS1()"
	setlocal colorcolumn=80 ts=2 sw=2 sts=2
endfunction

function PS2()
	let g:pyDefault = "PS2()"
	setlocal colorcolumn=100 ts=2 sw=2 sts=2
endfunction

function PS3()
	let g:pyDefault = "PS3()"
	setlocal colorcolumn=120 ts=4 sw=4 sts=4
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

