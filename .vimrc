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

set tags+=./tags,./../tags,./../../tags,./../../../tags,./../../../../tags,./../../../../../tags,./../../../../../../tags

set scrolloff=0

set notimeout
set ttimeout
set ttimeoutlen=100

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

" plugins/filetypes {{{
NeoBundle 'Shougo/vimproc'

" Unite {{{
NeoBundle 'Shougo/unite.vim' "{{{
" Settings {{{
let g:unite_enable_start_insert = 1
let g:unite_update_time = 100

let g:unite_source_file_rec_ignore_pattern =
      \'\%(^\|/\)\.$\|\~$\|\.\%(o\|exe\|dll\|bak\|sw[po]\|class\)$'.
      \'\|\%(^\|/\)\.\%(hg\|git\|bzr\|svn\)\%($\|/\)'.
	  \'\|\.\%(\gif\|jpg\|png\|swf\)$'

call unite#filters#sorter_default#use(['sorter_smart'])
" }}}
" unite-file_mru {{{
let g:unite_source_file_mru_limit=1000
call unite#custom_source('file_mru', 'ignore_pattern', '\.rsync_cache\|svn-commit\.tmp\|svn-cherry-pick\/\(message\|target\)')
" }}}
"}}}
NeoBundle 'tsukkee/unite-tag' "{{{
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

nnoremap <C-Q>t :<C-u>Unite tag<CR>
" C-] to unite tag jump
augroup vimrc-tagjump-unite
	autocmd!
	autocmd BufEnter *
				\   if empty(&buftype)
				\|      nnoremap <buffer> <C-]> m':<C-u>UniteWithCursorWord -immediately outline tag<CR>
				\|  endif
augroup END
"}}}
NeoBundle 'Shougo/unite-outline'
NeoBundle 'sgur/unite-qf' "{{{
nnoremap <C-Q>f :<C-u>Unite qf -no-start-insert -auto-preview<CR>
"}}}
NeoBundle 'basyura/unite-rails' "{{{
  nnoremap <C-Q>r <ESC>
  nnoremap <C-Q>rm :<C-u>Unite rails/model<CR>
  nnoremap <C-Q>rc :<C-u>Unite rails/controller<CR>
  nnoremap <C-Q>rv :<C-u>Unite rails/view<CR>
  nnoremap <C-Q>rf :<C-u>Unite rails/config<CR>
  nnoremap <C-Q>rd :<C-u>Unite rails/db -input=seeds/\ <CR>
  nnoremap <C-Q>ri :<C-u>Unite rails/db -input=migrate/\ <CR>
  nnoremap <C-Q>rl :<C-u>Unite rails/lib<CR>
"}}}
NeoBundle 'osyo-manga/unite-fold' " {{{
	call unite#custom_filters('fold',['matcher_default', 'sorter_nothing', 'converter_default'])
	function! g:vimrc_unite_fold_foldtext(bufnr, val)
		if has_key(a:val, 'word')
			return a:val.word
		else
			let marker_label = matchstr(a:val.line, "\"\\s*\\zs.*\\ze".split(&foldmarker, ",")[0])
			if !empty(marker_label)
				return marker_label
			else
				return matchstr(a:val.line, "^\\zs.*\\ze\\s*\"\\s*.*".split(&foldmarker, ",")[0])
			endif
		end
	endfunction
	let g:Unite_fold_foldtext=function('g:vimrc_unite_fold_foldtext')

	nnoremap <C-Q>d :<C-u>Unite fold<CR>
"}}}
NeoBundle 'ujihisa/unite-colorscheme' " {{{
command! Colors Unite colorscheme -auto-preview
nnoremap <C-Q>c :<C-u>Colors<CR>
" }}}
NeoBundle 'ujihisa/unite-font'

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
nnoremap <C-Q>o m':<C-u>Unite outline<CR>
nnoremap <C-Q>p :<C-u>exec 'Unite file_rec:'.<SID>current_project_dir()<CR>
nnoremap <C-Q>l :<C-u>Unite line<CR>
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
" unite-massive-candidates {{{
let s:unite_source = {'name': 'massive-candidates'}
function! s:unite_source.gather_candidates(args, context)
  return map(repeat(['a', 'b', 'c'], 10000), '{
        \ "word": v:val,
        \ "source": "massive-candidates",
        \ "kind": "word",
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
	let do_nothing = 0
				\ || len(a:context.input) == 0
				\ || len(a:candidates) > 100
				\ || a:context.source.name == 'file_mru'
	if do_nothing
		return a:candidates
	endif

	let keywords = split(a:context.input, '\s\+')
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
if has('gui')
	let g:neocomplcache_enable_at_startup = 1
endif
" }}}
NeoBundle 'Shougo/neocomplcache-rsense'

NeoBundle 'closetag.vim' " {{{
   autocmd Filetype html,xml,xsl,eruby runtime plugin/closetag.vim
" }}}
NeoBundle 'Align' " {{{
let g:Align_xstrlen='strwidth'
map (trashbox-leader-rwp) <Plug>RestoreWinPosn
map (trashbox-leader-swp) <Plug>SaveWinPosn
let g:loaded_AlignMapsPlugin = 1
" }}}
NeoBundle 'todesking/YankRing.vim' " {{{
let g:yankring_max_element_length = 0
let g:yankring_max_history_element_length = 1000 * 10
" }}}
NeoBundle 'AndrewRadev/linediff.vim'
NeoBundle 'tsaleh/vim-matchit'
NeoBundle 'tpope/vim-surround'
NeoBundle 'todesking/vim-easymotion' "{{{
	nmap <C-J> <Leader><Leader>w
	nmap <C-K> <Leader><Leader>b
	vmap <C-J> <Leader><Leader>w
	vmap <C-K> <Leader><Leader>b
	let g:EasyMotion_keys = 'siogkmjferndlhyuxvtcbwa'
"}}}
NeoBundle 'kana/vim-textobj-user'

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

" Colors {{{
NeoBundle 'altercation/vim-colors-solarized'
NeoBundle 'pyte'
NeoBundle 'newspaper.vim'
NeoBundle 'Zenburn'
NeoBundle 'ciaranm/inkpot'
" }}}

" ruby {{{
NeoBundle 'tpope/vim-rvm' "{{{
"}}}
NeoBundle 'vim-ruby/vim-ruby'
NeoBundle 'tpope/vim-rails'
NeoBundle 'rhysd/vim-textobj-ruby'
" }}}

NeoBundle 'roalddevries/yaml.vim' "{{{
	function! Vimrc_autocmd_yaml_vim()
		if &foldmethod != 'syntax'
			runtime yaml.vim
			set foldmethod=syntax
		endif
	endfunction
	augroup vimrc-yaml-vim
		autocmd!
		autocmd FileType yaml nmap <buffer><leader>f :<C-U>call Vimrc_autocmd_yaml_vim()<CR>
	augroup END
"}}}

" vimscript {{{
augroup vimrc-vimscript
	autocmd!
	autocmd FileType vim set textwidth=0
augroup END
" }}}

NeoBundle 'motemen/hatena-vim'

" Git {{{
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'int3/vim-extradite'
NeoBundle 'Kocha/vim-unite-tig'
NeoBundle 'airblade/vim-gitgutter'
" }}}

NeoBundle 'thinca/vim-ref' "{{{
	let g:ref_refe_cmd="~/local/bin/refe"
	command! -nargs=1 Man :Ref man <args>
	command! -nargs=1 Refe :Ref refe <args>
	augroup vimrc-filetype-ref
		autocmd!
		autocmd FileType ref setlocal bufhidden=hide
	augroup END
"}}}
NeoBundle 'grep.vim' "{{{
	let Grep_OpenQuickfixWindow = 0
"}}}
NeoBundle 'mileszs/ack.vim' "{{{
let g:ackprg = 'ag --nogroup --nocolor --column'
let g:ack_qhandler = ""
"}}}
NeoBundle 'taka84u9/vim-ref-ri', {'rev': 'master'} "{{{
	command! -nargs=1 Ri :Ref ri <args>
"}}}

" RSense.vim {{{
let g:rsenseHome = expand('~/local/rsense/')
if exists('*RSenseInstalled') && RSenseInstalled()
	let g:rsenseUseOmniFunc = 1
endif
"}}}

" }}}

" Ruby {{{
if has("ruby")
  silent! ruby nil
endif
augroup vimrc-filetype-ruby
	autocmd!
	autocmd FileType ruby inoremap <buffer> <c-]> end<ESC>
	autocmd FileType ruby set foldmethod=manual
augroup END

" To avoid ultra-heavy movement when Ruby insert mode {{{

" Don't screw up folds when inserting text that might affect them, until
" leaving insert mode. Foldmethod is local to the window. Protect against
" screwing up folding when switching between windows.
autocmd InsertEnter * if !exists('w:last_fdm') | let w:last_fdm=&foldmethod | setlocal foldmethod=manual | endif
autocmd InsertLeave,WinLeave * if exists('w:last_fdm') | let &l:foldmethod=w:last_fdm | unlet w:last_fdm | endif

" }}}

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
nnoremap <CR> :call append(line('.'),'')<CR>

nnoremap <silent>,n :tabnew<CR>
nnoremap <silent>,h :tabprevious<CR>
nnoremap <silent>,l :tabnext<CR>
nnoremap <silent>,H :tabmove -1<CR>
nnoremap <silent>,L :tabmove +1<CR>

inoremap <C-E> <End>
inoremap <C-A> <Home>
inoremap <C-K> <C-O>D

cnoremap <C-E> <End>
cnoremap <C-A> <Home>

" not works well but I leave it
nnoremap <silent>,bd :<C-U>enew<CR>:bwipeout #<CR>

inoremap <silent><C-L> <C-X><C-L>

nnoremap j gj
nnoremap k gk

set visualbell
set t_vb=

function! s:register_jump_key(key)
	exec 'nnoremap' '<silent>'.a:key
				\ a:key.':call <SID>hello_again_hook(''CursorHold'')<CR>'
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
nnoremap <leader>f :set foldmethod=syntax<CR>:set foldmethod=manual<CR>
nnoremap <silent>_ :let &hlsearch=!&hlsearch<CR>:set hlsearch?<CR>

autocmd FileType * setlocal formatoptions-=ro
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

" Current project dir {{{
function! s:current_project_dir()
	let project_marker_dirs = ['lib', 'ext', 'test', 'spec', 'bin', 'autoload', 'plugins', 'plugin']
	let project_replace_pattern = '/\('.join(project_marker_dirs,'\|').'\)\(/.\{-}\)\?$'
	let project_pattern = '.*'.project_replace_pattern
    let dir = expand('%:p:h')
	if exists('b:rails_root')
		return b:rails_root
	elseif dir =~ project_pattern && dir !~ '/usr/.*'
		return substitute(dir, project_replace_pattern, '', '')
    elseif dir =~ '/projects/'
        return substitute(dir, '\v(.*\/projects\/[-_a-zA-Z0-9])\/.*', '\1', '')
	else
		return ''
	endif
endfunction

" e-in-current-project
command! -complete=customlist,Vimrc_complete_current_project_files -nargs=1 Pe :exec ':e '.<SID>current_project_dir().'/'."<args>"
function! Vimrc_complete_current_project_files(ArgLead, CmdLine, CursorPos)
	let prefix = s:current_project_dir() . '/'
	if prefix == '/'
		return []
	endif
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

" Ce command(e based on Currend dir) {{{
command! -complete=customlist,Vimrc_complete_current_dir -nargs=1 Ce :exec ':e '.expand('%:p:h').'/'."<args>"
function! Vimrc_complete_current_dir(ArgLead, CmdLine, CursorPos)
	let prefix = expand('%:p:h') . '/'
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

" Syntax trace {{{
" from http://vim.wikia.com/wiki/Identify_the_syntax_highlighting_group_used_at_the_cursor
command! SyntaxTrace echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"
"}}}

" Vim のユーザ定義コマンドを自動的にシンタックスハイライトする {{{
" http://emanon001.github.com/blog/2012/03/18/syntax-highlighting-of-user-defined-commands-in-vim/
augroup syntax-highlight-extension
  autocmd!
  autocmd Syntax vim call s:set_syntax_of_user_defined_commands()
augroup END

function! s:set_syntax_of_user_defined_commands()
  redir => _
  silent! command
  redir END

  let command_names = map(split(_, '\n')[1:],
        \                 'matchstr(v:val, ''^[!"b]*\s\+\zs\u\w*\ze'')')
  if empty(command_names) | return | endif

  execute 'syntax keyword vimCommand contained' join(command_names)
endfunction
" }}}

" Status line {{{
function! Vimrc_current_project()
	let path = substitute(expand('%:p'), '^'.expand('~'), '~', '')
	if path =~ '/projects/[^/]\+/'
		let project_tag = '['.substitute(path, '.*/projects/\([^/]\+\)/.*', '\1', '').'] '
		let project_path = substitute(path, '^.*/projects/[^/]\+/', '', '')
		return project_tag . project_path
	else
		return path
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

" Title string {{{
let &titlestring='[TODO] %{g:todo_current_doing}'
"}}}

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

" vimrc's SID {{{
function! Vimrc_sid()
	return s:vimrc_sid()
endfunction
function! s:vimrc_sid()
	return matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze_vimrc_sid$')
endfunction
" }}}

" todo.vim {{{
augroup vimrc-todo
	autocmd BufNewFile,BufRead TODO set filetype=todo
	autocmd FileType TODO call s:todo_syntax()
	autocmd FileType TODO call s:todo_keymap()
augroup END

let g:todo_current_doing='(none)'

function! s:todo_keymap()
	nnoremap <buffer> <Plug>(todo-mark-done)    :<C-U>call <SID>todo_done()<CR>
	nnoremap <buffer> <Plug>(todo-mark-discard) :<C-U>call <SID>todo_discard()<CR>
	nnoremap <buffer> <Plug>(todo-mark-clear)   :<C-U>call <SID>todo_clear_mark()<CR>
	nnoremap <buffer> <Plug>(todo-reorder)      :<C-U>call <SID>todo_reorder_buffer()<CR>
	nnoremap <buffer> <Plug>(todo-move-up)      :<C-U>call <SID>todo_move_up()<CR>
	nnoremap <buffer> <Plug>(todo-move-down)    :<C-U>call <SID>todo_move_down()<CR>

	nmap <buffer> <leader>d       <Plug>(todo-mark-done)
	nmap <buffer> <leader>x       <Plug>(todo-mark-discard)
	nmap <buffer> <leader>r       <Plug>(todo-reorder)
	nmap <buffer> <leader><Space> <Plug>(todo-mark-clear)
	nmap <buffer> <leader>k       <Plug>(todo-move-up)
	nmap <buffer> <leader>j       <Plug>(todo-move-down)
endfunction

function! s:todo_move_mode()
	nnoremap j <Plug>(todo-move-up)
	nnoremap k <Plug>(todo-move-down)
	nnoremap <ESC> <Plug>(todo-exit-move-mode)
endfunction

function! s:todo_exit_move_mode()
	augroup
endfunction

function! s:todo_syntax()
	highlight TodoDone guifg=darkgray
	highlight TodoDisabled guifg=gray
	highlight TodoNormal guifg=lightgreen
	highlight link TodoDoing Todo
	syntax match TodoDone  /^\s*\zs\* .*\ze/
	syntax match TodoDoing /^\s*\zs> .*\ze/
	syntax match TodoDisabled /^\s*\zsx .*\ze/
	syntax match TodoNormal /^\(\s*. \)\@!\s*\zs.*\ze/
endfunction

function! s:todo_discard()
	call s:todo_set_mark_buffer('.', 'x')
endfunction

function! s:todo_done()
	call s:todo_set_mark_buffer('.', '*')
endfunction

function! s:todo_clear_mark()
	call s:todo_set_mark_buffer('.', '')
endfunction

function! s:todo_set_mark_buffer(lnum, mark)
	let line = getline(a:lnum)
	let marked_line = s:todo_set_mark(line, a:mark)
	if line == marked_line
		return
	endif
	call setline(a:lnum, marked_line)
endfunction

function! s:todo_set_mark(line, mark)
	let prefix = (a:mark == '') ? '' : a:mark . ' '
	return substitute(s:strip_mark(a:line), '^\v(\s*)(.*)', '\1'.prefix.'\2', '')
endfunction

function! s:strip_mark(line)
	return substitute(a:line, '\v^\s*\zs[*>x] \ze.*', '', '')
endfunction

function! s:get_mark(line)
	let mark = matchstr(a:line, '\v^\s*\zs[*>x ]\ze .*')
	if mark == ''
		let mark = ' '
	endif
	return mark
endfunction

function! s:mark_priority(mark)
	let definition = {'>':0, ' ':1, '*': 3, 'x':3}
	return definition[a:mark]
endfunction

function! s:stable_sort(list, func)
	let i = 0
	while i < len(a:list)
		let j = len(a:list) - 1
		while j > i
			if a:func(a:list[j - 1], a:list[j]) > 0
					let tmp = a:list[j]
					let a:list[j] = a:list[j - 1]
					let a:list[j - 1] = tmp
			endif
			let j -= 1
		endwhile
		let i += 1
	endwhile
	return a:list
endfunction

function! s:todo_move_up() abort
	let todo = s:create_todo_structure_from_current_buffer()
	let todo_orig = deepcopy(todo)
	let lnum = line('.')
	let lnum =  s:todo_move(todo, lnum, -1)
	if todo != todo_orig
		call s:todo_redraw(todo)
		call cursor(lnum, 0)
	endif
endfunction

function! s:todo_move_down() abort
	let todo = s:create_todo_structure_from_current_buffer()
	let todo_orig = deepcopy(todo)
	let lnum = line('.')
	let lnum = s:todo_move(todo, lnum, 1)
	if todo != todo_orig
		call s:todo_redraw(todo)
		call cursor(lnum, 0)
	endif
endfunction

function! s:todo_move(todo, lnum, distance) abort
	let parent = s:todo_parent_of(a:todo, a:lnum)
	let i = 0
	while i < len(parent.children)
		if i + a:distance >= 0 && parent.children[i].lnum == a:lnum
			let tmp = parent.children[i]
			let parent.children[i] = parent.children[i + a:distance]
			let parent.children[i + a:distance] = tmp
			call s:todo_renumber(parent)
			return tmp.lnum
		endif
		let i += 1
	endwhile
endfunction

" return: next lnum
function! s:todo_renumber(todo) abort
	let lnum = a:todo.lnum + 1
	for c in a:todo.children
		let c.lnum = lnum
		let lnum = s:todo_renumber(c)
	endfor
	return lnum
endfunction

function! s:todo_line_count(todo) abort
	let count = 1
	for c in a:todo.children
		let count += s:todo_line_count(c)
	endfor
	return count
endfunction

function! s:todo_parent_of(todo, lnum) abort
	for c in a:todo.children
		if c.lnum == a:lnum
			return a:todo
		endif
		let found = s:todo_parent_of(c, a:lnum)
		if found != {}
			return found
		endif
	endfor
	return {}
endfunction

function! s:update_todo_doing_status(todo)
	call s:todo_clear_doing_mark_all(a:todo)
	call s:sort_todo_structure(a:todo, function('s:todo_ordering'))
	if empty(a:todo.children)
		return a:todo
	endif
	let cur = a:todo.children[0]
	while 1
		let mark = s:get_mark(cur.line)
		if mark == ' '
			let cur.line = s:todo_set_mark(cur.line, '>')
		endif
		if empty(cur.children)
			break
		endif
		let cur = cur.children[0]
	endwhile
	return a:todo
endfunction

function! s:todo_current_doing(todo) abort
	let current_doing = ''
	if a:todo.root || s:get_mark(a:todo.line) == '>'
		let current_doing = a:todo.root ? '' : substitute(s:todo_set_mark(a:todo.line, ''), '^\s\+', '', '')
		for c in a:todo.children
			let child_doing = s:todo_current_doing(c)
			if child_doing != ''
				let current_doing = current_doing . ' > ' . child_doing
			endif
		endfor
	end
	return substitute(current_doing, '^ > ', '', '')
endfunction

function! s:todo_reorder_buffer() abort
	let todo = s:create_todo_structure_from_current_buffer()
	let sorted_todo = s:update_todo_doing_status(deepcopy(todo))
	let g:todo_current_doing = s:todo_current_doing(sorted_todo)
	if todo == sorted_todo
		return
	endif
	call s:todo_redraw(sorted_todo)
endfunction

function! s:todo_redraw(todo)
	let lazyredraw = &lazyredraw
	set lazyredraw
	normal! ggdG
	call s:todo_emit(a:todo)
	normal! gg
	let &lazyredraw=lazyredraw
endfunction

function! s:todo_emit(todo) abort
	if !a:todo.root
		call append(line('$') - 1, a:todo.line)
	endif
	for c in a:todo.children
		call s:todo_emit(c)
	endfor
endfunction

function! s:todo_clear_doing_mark_all(todo)
	if s:get_mark(a:todo.line) == '>'
		let a:todo.line = s:todo_set_mark(a:todo.line, '')
	endif
	for c in a:todo.children
		call s:todo_clear_doing_mark_all(c)
	endfor
endfunction

function! s:sort_todo_structure(todo, func) abort
	call s:stable_sort(a:todo.children, a:func)
	for c in a:todo.children
		call s:sort_todo_structure(c, a:func)
	endfor
	return a:todo
endfunction

function! s:todo_ordering(a,b)
	return s:mark_priority(s:get_mark(a:a.line)) - s:mark_priority(s:get_mark(a:b.line))
endfunction

let g:todo_debug = []

function! s:print_todo_structure(todo, indent_level)
	echo repeat(' ', a:indent_level * 2) . matchstr(a:todo.line, '\v^\s*\zs.*\ze$')
	for c in a:todo.children
		call s:print_todo_structure(c, a:indent_level + 1)
	endfor
endfunction

function! s:create_todo_structure_from_current_buffer() abort
	let structure = []
	let stack = [s:new_todo_structure(0, 'ROOT')]
	let stack[-1].root = 1
	let lnum = 1
	let prev_indent_level = -1

	while lnum <= line('$')
		let line = getline(lnum)

		if line == ''
			let lnum += 1
			continue
		endif

		let cur = s:new_todo_structure(lnum, line)
		let indent_level = indent(lnum) / &shiftwidth
		if prev_indent_level == indent_level
			let s=remove(stack, -1)
			call add(stack[-1].children, cur)
			call add(stack, cur)
		elseif prev_indent_level < indent_level
			call add(stack[-1].children, cur)
			call add(stack, cur)
		else " prev_indent_level > indent_level
			let pop_count = prev_indent_level - indent_level
			let removed = remove(stack, -pop_count - 1, -1)
			call add(stack[-1].children, cur)
			call add(stack, cur)
		end

		let prev_indent_level = indent_level
		let lnum += 1
	endwhile

	return stack[0]
endfunction

function! s:new_todo_structure(lnum, line) abort
	return {'lnum': a:lnum, 'root': 0, 'line': a:line, 'children': []}
endfunction
"}}}
