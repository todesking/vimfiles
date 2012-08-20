" vim:foldmethod=marker

" NeoBundle {{{
set nocompatible               " be iMproved
filetype off                   " required!
filetype plugin indent off     " required!

if has('vim_starting')
	set runtimepath+=~/.vim/bundle/neobundle.vim/
	call neobundle#rc(expand('~/.vim/bundle/'))
endif
" }}}

" basic settings {{{
filetype on
filetype plugin indent on
set smartcase
set wrapscan
set incsearch

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

set tags+=./tags,../tags,../../tags,../../../tags,../../../../tags

" }}}

" plugins {{{
NeoBundle 'Shougo/vimproc'

" Unite {{{
NeoBundle 'Shougo/unite.vim'
NeoBundle 'tsukkee/unite-tag'
NeoBundle 'h1mesuke/unite-outline'
NeoBundle 'sgur/unite-qf'
NeoBundle 'basyura/unite-rails'

" Settings {{{
let g:unite_enable_start_insert = 1
let g:unite_update_time = 100

let g:unite_source_file_rec_ignore_pattern =
      \'\%(^\|/\)\.$\|\~$\|\.\%(o\|exe\|dll\|bak\|sw[po]\|class\)$'.
      \'\|\%(^\|/\)\.\%(hg\|git\|bzr\|svn\)\%($\|/\)'.
	  \'\|\.\%(\gif\|jpg\|png\|swf\)$'

call unite#filters#sorter_default#use(['sorter_smart'])

" unite-tag {{{
let s:converter_tag = {
			\ 'name': 'converter_tag',
			\ 'description': 'strip location info for tag',
			\ }
function s:converter_tag.filter(candidates,context)
	let candidates = copy(a:candidates)
	for cand in candidates
		let cand.abbr = substitute(cand.abbr, ' pat:.*', '', '')
	endfor
	return candidates
endfunction

call unite#define_filter(s:converter_tag)
unlet s:converter_tag

call unite#custom_filters('tag',['matcher_default', 'sorter_default', 'converter_tag'])
" }}}
" unite-file_mru {{{
let g:unite_source_file_mru_limit=500
" }}}
" }}}

" Keymap {{{
" in-unite {{{
augroup unite-keybind
	autocmd!
	autocmd FileType unite nmap <buffer><silent><Esc> q
augroup END
" }}}

nnoremap <silent><C-S> :Unite file_mru<CR>

nnoremap <C-Q>  <ESC>

nnoremap <C-Q>u :UniteResume<CR>
nnoremap <C-Q>o :<C-u>Unite outline<CR>
nnoremap <C-Q>p :<C-u>exec 'Unite file_rec:'.<SID>current_project_dir()<CR>
nnoremap <C-Q>t :<C-u>Unite tag<CR>
nnoremap <C-Q>f :<C-u>Unite qf -no-start-insert -auto-preview<CR>

" unite-rails
nnoremap <C-Q>r <ESC>
nnoremap <C-Q>rm :<C-u>Unite rails/model<CR>
nnoremap <C-Q>rc :<C-u>Unite rails/controller<CR>
nnoremap <C-Q>rv :<C-u>Unite rails/view<CR>
nnoremap <C-Q>rd :<C-u>Unite rails/db<CR>

" C-] to unite tag jump
augroup vimrc-tagjump-unite
	autocmd!
	autocmd BufEnter *
				\   if empty(&buftype)
				\|      nnoremap <buffer> <C-]> :<C-u>UniteWithCursorWord -immediately outline tag<CR>
				\|  endif
augroup END
" }}}

" Sources {{{
" unite-neco {{{
" from: https://github.com/ujihisa/config/blob/master/_vimrc
let s:unite_source = {'name': 'neco'}
function! s:unite_source.gather_candidates(args, context)
  let necos = [
        \ "~(-'_'-) goes right",
        \ "~(-'_'-) goes right and left",
        \ "~(-'_'-) goes right quickly",
        \ "~(-'_'-) skips right",
        \ "~(-'_'-)  -8(*'_'*) go right and left",
        \ "(=' .' ) ~w",
        \ ]
  return map(necos, '{
        \ "word": v:val,
        \ "source": "neco",
        \ "kind": "command",
        \ "action__command": "Neco " . v:key,
        \ }')
endfunction
call unite#define_source(s:unite_source)
" }}}
" }}}

" Sorter {{{
" sorter_smart {{{
let s:sorter_smart = {
			\ 'name': 'sorter_smart',
			\ 'description': 'smart sorter',
			\ }
" SPEC
"  keyword is 'user'
"   more is better   : user/user.rb > user/aaa.rb
"   first is better  : user > active_user
"   file > directory : user.rb > user/active_user.rb
"   alphabetical     : a_user.rb > b_user.rb
function! s:sorter_smart.filter(candidates, context)
	if len(a:context.input) == 0
		return a:candidates
	endif
	let keywords = split(a:context.input, '\s\+')
	if a:context.source.name == 'file_mru' && len(keywords) < 2
		return a:candidates
	end
	for candidate in a:candidates
		let candidate.filter__sort_val =
					\ s:sorter_smart_sort_val(candidate.word, keywords)
	endfor
	return unite#util#sort_by(a:candidates, 'v:val.filter__sort_val')
endfunction
function! s:sorter_smart_sort_val(text, keywords)
	let sort_val = ''
	let text_without_keywords = a:text
	for kw in a:keywords
		let sort_val .= printf('%05d', 100 - s:matches(a:text, kw)).'_'
		let sort_val .= printf('%05d', stridx(a:text, kw)).'_'
		let text_without_keywords =
					\ substitute(text_without_keywords, kw, '', 'g')
	endfor
	let sort_val .= text_without_keywords
	return sort_val
endfunction
function! s:matches(str, pat_str)
	let pat = escape(a:pat_str, '\')
	let n = 0
	let i = match(a:str, pat, 0)
	while i != -1
		let n += 1
		let i = match(a:str, pat, i + strlen(a:pat_str))
	endwhile
	return n
endfunction
call unite#define_filter(s:sorter_smart)
unlet s:sorter_smart
" }}}
" }}}

" }}}

NeoBundle 'Shougo/neocomplcache' " {{{
if !exists('g:neocomplcache_omni_patterns')
	let g:neocomplcache_omni_patterns = {}
endif
let g:neocomplcache_omni_patterns.ruby = '[^. *\t]\.\h\w*\|\h\w*::'
let g:neocomplcache_lock_buffer_name_pattern='\*unite\*'
let g:neocomplcache_enable_prefetch = 1
let g:neocomplcache_lock_iminsert = 1
let g:neocomplcache_use_vimproc = 1
let g:neocomplcache_enable_at_startup = 0
" }}}

NeoBundle 'closetag.vim' " {{{
   autocmd Filetype html,xml,xsl,eruby runtime plugin/closetag.vim
" }}}
NeoBundle 'Align' " {{{
let g:Align_xstrlen=3
" }}}
NeoBundle 'todesking/YankRing.vim' " {{{
let g:yankring_max_element_length = 0
let g:yankring_max_history_element_length = 1000 * 10
" }}}
NeoBundle 'AndrewRadev/linediff.vim'
NeoBundle 'tsaleh/vim-matchit'
NeoBundle 'tpope/vim-surround'

NeoBundle 'nathanaelkane/vim-indent-guides' " {{{
	if has('gui')
		augroup vimrc-indentguide
			autocmd!
			autocmd BufWinEnter,BufNew * highlight IndentGuidesOdd guifg=NONE guibg=NONE
		augroup END
		let g:indent_guides_enable_on_vim_startup=1
		let g:indent_guides_start_level=1
		let g:indent_guides_guide_size=1
	endif
" }}}
NeoBundle 'taku-o/vim-zoom'

NeoBundle 'todesking/vim-ruby', {'rev': 'my-custom'}
NeoBundle 'tpope/vim-rails'

NeoBundle 'tpope/vim-fugitive'
NeoBundle 'int3/vim-extradite'

NeoBundle 'todesking/vim-ref', {'rev': 'fix-refe'} "{{{
	let g:ref_refe_cmd="~/local/bin/refe"
	command! -nargs=1 Man :Ref man <args>
"}}}
NeoBundle 'grep.vim'
" }}}

" Ruby {{{
if has("ruby")
  silent! ruby nil
endif
augroup vimrc-filetype-ruby
	autocmd!
	"autocmd FileType ruby set omnifunc=
augroup END
" }}}

" Rails {{{
augroup vimrc-filetype-erb
	autocmd!
	autocmd FileType eruby inoremap <buffer> {{ <%
	autocmd FileType eruby inoremap <buffer> }} %>
	autocmd FileType eruby inoremap <buffer> {{e <% end %><ESC>
	autocmd FileType eruby inoremap <buffer> {b <br /><ESC>
augroup END

" }}}

" General keymap {{{
nnoremap <silent>,n :tabnew<CR>
nnoremap <silent>,h :tabprevious<CR>
nnoremap <silent>,l :tabnext<CR>

nnoremap <silent>,bd :call <SID>delete_buffer_preserve_window()<CR>
function! s:delete_buffer_preserve_window()
	let nr=bufnr('%')
	call feedkeys("\<C-^>:bdelete ".nr."\<CR>",'n')
endfunction

inoremap <silent><C-L> <C-X><C-L>

nnoremap j gj
nnoremap k gk

function! s:register_jump_key(key)
	exec 'nnoremap' '<silent>'.a:key
				\ a:key.':call <SID>hello_again_hook(''CursorHold'')'
				\   .'<CR>:call <SID>open_current_fold()<CR>'
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
nnoremap <leader>f :set foldmethod=syntax<CR>:set foldmethod=manual<CR>
nnoremap <silent>_ :let &hlsearch=!&hlsearch<CR>

autocmd FileType * setlocal formatoptions-=ro
" }}}

" Trailing spaces {{{
try
	nunmap <Leader>cc
catch
endtry
nnoremap <Leader>cc :%s/\s\+$//<CR>
nnoremap <silent><leader>e :call <SID>set_eol_space_highlight('toggle', 1)<CR>

function! s:set_eol_space_highlight(op, show_message)
	if !exists('b:highlight_eol_space')
		let b:highlight_eol_space = 0
	endif
	if (b:highlight_eol_space == 0 && a:op == 'off')
				\ || (b:highlight_eol_space == 1 && a:op == 'on')
		return
	endif
	if a:op == 'off' || (a:op == 'toggle' && b:highlight_eol_space)
		let b:highlight_eol_space = 0
		match none WhitespaceEOL
		if a:show_message
			echo 'EOL space highlight OFF'
		endif
	else
		let b:highlight_eol_space = 1
		match WhitespaceEOL /\s\+$/
		if a:show_message
			echo 'EOL space highlight ON'
		endif
	endif
endfunction

augroup vimrc-trailing-spaces
	autocmd!
	autocmd FileType * highlight WhitespaceEOL ctermbg=red guibg=#550000| call <SID>set_eol_space_highlight('on', 0)
augroup END
" }}}

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
  let line = s:rm_CmtAndFmr(v:foldstart)

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

function! s:rm_CmtAndFmr(lnum)"{{{
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
  let line = substitute(s:rm_CmtAndFmr(a:lnum),'\V\^\s\*\|\s\*\$','','g')
  let regardMultibyte = len(line) - strdisplaywidth(line)
  let alignment = 60 + regardMultibyte
  return line[:alignment]
endfunction"}}}

" }}}
" }}}

" To avoid ultra-heavy movement when Ruby insert mode {{{

" Don't screw up folds when inserting text that might affect them, until
" leaving insert mode. Foldmethod is local to the window. Protect against
" screwing up folding when switching between windows.
autocmd InsertEnter * if !exists('w:last_fdm') | let w:last_fdm=&foldmethod | setlocal foldmethod=manual | endif
autocmd InsertLeave,WinLeave * if exists('w:last_fdm') | let &l:foldmethod=w:last_fdm | unlet w:last_fdm | endif

augroup vimrc-lazy-folding
	autocmd FileType ruby set foldmethod=syntax | set foldmethod=manual
augroup END

" }}}

" Current project dir {{{
function! s:current_project_dir()
	let project_marker_dirs = ['lib', 'autoload', 'plugins']
	let project_replace_pattern = '/\('.join(project_marker_dirs,'\|').'\)\(/.\{-}\)\?$'
	let project_pattern = '.*'.project_replace_pattern
	if exists('b:rails_root')
		return b:rails_root
	elseif expand('%:p:h') =~ project_pattern && expand('%:p:h') !~ '/usr/.*'
		return substitute(expand('%:p:h'), project_replace_pattern, '', '')
	else
		return expand('%:p:h')
	endif
endfunction

" e-in-current-project
command! -complete=customlist,Vimrc_complete_current_project_files -nargs=1 Pe :exec ':e '.<SID>current_project_dir().'/'."<args>"
function! Vimrc_complete_current_project_files(ArgLead, CmdLine, CursorPos)
	let prefix = s:current_project_dir() . '/'
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
endfunction
" }}}

" Rename file {{{
" http://vim-users.jp/2009/05/hack17/
command! -nargs=1 -complete=file Rename f <args>|call delete(expand('#'))|w
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
let &statusline =
			\  ''
			\. '%<'
			\. '%F'
			\. '%= '
			\. '%m'
			\. '%{&filetype}'
			\. '%{",".(&fenc!=""?&fenc:&enc).",".&ff.","}'
			\. '[%{GetB()}]'
			\. '(%3l,%3c)'
function! GetB()
  let c = matchstr(getline('.'), '.', col('.') - 1)
  let c = iconv(c, &enc, &fenc)
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

" しばらく放置/よそから復帰したときのフック {{{
function! s:hello_again_enter()
	setlocal cursorline
	" redraw
	" let status_line_width=winwidth(0)
	" echo printf('%'.status_line_width.'.'.status_line_width.'s',<SID>fold_navi())
endfunction
function! s:hello_again_leave()
	setlocal nocursorline
endfunction
augroup vimrc-hello-again
  autocmd!
  autocmd CursorMoved * call s:hello_again_hook('CursorMoved')
  autocmd CursorHold * call s:hello_again_hook('CursorHold')
  autocmd WinEnter * call s:hello_again_hook('WinEnter')
  autocmd WinLeave * call s:hello_again_hook('WinLeave')
  autocmd FocusGained * call s:hello_again_hook('WinEnter')
  autocmd FocusLost * call s:hello_again_hook('WinLeave')

  let s:hello_again_state=0
  let s:hello_again_last_fired_by_cursorhold = reltime()
  function! s:hello_again_hook(event)
    if a:event ==# 'CursorHold'
      if str2float(reltimestr(reltime(s:hello_again_last_fired_by_cursorhold))) < 2.0
		  return
	  endif
    endif
    let s:hello_again_last_fired_by_cursorhold = reltime()
    if a:event ==# 'WinEnter'
      call <SID>hello_again_enter()
      let s:hello_again_state = 2
    elseif a:event ==# 'WinLeave'
      call <SID>hello_again_leave()
    elseif a:event ==# 'CursorMoved'
      if s:hello_again_state
        if 1 < s:hello_again_state
          let s:hello_again_state = 1
        else
          call <SID>hello_again_leave()
          let s:hello_again_state = 0
        endif
      endif
    elseif a:event ==# 'CursorHold'
      call <SID>hello_again_enter()
      let s:hello_again_state = 1
    endif
  endfunction
augroup END
" }}}

" 保存時にディレクトリ作成 {{{
" http://vim-users.jp/2011/02/hack202/
augroup vimrc-auto-mkdir  " {{{
  autocmd!
  autocmd BufWritePre * call s:auto_mkdir(expand('<afile>:p:h'), v:cmdbang)
  function! s:auto_mkdir(dir, force)  " {{{
    if !isdirectory(a:dir) && (a:force ||
    \    input(printf('"%s" does not exist. Create? [y/N]', a:dir)) =~? '^y\%[es]$')
      call mkdir(iconv(a:dir, &encoding, &termencoding), 'p')
    endif
  endfunction  " }}}
augroup END  " }}}
" }}}
