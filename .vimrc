" vim:foldmethod=marker

scriptencoding utf-8

if v:version < 800
	finish
endif

source $VIMRUNTIME/defaults.vim

let $LC_ALL='en_US.UTF8'

set imdisable

inoremap <C-B> <LEFT>
inoremap <C-F> <RIGHT>

let g:Vimrc_status_redraw = 1
augroup Vimrc_status_redraw
	autocmd!
	autocmd CmdlineEnter * let g:Vimrc_status_redraw = 0
	autocmd CmdlineLeave * let g:Vimrc_status_redraw = 1
augroup END
function! g:Vimrc_status_redraw_handler(id) abort " {{{
	if g:Vimrc_status_redraw
		redrawstatus
	endif
endfunction " }}}
let g:Vimrc_status_redraw_timer = timer_start(500, function('g:Vimrc_status_redraw_handler'), {'repeat': -1})

" Python env {{{

" Requirements:
" * Python3
" * pip3 install neovim

set pythonthreehome=/usr/local/Cellar/python/3.7.3/Frameworks/Python.framework/Versions/3.7
set pythonthreedll=/usr/local/Cellar/python/3.7.3/Frameworks/Python.framework/Versions/3.7/Python
set pyxversion=3

" I don't know why, but vim-hug-neovim-rpc failed without this.
" Use silent! to suppress deprecated message
" /must>not&exist/foo:1: DeprecationWarning: the imp module is deprecated in favour of importlib; see the module's documentation for alternative uses
silent! pythonx import neovim

" }}}

" Sandbox {{{
function! s:register_sandbox(path) abort " {{{
	let files = glob(a:path . '/*', 1, 1)
	for f in files
		" TODO: check rtp
		if isdirectory(f)
			execute 'set runtimepath+=' . fnamemodify(f, ':p')
		endif
	endfor
endfunction " }}}

call s:register_sandbox(expand('~/.vim/sandbox'))
" }}}

" Dein {{{
if &compatible
  set nocompatible
endif
let &runtimepath.=','.expand('~/.vim/bundle/dein.vim/')

filetype plugin indent on
syntax enable
" }}}

" basic settings {{{
set smartcase
set wrapscan
set incsearch


augroup vimrc-incsearch-highlight
	autocmd!
	autocmd CmdlineEnter /,\? :set hlsearch
	autocmd CmdlineLeave /,\? :set nohlsearch
augroup END

set mouse=

set noundofile

set ambiwidth=single

set number
set showmatch
set laststatus=2
set showcmd
set viminfo='100,<100,s100,h,rA:,rB:,!,/100

set smartindent
set autoindent

set tabstop=4
set shiftwidth=4

set wildmode=list:longest
set completeopt=menuone,preview
set completeopt-=preview

set hidden

set history=500
set nobackup

set directory=$HOME/.vim/swp
set noswapfile

set foldtext=My_foldtext()
let s:foldcolumn_default=10

set tags+=./tags,./../tags,./../../tags,./../../../tags,./../../../../tags,./../../../../../tags,./../../../../../../tags

set scrolloff=0

set notimeout
set ttimeout
set ttimeoutlen=100

set helplang=en,ja

let $PATH=substitute("~/bin:~/local/bin:~/.rbenv/shims:~/.svm/current/rt/bin:", "\\~", $HOME, "g").$PATH
" }}}

" Visible spaces {{{
" http://blog.remora.cx/2011/08/display-invisible-characters-on-vim.html
set list
set listchars=tab:»\ ,trail:_,extends:»,precedes:«,nbsp:%

if has('syntax')
	" PODバグ対策
	syn sync fromstart
	function! ActivateInvisibleIndicator()
		syntax match InvisibleJISX0208Space "　" display containedin=ALL
		highlight InvisibleJISX0208Space term=underline ctermbg=Blue guibg=darkgray gui=underline
	endf
	augroup invisible
		autocmd! invisible
		autocmd BufNew,BufRead * call ActivateInvisibleIndicator()
	augroup END
endif
" }}}

runtime plugins.vim

" ftdetect {{{
filetype on
filetype plugin indent on

augroup filetypedetect
	autocmd!
	runtime! ftdetect/*.vim

	autocmd BufNewFile,BufRead *
		\ if !did_filetype() && expand("<amatch>") !~ g:ft_ignore_pat
		\ | runtime! scripts.vim | endif
au StdinReadPost * if !did_filetype() | runtime! scripts.vim | endif
augroup END

function! Vimrc_setft(ft) abort " {{{
	if(!exists('b:current_syntax') || b:current_syntax == a:ft)
		exec 'setf ' . a:ft
	endif
endfunction " }}}

function! Vimrc_override_ftdetect(pat, ...) abort " {{{
	if a:0 == 1
		let ft = a:1
	else
		let ft = substitute(a:pat, '\V\^*.', '', '')
	endif
	let events = 'BufNew,BufRead,BufNewFile,'
	augroup filetypedetect
		execute 'autocmd! ' . events . ' ' . a:pat
		execute 'autocmd ' . events . ' ' . a:pat . ' call Vimrc_setft("' . ft . '")'
	augroup END
endfunction " }}}

for s:ft in [
	\ '*.css',
	\ '*.dot',
	\ '*.scala',
	\ '*.sbt',
	\ 'plugins.sbt:sbt',
	\ '*.md:markdown',
	\ '*.mkd:markdown',
	\ '*.markdown',
	\ '*.coffee',
	\ '*.vim',
	\ '.vimrc:vim',
	\ '.gvimrc:vim',
	\ '*.c:cpp',
	\ '*.cpp',
	\ '*.h:cpp',
	\ '*.hpp:cpp',
	\ '*.sh',
	\ '*.yml:yaml',
	\ '*.js:javascript',
	\ '*.java',
	\ '\.bashrc:sh',
	\ '\.bash_profile:sh',
	\ '*.rst',
	\ '*.sql',
	\ '*.html',
	\ '*.py:python',
	\ '*.hs:haskell',
	\ '*.swift',
\ ]
	call call(function('Vimrc_override_ftdetect'), split(s:ft, '\V:'))
endfor
unlet s:ft
" }}}

" Profile {{{
command! -nargs=1 ProfileStart profile start <args> | profile file * | profile func *
" }}}

" GitLab {{{
command! GitLabOpenCommit :execute 'Git lab open-commit '.expand('%:p').' '.line('.')
command! GitLabOpenFile :execute 'Git lab open-file '.expand('%:p').' '.line('.')
" }}}

" General keymap {{{
nnoremap <silent>y= :<C-U>call setreg("*", getreg("0"))<CR>:<C-U>echo "yanked to *: " . getreg("*")[0:30]<CR>

nnoremap ,cn :<C-U>cnext<CR>
nnoremap ,cp :<C-U>cprevious<CR>
nnoremap ,cc :<C-U>cc<CR>

" nnoremap <CR> :call append(line('.'),'')<CR>

nnoremap <silent>,n :tabnew<CR>
nnoremap <silent>,h :tabprevious<CR>
nnoremap <silent>,l :tabnext<CR>
nnoremap <silent>,H :tabmove -1<CR>
nnoremap <silent>,L :tabmove +1<CR>

inoremap <C-E> <End>
inoremap <C-A> <Home>

cnoremap <C-E> <End>
cnoremap <C-A> <Home>

" not works well but I leave it
nnoremap <silent>,bd :<C-U>enew<CR>:bwipeout #<CR>

inoremap <silent><C-L> <C-X><C-L>

nnoremap j gj
nnoremap k gk

nnoremap Y y$

set visualbell
set t_vb=

try
	nunmap <leader>w=
catch
endtry
nnoremap <silent> <leader>w :let &wrap=!&wrap<CR>:set wrap?<CR>
nnoremap <silent>_ :<C-u>call Vimrc_toggle_highlight()<CR>

function! Vimrc_toggle_highlight() abort " {{{
	" b,h
	let transition = {
	\ '00': [1, 1],
	\ '01': [1, 0],
	\ '10': [0, 0],
	\ '11': [1, 0],
	\ }
	let brightest = g:brightest_enable && get(b:, 'brightest_enable', 1)
	let hlsearch = !!&hlsearch
	let current_state = string(brightest) . string(hlsearch)
	let [b, h] = transition[current_state]
	if b
		BrightestEnable
	else
		BrightestDisable
	endif
	if h
		set hlsearch
	else
		set nohlsearch
	endif
endfunction " }}}
" }}}

augroup vimrc-format-options
	autocmd!
	autocmd FileType * setlocal formatoptions-=ro
augroup END

" Folding {{{
" Folding toggle {{{
nnoremap <silent><SPACE> :call <SID>toggle_folding(0)<CR>
nnoremap <silent><S-SPACE> :call <SID>toggle_folding(1)<CR>
function! s:toggle_folding(deep)
	if foldlevel(line('.'))==0
		return
	elseif foldclosed(line('.'))==-1
		if a:deep
			normal zC
		else
			normal zc
		endif
	else
		if a:deep
			normal zO
		else
			normal zo
		endif
	end
endfunction
" }}}
" Foldcolumn toggle {{{
nnoremap <silent>,f :call <SID>toggle_fold_column()<CR>
function! s:toggle_fold_column()
	if &foldcolumn == 0
		let &foldcolumn=s:foldcolumn_default
	else
		let &foldcolumn=0
	endif
endfunction
" }}}
" Custom fold style {{{
" http://d.hatena.ne.jp/leafcage/20111223/1324705686
" https://github.com/LeafCage/foldCC/blob/master/plugin/foldCC.vim
" folding look
function! My_foldtext()
	"表示するテキストの作成（折り畳みマーカーを除去）
	let line = s:remove_comment_and_fold_marker(v:foldstart)
	let line = substitute(line, "\t", repeat(' ', &tabstop), 'g')

	"切り詰めサイズをウィンドウに合わせる"{{{
	let regardMultibyte =strlen(line) -strdisplaywidth(line)

	let line_width = winwidth(0) - &foldcolumn
	if &number == 1 "行番号表示オンのとき
		let line_width -= max([&numberwidth, len(line('$'))])
	endif

	let footer_length=9
	let alignment = line_width - footer_length - 4 + regardMultibyte
	"15はprintf()で消費する分、4はfolddasesを使うための余白
	"issue:regardMultibyteで足される分が多い （61桁をオーバーして切り詰められてる場合
	"}}}alignment

	let foldlength=v:foldend-v:foldstart+1
	let dots=repeat('.',float2nr(ceil(foldlength/10.0)))

	return printf('%-'.alignment.'.'.alignment.'s %3d ',line.' '.dots,foldlength)
endfunction
function! s:fold_navi() "{{{
if foldlevel('.')
	let save_csr=winsaveview()
	let parentList=[]

	"カーソル行が折り畳まれているとき"{{{
	let whtrClosed = foldclosed('.')
	if whtrClosed !=-1
	call insert(parentList, s:surgery_line(whtrClosed) )
	if foldlevel('.') == 1
		call winrestview(save_csr)
		return join(parentList,' > ')
	endif

	normal! [z
	if foldclosed('.') ==whtrClosed
		call winrestview(save_csr)
		return join(parentList,' > ')
	endif
	endif"}}}

	"折畳を再帰的に戻れるとき"{{{
	while 1
	normal! [z
	call insert(parentList, s:surgery_line('.') )
	if foldlevel('.') == 1
		break
	endif
	endwhile
	call winrestview(save_csr)
	return join(parentList,' > ')"}}}
endif
endfunction
" }}}

function! s:remove_comment_and_fold_marker(lnum)"{{{
	let line = getline(a:lnum)
	let comment = split(&commentstring, '%s')
	let comment_end =''
	if len(comment) == 0
		return line
	endif
	if len(comment) >1
	let comment_end=comment[1]
	endif
	let foldmarkers = split(&foldmarker, ',')

	return substitute(line,'\V\%('.comment[0].'\)\?\s\*'.foldmarkers[0].'\%(\d\+\)\?\s\*\%('.comment_end.'\)\?', '','')
endfunction"}}}

function! s:surgery_line(lnum)"{{{
	let line = substitute(s:remove_comment_and_fold_marker(a:lnum),'\V\^\s\*\|\s\*\$','','g')
	let regardMultibyte = len(line) - strdisplaywidth(line)
	let alignment = 60 + regardMultibyte
	return line[:alignment]
endfunction"}}}

" }}}
" }}}

command! Q qa

" Ce command(e based on Currend dir) {{{
command! -complete=customlist,Vimrc_complete_current_dir -nargs=1 Ce :exec ':e '.expand('%:p:h').'/'."<args>"
function! Vimrc_complete_current_dir(ArgLead, CmdLine, CursorPos)
	return Vimrc_complete_dir(expand('%:p:h'), a:ArgLead, a:CmdLine, a:CursorPos)
endfunction
" }}}

" Nyandoc {{{
command! Nyandoc :Unite file:.nyandoc/ -default-action=rec
" }}}

" P! {{{
command! -bang -nargs=+ P :exec ':! cd ' . current_project#info().main_path . ' && ' . <q-args>
" }}}

" Rename file {{{
" http://vim-users.jp/2009/05/hack17/
command! -nargs=1 -complete=file Rename f <args>|call delete(expand('#'))|w
command! -complete=customlist,Vimrc_complete_current_project_files -nargs=1 PRename exec "f " . current_project#info().main_path . "/<args>"|call delete(expand('#'))|w
command! -complete=customlist,Vimrc_complete_current_dir -nargs=1 CRename exec "f ".expand('%:p:h')."/<args>"|call delete(expand('#'))|w
" }}}

" Helptags {{{
command! Helptags call s:helptags('~/.vim/bundle/*/doc')
function! s:helptags(pat)
	for dir in expand(a:pat, 0, 1)
		execute 'helptags '.dir
	endfor
endfunction
" }}}

" Status line {{{
function! Vimrc_current_project()
	if !exists('*current_project#info')
		return ''
	endif
	let project = current_project#info()
	if project['name']
		return '['.project['name'].'] '.project['path']
	else
		return project['path']
	endif
endfunction
let &statusline =
			\  ''
			\. '%<'
			\. '%{Vimrc_current_project()} '
			\. '%m'
			\. '%= '
			\. '%{&filetype}'
			\. '%{",".(&fenc!=""?&fenc:&enc).",".&ff.","}'
			\. '[%{GetB()}]'
			\. '(%3l,%3c)'
function! GetB()
	let c = matchstr(getline('.'), '.', col('.') - 1)
	if &enc != &fenc
		let c = iconv(c, &enc, &fenc)
	endif
	return String2Hex(c)
endfunction
" :help eval-examples
" The function Nr2Hex() returns the Hex string of a number.
func! Nr2Hex(nr)
	let n = a:nr
	let r = ""
	while n
	let r = '0123456789ABCDEF'[n % 16] . r
	let n = n / 16
	endwhile
	return r
endfunc
" The function String2Hex() converts each character in a string to a two
" character Hex string.
func! String2Hex(str)
	let out = ''
	let ix = 0
	while ix < strlen(a:str)
	let out = out . Nr2Hex(char2nr(a:str[ix]))
	let ix = ix + 1
	endwhile
	return out
endfunc

"入力モード時、ステータスラインのカラーを変更
if 0
	augroup InsertHook
	autocmd!
	autocmd InsertEnter * highlight StatusLine guifg=#ccdc90 guibg=#2E4340
	autocmd InsertLeave * highlight StatusLine guifg=#2E4340 guibg=#ccdc90
	augroup END
endif
" }}}

" IM hack(disable im if normal mode) {{{
function! s:disable_im_if_normal_mode()
	if mode() ==# 'n'
		call feedkeys('zz') " I don't know how it works but it works
	endif
endfunction
augroup vimrc-disable-ime-in-normal-mode
	autocmd!
	autocmd FocusGained * call <SID>disable_im_if_normal_mode()
augroup END
" }}}

" vimrc's SID {{{
function! Vimrc_sid()
	return s:vimrc_sid()
endfunction
function! s:vimrc_sid()
	return matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze_vimrc_sid$')
endfunction
" }}}

" S(source %) {{{
command! S call SourceThis()
" }}}

" checkstyle to qf {{{
command! -nargs=1 -complete=customlist,Vimrc_complete_current_project_files LoadCheckStyle call LoadCheckStyle(current_project#info().path . '/' . <q-args>)

function! LoadCheckStyle(xmlfile) abort " {{{
    let xml = webapi#xml#parseFile(a:xmlfile)
    let messages = []
    for file in xml.childNodes('file')
        let path = file.attr.name
        for msg in file.childNodes()
            call add(messages, {
            \'filename': path,
            \'lnum': str2nr(msg.attr.line),
            \'col': str2nr(get(msg.attr, 'column', '0')),
            \'text': msg.attr.message,
            \})
        endfor
    endfor
    call setqflist(messages)
endfunction " }}}
" }}}

" java class file {{{
augroup class
	autocmd!
	autocmd BufReadPost,FileReadPost *.class call JadDecompile()
augroup END

function! JadDecompile() abort " {{{
	let file = expand('%')
	if file =~ '\v^[a-zA-Z0-9_]+\:'
		let file = tempname() . '.class'
		execute 'write ' . file
	endif
	execute '%!jad -noctor -ff -i -p ' . fnameescape(file)
	setlocal readonly
	setlocal filetype=java
	normal gg=G
	setlocal nomodified
endfunction " }}}

" }}}

" jar {{{
autocmd BufReadCmd *.jar call zip#Browse(expand("<amatch>"))
" }}}

let g:html_number_lines = 0

" Shorten qf {{{
augroup vimrc-shorten-qf
	autocmd!
	autocmd! QuickFixCmdPost * call Vimrc_shorten_qf()
augroup END

function! Vimrc_shorten_qf() abort " {{{
	let max = 100
	let qfs = getqflist()
	for qf in qfs
		if(len(qf.text) > max)
			let qf.text = qf.text[0:max]
		endif
	endfor
	let qfs = filter(qfs, 'v:val.valid')
	call scoped_qf#set(qfs)
endfunction " }}}
" }}}

nnoremap <C-B> :<C-U>up<CR>

imap <D-Space> <Space>
