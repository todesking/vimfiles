" vim:foldmethod=marker
let $RUBY_DLL=$HOME.'/.rbenv/versions/2.1.1/lib/libruby.dylib'

" なんか謎の再現不能エラーを抑制しているかんじがするやつ(よくわからない)
let V = {}

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
filetype on
filetype plugin indent on
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

" plugins/filetypes {{{

" Library {{{
NeoBundle 'Shougo/vimproc'
if has('clientserver')
	NeoBundle 'pydave/AsyncCommand'
endif
NeoBundle 'todesking/current_project.vim'
NeoBundle 'mattn/webapi-vim'
" }}}

" Navigation/Highlight {{{

" matchparen {{{
let g:matchparen_timeout = 10
let g:matchparen_insert_timeout = 10
" }}}

NeoBundle 'Lokaltog/vim-easymotion' "{{{
	nmap <silent><C-J> <Plug>(easymotion-w)
	nmap <silent><C-K> <Plug>(easymotion-b)
	vmap <silent><C-J> <Plug>(easymotion-w)
	vmap <silent><C-K> <Plug>(easymotion-b)
	let g:EasyMotion_keys = 'siogkmjferndlhyuxvtcbwa'
" }}}

NeoBundle 'a.vim'

NeoBundle 'nathanaelkane/vim-indent-guides' " {{{
	if has('gui_running')
		autocmd! indent_guides BufEnter *
		augroup vimrc-indentguide
			autocmd!
			autocmd BufWinEnter,BufNew * highlight IndentGuidesOdd guifg=NONE guibg=NONE
		augroup END
		let g:indent_guides_enable_on_vim_startup=1
		let g:indent_guides_start_level=1
		let g:indent_guides_guide_size=1
	endif
" }}}

NeoBundle "osyo-manga/vim-brightest" " {{{
" }}}
" }}}

" Textobj {{{

NeoBundle 'tpope/vim-surround'

NeoBundle 'kana/vim-textobj-user' " {{{
	call textobj#user#plugin('lastmofified', {
	\   'lastmodified': {
	\     'select-a': 'al',
	\     '*select-a-function*': 'g:Vimrc_select_a_last_modified',
	\   },
	\ })
	function! g:Vimrc_select_a_last_modified() abort
		return ['v', getpos("'["), getpos("']")]
	endfunction
" }}}

" }}}

" Edit support {{{
NeoBundle 'todesking/YankRing.vim' " {{{
let g:yankring_max_element_length = 0
let g:yankring_max_history_element_length = 1000 * 10
" }}}
NeoBundle 'Align' " {{{
	let g:Align_xstrlen='strwidth'
	map (trashbox-leader-rwp) <Plug>RestoreWinPosn
	map (trashbox-leader-swp) <Plug>SaveWinPosn
	let g:loaded_AlignMapsPlugin = 1
" }}}
NeoBundle "godlygeek/tabular" " {{{
" }}}
NeoBundle 'closetag.vim' " {{{
	 autocmd Filetype html,xml,xsl,eruby runtime plugin/closetag.vim
" }}}
NeoBundle 'Shougo/neosnippet' " {{{
	let g:neosnippet#disable_runtime_snippets = {
	\ '_': 1,
	\ }
	imap <C-k>     <Plug>(neosnippet_expand_or_jump)
	smap <C-k>     <Plug>(neosnippet_expand_or_jump)
	xmap <C-k>     <Plug>(neosnippet_expand_target)
	let g:neosnippet#snippets_directory='~/.vim/snippets'
" }}}
NeoBundle "tpope/vim-repeat"
NeoBundle "mbbill/undotree"
" }}}

" Utilities {{{
NeoBundle 'AndrewRadev/linediff.vim'
NeoBundle 'osyo-manga/vim-over'
NeoBundle 'taku-o/vim-zoom'
NeoBundle 'tyru/capture.vim'
NeoBundle 'ciaranm/detectindent'
NeoBundle 'osyo-manga/vim-automatic' "{{{
" }}}
" }}}

" Games {{{
NeoBundle 'mattn/habatobi-vim'
NeoBundle 'thinca/vim-threes'
NeoBundle 'katono/rogue.vim'
" }}}

" Unite {{{
NeoBundle 'Shougo/unite.vim' "{{{
" Settings {{{
let g:unite_enable_start_insert = 1
let g:unite_update_time = 100
let g:unite_cursor_line_highlight='CursorLine'
let g:unite_redraw_hold_candidates=100000

let g:unite_source_rec_max_cache_files = 50000

call unite#filters#sorter_default#use(['sorter_smart'])

call unite#custom#profile('default', 'context', {'custom_rec_ignore_directory_pattern': 
			\'\%(/\.[^/]\+$\)\|/\%(\.hg\|\.git\|\.bzr\|\.svn\|target\|classes\|build\)/'})
" }}}
" unite-file_mru {{{
let g:unite_source_file_mru_limit=1000
let g:unite_source_file_mru_time_format=""
let g:unite_source_mru_do_validate=0
" }}}
" summarize-path {{{
let s:summarize_path = {
			\ 'name': 'converter_summarize_path',
			\}
let s:home_path = expand('~')
function! Vimrc_summarize_path(path)
	let path = simplify(a:path)
	let path = substitute(path, s:home_path, '~', '')
	if path =~ '\v\.rbenv|gems|\.vim'
		let path = substitute(path, '\v\~\/.rbenv\/versions\/([^/]+)\/', '[rbenv:\1] ', '')
		let path = substitute(path, '\v[\/ ]lib\/ruby\/gems\/([^/]+)\/gems\/([^/]+)\/', '[gem:\2] ', '')
		let path = substitute(path, '\v\~\/\.vim\/bundle\/([^/]+)\/', '[.vim/\1] ', '')
	endif
	if path[0] != '['
		let info = Vimrc_file_info(a:path)
		if !empty(info.name)
			let path = '['.info['name'].'] '.info['file_path']
		endif
	endif
	return path
endfunction
function! s:summarize_path.filter(candidates, context)
	let candidates = copy(a:candidates)
	for cand in candidates
		let path = Vimrc_summarize_path(cand.word)
		let cand.word = path
		if !empty(cand.word)
			let cand.abbr = path
		endif
	endfor
	return candidates
endfunction
call unite#define_filter(s:summarize_path)
unlet s:summarize_path
" }}}

" hide_unimportant_path {{{
let s:filter={'name': 'converter_hide_unimportant_path'}
function! s:filter.filter(candidates, context)
	let header_pat = '^\[[^\]]\+\] '
	let prev = []
	for cand in a:candidates
		let path = cand.abbr
		if empty(path) | let path = cand.word | endif

		let header = matchstr(path, header_pat)
		if header == -1 | let header = '' | endif
		if !empty(header) | let path = substitute(path, header_pat, '', '') | endif
		let components = [header] + split(path, '/', 1)
		let i = 0
		let l = min([len(components), len(prev)])
		while i < l
			if components[i] != prev[i] | break | endif
			let i = i + 1
		endwhile

		if i > 1
			let cand.abbr = '!!!{'.components[0].join(components[1: i-1], '/').'/}!!!'.join(components[i :], '/')
		elseif i == 1
			let cand.abbr = '!!!{'.components[0].'}!!!'.join(components[i :], '/')
		endif
		let prev = components
	endfor
	return a:candidates
endfunction
call unite#define_filter(s:filter)
unlet s:filter
" }}}

" Vimrc_unite_syntax {{{
function! Vimrc_unite_syntax()
	syntax match unite__word_tag /\[[^]]\+\]/ contained containedin=uniteSource__FileMru,uniteSource__FileRec
	highlight link unite__word_tag Identifier
	syntax region UniteUnimportant keepend excludenl matchgroup=UniteUnimportantMarker start=/!!!{/ end=/}!!!/ concealends containedin=uniteSource__FileMru,uniteSource__FileRec,uniteSource__Buffer
	highlight link UniteUnimportant Comment
	setlocal concealcursor+=i
endfunction

augroup vimrc-untie-syntax
	autocmd!
	autocmd FileType unite :call Vimrc_unite_syntax()
augroup END
" }}}

" converter_remove_trash_files {{{
let s:filter = {
			\ 'name': 'converter_remove_trash_files',
			\}
function s:filter.filter(candidates, context)
	return filter(a:candidates, 'v:val.word !~ ''\.cache$\|/resolution-cache/\|\.DS_Store\|\.jar$\|/target/''')
endfunction
call unite#define_filter(s:filter)
unlet s:filter
" }}}

for source in ['file_mru', 'file_rec', 'buffer']
	call unite#custom#source(source, 'converters', ['converter_remove_trash_files', 'converter_summarize_path', 'converter_hide_unimportant_path'])
endfor
" }}}
NeoBundle 'tsukkee/unite-tag' "{{{
let g:unite_source_tag_max_name_length = 50
let g:unite_source_tag_max_fname_length = 999
let g:unite_source_tag_strict_truncate_string = 1

nnoremap <C-Q>t :<C-u>Unite tag -immediately<CR>
" C-] to unite tag jump
augroup vimrc-tagjump-unite
	autocmd!
	autocmd BufEnter *
				\   if empty(&buftype)
				\|      nnoremap <buffer> <C-]> m':<C-u>UniteWithCursorWord -immediately outline tag<CR>
				\|  endif
augroup END
let s:c = {'name': 'converter_tag'}
function! s:c.filter(candidates, context) abort
	for c in a:candidates
		let spath = Vimrc_summarize_path(c.action__path)
		let c.abbr = printf('%-25s @%-100s', c.action__tagname, spath)
		let c.word = c.action__tagname . ' ' . spath
	endfor
	return a:candidates
endfunction
call unite#define_filter(s:c)
unlet s:c
call unite#custom#source('tag','converters', ['converter_tag'])
" }}}
NeoBundle 'Shougo/unite-outline' "{{{
let g:unite_source_outline_scala_show_all_declarations = 1
" }}}
NeoBundle 'sgur/unite-qf' "{{{
nnoremap <C-Q>f :<C-u>Unite qf -no-start-insert -auto-preview -no-split -winheight=30<CR>
call unite#custom#profile('source/qf', 'context', {'max_multi_lines': 20})
" }}}
NeoBundle 'basyura/unite-rails' "{{{
	nnoremap <C-Q>r <ESC>
	nnoremap <C-Q>j  :<C-u>Unite jump<CR>
	nnoremap <C-Q>ra :<C-u>Unite rails/asset<CR>
	nnoremap <C-Q>rm :<C-u>Unite rails/model<CR>
	nnoremap <C-Q>rc :<C-u>Unite rails/controller<CR>
	nnoremap <C-Q>rv :<C-u>Unite rails/view<CR>
	nnoremap <C-Q>rf :<C-u>Unite rails/config<CR>
	nnoremap <C-Q>rd :<C-u>Unite rails/db -input=seeds/\ <CR>
	nnoremap <C-Q>ri :<C-u>Unite rails/db -input=migrate/\ <CR>
	nnoremap <C-Q>rl :<C-u>Unite rails/lib<CR>
	nnoremap <C-Q>rh :<C-u>Unite rails/helper<CR>
" }}}
NeoBundle 'osyo-manga/unite-fold' " {{{
	call unite#custom_filters('fold',['matcher_default', 'sorter_nothing', 'converter_default'])
	function! g:Vimrc_unite_fold_foldtext(bufnr, val)
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
	let g:Unite_fold_foldtext=function('g:Vimrc_unite_fold_foldtext')

	nnoremap <C-Q>d :<C-u>Unite fold<CR>
" }}}
NeoBundle 'ujihisa/unite-colorscheme' " {{{
command! Colors Unite colorscheme -auto-preview
nnoremap <C-Q>c :<C-u>Colors<CR>
" }}}
NeoBundle 'ujihisa/unite-font'
NeoBundle 'Shougo/neomru.vim' " {{{
	let g:neomru#do_validate = 1
" }}}
NeoBundle 'osyo-manga/unite-candidate_sorter' " {{{
augroup vimrc-unite-candidate-sorter
  autocmd!
  autocmd FileType unite nmap <silent><buffer> S <Plug>(unite-candidate_sort)
augroup END
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
nnoremap <C-Q>o m':<C-u>Unite outline<CR>
nnoremap <C-Q>P :<C-u>exec 'Unite file_rec:'.CurrentProjectInfo(expand('%')).main_path<CR>
nnoremap <C-Q>p :<C-u>exec 'Unite file_rec:'.CurrentProjectInfo(expand('%')).sub_path<CR>
nnoremap <C-Q>c :<C-u>exec 'Unite file_rec:'.expand('%:p:h').'/'<CR>
nnoremap <C-Q>l :<C-u>Unite line<CR>
nnoremap <C-Q>b :<C-u>Unite buffer<CR>
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
" Git sources(original: https://github.com/aereal/dotfiles/blob/master/.vim/vimrc ) {{{
function! s:git_read_path(cmd) abort " {{{
	let base = fugitive#extract_git_dir(expand('%')) . "/.."
	execute 'lcd ' . base
	let output = unite#util#system('git diff-files --name-only --diff-filter=U')
	lcd -
	return [base, split(output, "\n")]
endfunction " }}}
function! s:git_make_candidates(source_name, cmd) abort " {{{
	let [base, files] = s:git_read_path(a:cmd)
	return map(files, '{
				\ "word" : v:val,
				\ "source" : a:source_name,
				\ "kind" : "file",
				\ "action__path" : fnamemodify(base . "/" . v:val, ":p"),
				\ }')
endfunction " }}}
" unite-git-files-conflict {{{
let s:unite_git_files_conflict = {
			\   'name' : 'git/files/conflict',
			\ }
function! s:unite_git_files_conflict.gather_candidates(args, context)
	return s:git_make_candidates('git/files/conflict', 'git diff-files --name-only --diff-filter=U')
endfunction
call unite#define_source(s:unite_git_files_conflict)
" }}}
" unite-git-files-modified {{{
let s:unite_git_files_modified = {
			\   'name' : 'git/files/modified',
			\ }
function! s:unite_git_files_modified.gather_candidates(args, context)
	return s:git_make_candidates('git/files/modified', 'git ls-files --modified')
endfunction
call unite#define_source(s:unite_git_files_modified)
" }}}
" unite-git-files-others {{{
let s:unite_git_files_others = {
			\   'name' : 'git/files/others',
			\ }
function! s:unite_git_files_others.gather_candidates(args, context)
	return s:git_make_candidates('git/files/others', 'git ls-files --others --exclude-standard')
endfunction
call unite#define_source(s:unite_git_files_others)
" }}}
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
		let sort_val .= printf('%05d', len(text_without_keywords)).'_'
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

if(has('lua'))
NeoBundle 'Shougo/neocomplete.vim' "{{{
let g:neocomplete#enable_at_startup = 1
let g:neocomplete#force_overwrite_completefunc = 1
let g:neocomplete#enable_prefetch=1
let g:neocomplete#enable_smart_case = 1
let g:neocomplete#lock_iminsert = 1
augroup vimrc-neocomplete
	autocmd!
	autocmd CursorMovedI * call Vimrc_neocomplete_control()
augroup END
function! Vimrc_is_ime_enabled()
	if(!executable('is_ascii_capable'))
		return 0
	endif
	return str2nr(system("(is_ascii_capable && echo 0) || echo 1"))
endfunction
function! Vimrc_neocomplete_control()
	if(neocomplete#is_enabled())
		if(Vimrc_is_ime_enabled())
			let b:vimrc_neocomplete_enabled = 1
			NeoCompleteLock
		endif
	else
		if(get(b:, 'vimrc_neocomplete_enabled', 0) && !Vimrc_is_ime_enabled())
			NeoCompleteEnable
			let b:vimrc_neocomplete_enabled = 0
		endif
	endif
endfunction
" }}}
endif

NeoBundle 'itchyny/lightline.vim' "{{{
	function! Vimrc_summarize_project_path(path)
		let path = a:path
		" JVM subproject
		let path = substitute(path, '\v^(.+)\/(src\/%(%(main|test)\/%(java|scala))\/.+)', '[\1] \2', '')
		" JVM package
		let path = substitute(path,
					\ '\v<(src\/%(main|test)\/%(java|scala))\/(.+)/([^/]+)\.%(java|scala)',
					\ '\=submatch(1)."/".substitute(submatch(2),"/",".","g").".".submatch(3)', '')
		" JVM src dir
		let path = substitute(path, '\v<src\/(%(main|test)\/%(java|scala))\/(.+)', '\2(\1)', '')

		return path
	endfunction
	let g:lightline = {
				\ 'colorscheme': 'solarized_dark',
				\ 'active': {
				\   'left': [['project_component'], ['path_component']],
				\   'right': [['lineinfo'], ['fileformat', 'fileencoding', 'filetype'], ['build_status', 'charinfo'] ],
				\ },
				\ 'inactive': {
				\   'left': [['project_name', 'git_branch'], ['path_component']],
				\   'right': [['lineinfo'], ['fileformat', 'fileencoding', 'filetype'], ['charinfo'] ],
				\ },
				\ 'component': {
				\   'readonly': '%{&readonly?has("gui_running")?"":"ro":""}',
				\   'modified': '%{&modified?"+":""}',
				\   'project_name': '%{CurrentProjectInfo().name}',
				\   'project_path': '%{Vimrc_summarize_project_path(Vimrc_file_info(expand(''%''))["file_path"])}',
				\   'charinfo': '%{printf("%6s",GetB())}',
				\ },
				\ 'component_function': {
				\   'git_branch': 'Vimrc_statusline_git_branch',
				\   'build_status': 'Vimrc_build_status',
				\ },
				\ }
	let g:lightline['component']['path_component'] =
				\ g:lightline['component']['project_path'].
				\ g:lightline['component']['readonly'].
				\ g:lightline['component']['modified']
	let g:lightline['component']['project_component'] =
				\ g:lightline['component']['project_name'].
				\ '%{Vimrc_statusline_git_branch()}'
	if has('gui_running')
		let g:lightline['separator'] = { 'left': '', 'right': '' }
		let g:lightline['subseparator'] = { 'left': '', 'right': '' }
	endif
	function! Vimrc_statusline_git_branch() abort " {{{
		if exists('b:vimrc_statusline_git_branch') && str2float(reltimestr(reltime(b:vimrc_statusline_git_branch_updated_at))) < 3.0
			return b:vimrc_statusline_git_branch
		endif
		if exists("*fugitive#head")
			let _ = fugitive#head()
			let s = strlen(_) ? (has('gui_running')?'':'†')._ : ''
			let b:vimrc_statusline_git_branch = s
			let b:vimrc_statusline_git_branch_updated_at = reltime()
			return s
		else
			return ''
		endif
	endfunction " }}}
	let s:vimrc_build_status_version = 0
	function! Vimrc_build_status() abort " {{{
		if !exists('b:vimrc_build_status_last_updated')
			let b:vimrc_build_status_last_updated = reltime()
			let b:vimrc_build_status_last = ''
		endif
		if str2float(reltimestr(reltime(b:vimrc_build_status_last_updated))) < 0.5
			return b:vimrc_build_status_last
		endif
		let proc = SbtGetProc()
		if(empty(proc))
			return ""
		endif
		let build_number = proc.last_build_number
		let messages = proc.update()
		if !empty(messages)
			let s:vimrc_build_status_version += 1
		endif
		let build_completed = proc.last_build_number > build_number
		let s = ""
		let error_count = 0
		let warn_count = 0
		if proc.state == 'startup'
			let s .= repeat(".", s:vimrc_build_status_version % 4 + 1)
		elseif proc.state == 'idle'
			if proc.last_compile_result == 'success'
				let s .= "[S]"
			elseif proc.last_compile_result == 'error'
				let s .= "[E]"
			endif
			for e in proc.last_compile_events
				if e.type == 'error'
					let error_count += 1
				elseif e.type == 'warn'
					let warn_count += 1
				else
					echoerr "WARN: Unknown compile event type: " . e.type
				endif
			endfor
		elseif proc.state == 'compile'
			let s .= "[" . repeat(".", s:vimrc_build_status_version % 4 + 1) . "] "
			if !empty(messages)
				let m = matchlist(messages[-1], '\v^\[(error|warn|info|success)\] (.*)')
				let s.= m[1][0] . ':' . m[2][0:20]
			endif
		endif
		if build_completed
			call proc.set_qf()
			call Vimrc_sync_qf_to_syntastic()
		endif
		if error_count > 0
			let s .= "E" . error_count
		endif
		if warn_count > 0
			let s .= "W" . warn_count
		endif
		let b:vimrc_build_status_last_updated = reltime()
		let b:vimrc_build_status_last = s
		return s
	endfunction " }}}
" }}}

if has('clientserver')
	NeoBundle 'mnick/vim-pomodoro' " depends: AsyncCommand
	let g:lightline['component']['pomodoro_status'] = '%{PomodoroStatus()}'
else
	let g:lightline['component']['pomodoro_status'] = ''
endif

NeoBundle 'scrooloose/syntastic' " {{{
	let g:syntastic_scala_checkers=['fsc']
" }}}

" Colors {{{
NeoBundle 'altercation/vim-colors-solarized'
NeoBundle 'pyte'
NeoBundle 'newspaper.vim'
NeoBundle 'Zenburn'
NeoBundle 'ciaranm/inkpot'
NeoBundle 'w0ng/vim-hybrid'
" }}}

" Filetypes {{{

" ruby {{{
NeoBundle 'tpope/vim-rvm' "{{{
" }}}
NeoBundle 'tpope/vim-rbenv'
NeoBundle 'vim-ruby/vim-ruby'
NeoBundle 'tpope/vim-rails'
NeoBundle 'rhysd/vim-textobj-ruby'
NeoBundle 'todesking/ruby_hl_lvar.vim'
" RSense.vim {{{
let g:rsenseHome = expand('~/local/rsense/')
if exists('*RSenseInstalled') && RSenseInstalled()
	let g:rsenseUseOmniFunc = 1
endif
" }}}
" }}}

" Scala {{{
NeoBundle 'derekwyatt/vim-scala'
NeoBundle 'derekwyatt/vim-sbt'
NeoBundle 'gre/play2vim'
NeoBundle 'slim-template/vim-slim' "{{{
	augroup vimrc-plugin-vim-slim
		autocmd!
		autocmd BufNewFile,BufRead *.slim set filetype=slim
		autocmd FileType slim setlocal shiftwidth=2 expandtab
	augroup END
" }}}
NeoBundle 'mdreves/vim-scaladoc' " {{{
	augroup vimrc-vim-scladoc
		autocmd!
		autocmd filetype scala nnoremap K :<C-U>call scaladoc#Search(expand("<cword>"))<CR>
	augroup END
" }}}
NeoBundle 'todesking/qf_sbt.vim'
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
		autocmd FileType yaml setlocal shiftwidth=2 expandtab
	augroup END
" }}}
NeoBundle 'evanmiller/nginx-vim-syntax'
NeoBundle 'wavded/vim-stylus'
NeoBundle 'plasticboy/vim-markdown' "{{{
	let g:markdown_fenced_languages = ['ruby', 'scala', 'vim']
" }}}
" Haskell {{{
NeoBundle 'dag/vim2hs'
NeoBundle 'ujihisa/ref-hoogle'
" }}}
" }}}

" coffeescript {{{
NeoBundle 'kchmck/vim-coffee-script'
" }}}

" Git {{{
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'int3/vim-extradite'
NeoBundle 'Kocha/vim-unite-tig'
NeoBundle 'gregsexton/gitv'
NeoBundle 'airblade/vim-gitgutter' " {{{
	let g:gitgutter_eager = 0
	nnoremap <leader>g :<C-U>call <SID>vimrc_gitgutter_refresh()<CR>
	let g:vimrc_gitgutter_version = 0
	function! s:vimrc_gitgutter_refresh()
		let g:vimrc_gitgutter_version += 1
		call s:vimrc_gitgutter_bufenter()
	endfunction
	function! s:vimrc_gitgutter_bufenter()
		if !exists('b:vimrc_gitgutter_version') || b:vimrc_gitgutter_version != g:vimrc_gitgutter_version
			GitGutter
			let b:vimrc_gitgutter_version = g:vimrc_gitgutter_version
		endif
	endfunction
	augroup vimrc-gitgutter
		autocmd!
		autocmd BufEnter * call s:vimrc_gitgutter_bufenter()
	augroup END

" }}}
" }}}

" ref {{{
NeoBundle 'thinca/vim-ref' "{{{
	let g:ref_refe_cmd="~/local/bin/refe"
	command! -nargs=1 Man :Ref man <args>
	command! -nargs=1 Refe :Ref refe <args>
	augroup vimrc-filetype-ref
		autocmd!
		autocmd FileType ref setlocal bufhidden=hide
	augroup END
" }}}
NeoBundle 'taka84u9/vim-ref-ri', {'rev': 'master'} "{{{
	command! -nargs=1 Ri :Ref ri <args>
" }}}
" }}}

NeoBundle 'grep.vim' "{{{
	let Grep_OpenQuickfixWindow = 0
" }}}

NeoBundle 'mileszs/ack.vim' "{{{
	let g:ackprg = 'ag --nogroup --nocolor --column'
	let g:ack_qhandler = ""
	command! -nargs=1 Pag execute 'Ack ' . <q-args> . ' ' . CurrentProjectInfo().path
" }}}

NeoBundle 'Shougo/vimfiler.vim'

NeoBundle 'Shougo/vimshell.vim' "{{{
" }}}

NeoBundle 'todesking/ttodo.vim' " {{{
	let &titlestring='[TODO] %{g:todo_current_doing}'
" }}}

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

function! Vimrc_file_info(file_path)
	let info = CurrentProjectInfo(a:file_path)
	let info.file_path = substitute(fnamemodify(a:file_path, ':p'), '^' . info.path . '/', '', '')
	return info
endfunction

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
function! Vimrc_complete_current_project_files(ArgLead, CmdLine, CursorPos) abort " {{{
	let prefix = CurrentProjectInfo(expand('%')).path
	return Vimrc_complete_dir(prefix, a:ArgLead, a:CmdLine, a:CursorPos)
endfunction " }}}

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
	execute '%!jad -noctor -ff -i -p ' . file
	setlocal readonly
	setlocal filetype=java
	normal gg=G
	setlocal nomodified
endfunction " }}}

" }}}

" jar {{{
autocmd BufReadCmd *.jar call zip#Browse(expand("<amatch>"))
" }}}
