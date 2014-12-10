" vim:foldmethod=marker
let $RUBY_DLL=$HOME.'/.rbenv/versions/2.1.1/lib/libruby.dylib'

" NeoBundle {{{
set nocompatible               " be iMproved
filetype off                   " required!
filetype plugin indent off     " required!

if has('vim_starting')
	set runtimepath+=~/.vim/bundle/neobundle.vim/
	call neobundle#rc(expand('~/.vim/bundle/'))
endif
let g:neobundle#types#git#default_protocol = 'git'
" }}}

NeoBundle 'todesking/loadenv.vim' " {{{
if executable('/usr/local/bin/bash')
	call loadenv#load(
	\ '/usr/local/bin/bash -i -c __CMD__',
	\ ['PATH', 'JAVA_HOME']
	\ )
endif
" }}}

" basic settings {{{
set smartcase
set wrapscan
set incsearch

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

set hidden

set history=500
set nobackup

set directory=$HOME/.vim/swp

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

if has("syntax")
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
augroup END

function! Vimrc_setft(ft) abort " {{{
	if(!exists('b:current_syntax'))
		let &filetype = a:ft
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
	\ '*.scala',
	\ '*.sbt',
	\ 'plugins.sbt:sbt',
	\ '*.md:markdown',
	\ '*.markdown',
	\ '*.coffee',
	\ '*.vim',
	\ '.vimrc:vim',
	\ '*.c',
	\ '*.sh',
	\ '*.yml:yaml',
	\ '*.js:javascript',
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
" :(
cnoremap <C-U><C-P> up
cnoremap u<C-P> up

nnoremap <silent>y= :<C-U>call setreg("*", getreg("0"))<CR>:<C-U>echo "yanked to *: " . getreg("*")[0:30]<CR>

nnoremap ,cn :<C-U>cnext<CR>
nnoremap ,cp :<C-U>cprevious<CR>
nnoremap ,cc :<C-U>cc<CR>

nnoremap <CR> :call append(line('.'),'')<CR>

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

nnoremap \8 :<C-U>setlocal tabstop=8<CR>
nnoremap \4 :<C-U>setlocal tabstop=4<CR>

set visualbell
set t_vb=

function! s:register_jump_key(key)
	exec 'nnoremap' '<silent>'.a:key
				\ a:key
				\   .':call <SID>open_current_fold()<CR>'
				\   .':normal! zz<CR>'
endfunction

function! s:open_current_fold()
	if foldclosed(line(".")) != -1
		normal! zo
	endif
endfunction

call s:register_jump_key('n')
call s:register_jump_key('N')
call s:register_jump_key('*')
call s:register_jump_key('#')
call s:register_jump_key('g*')
call s:register_jump_key('g#')
call s:register_jump_key('{')
call s:register_jump_key('}')
" call s:register_jump_key('<C-I>')
" call s:register_jump_key('<C-O>')
call s:register_jump_key('zz')
call s:register_jump_key('H')
call s:register_jump_key('M')
call s:register_jump_key('L')
" call s:register_jump_key('<C-T>')
" call s:register_jump_key('<C-]>')

try
	nunmap <leader>w=
catch
endtry
nnoremap <silent> <leader>w :let &wrap=!&wrap<CR>:set wrap?<CR>
nnoremap <silent>_ :let &hlsearch=!&hlsearch<CR>:set hlsearch?<CR>
" }}}

autocmd FileType * setlocal formatoptions-=ro

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
	return printf('%-'.alignment.'.'.alignment.'s   [%4d  Lv%-2d]%s',line.'...',foldlength,v:foldlevel,v:folddashes)
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

" Ce command(e based on Currend dir) {{{
command! -complete=customlist,Vimrc_complete_current_dir -nargs=1 Ce :exec ':e '.expand('%:p:h').'/'."<args>"
function! Vimrc_complete_current_dir(ArgLead, CmdLine, CursorPos)
	return Vimrc_complete_dir(expand('%:p:h'), a:ArgLead, a:CmdLine, a:CursorPos)
endfunction
" }}}

function! Vimrc_complete_dir(prefix, ArgLead, CmdLine, CursorPos) abort " {{{
	let prefix = a:prefix . '/'
	let candidates = glob(prefix.a:ArgLead.'*', 1, 1)
	let result = []
	for c in candidates
		if isdirectory(c)
			call add(result, substitute(c, prefix, '', '').'/')
		else
			call add(result, substitute(c, prefix, '', ''))
		endif
	endfor
	return result
endfunction  " }}}

" e-in-current-project
command! -complete=customlist,Vimrc_complete_current_project_files -nargs=1 Pe :exec ':e ' . CurrentProjectInfo().path . '/' . "<args>"
command! -complete=customlist,Vimrc_complete_current_main_project_files -nargs=1 PE :exec ':e ' . CurrentProjectInfo().main_path . '/' . "<args>"
function! Vimrc_complete_current_project_files(ArgLead, CmdLine, CursorPos) abort " {{{
	let prefix = CurrentProjectInfo(expand('%')).path
	return Vimrc_complete_dir(prefix, a:ArgLead, a:CmdLine, a:CursorPos)
endfunction " }}}
function! Vimrc_complete_current_main_project_files(ArgLead, CmdLine, CursorPos) abort " {{{
	let prefix = CurrentProjectInfo(expand('%')).main_path
	return Vimrc_complete_dir(prefix, a:ArgLead, a:CmdLine, a:CursorPos)
endfunction " }}}

" Dox {{{
command! Dox :Unite file:.dox/ -default-action=rec
" }}}

" P! {{{
command! -bang -nargs=+ P :exec ':! cd ' . CurrentProjectInfo().main_path . ' && ' . <q-args>
" }}}

" Rename file {{{
" http://vim-users.jp/2009/05/hack17/
command! -nargs=1 -complete=file Rename f <args>|call delete(expand('#'))|w
command! -complete=customlist,Vimrc_complete_current_project_files -nargs=1 PRename exec "f " . CurrentProjectInfo().main_path . "/<args>"|call delete(expand('#'))|w
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
	let project = CurrentProjectInfo()
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
augroup InsertHook
autocmd!
autocmd InsertEnter * highlight StatusLine guifg=#ccdc90 guibg=#2E4340
autocmd InsertLeave * highlight StatusLine guifg=#2E4340 guibg=#ccdc90
augroup END
" }}}

" IM hack(disable im if normal mode) {{{
function! s:disable_im_if_normal_mode()
	if mode() == 'n'
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

" PTags {{{
command! PTags call Vimrc_PTags()

function! Vimrc_PTags() abort " {{{
	let pinfo = CurrentProjectInfo()
	execute '!cd ' . pinfo.path . ' && ctags -R .'
endfunction " }}}

" }}}

" S(source %) {{{
command! S call SourceThis()
" }}}

" qf to syntastic {{{
function! Vimrc_sync_qf_to_syntastic() abort " {{{
	if g:SyntasticLoclist.current().getRaw() == getqflist()
		return
	endif
	let notifier = g:SyntasticNotifiers.Instance()
    call notifier.reset(g:SyntasticLoclist.current())
	call b:syntastic_loclist.destroy()

	let loclist = g:SyntasticLoclist.New(getqflist())
	call loclist.deploy()
	call Vimrc_syntastic_notifier_try_refresh(notifier, loclist)
endfunction " }}}
function! Vimrc_syntastic_notifier_try_refresh(notifier, loclist) " {{{
	try
		call a:notifier.refresh(a:loclist)
	catch /^Vim\%((\a\+)\)\=:E523/
	endtry
endfunction " }}}
" }}}

" checkstyle to qf {{{
command! -nargs=1 -complete=customlist,Vimrc_complete_current_project_files LoadCheckStyle call LoadCheckStyle(CurrentProjectInfo().path . '/' . <q-args>)

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
