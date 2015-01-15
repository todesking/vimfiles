" vim:foldmethod=marker
scriptencoding utf-8

" Library {{{
NeoBundle 'Shougo/vimproc.vim', {
      \ 'build' : {
      \     'windows' : 'tools\\update-dll-mingw',
      \     'cygwin' : 'make -f make_cygwin.mak',
      \     'mac' : 'make -f make_mac.mak',
      \     'unix' : 'make -f make_unix.mak',
      \    },
      \ }
if has('clientserver')
	NeoBundle 'pydave/AsyncCommand'
endif
NeoBundle 'todesking/current_project.vim'
NeoBundle 'mattn/webapi-vim'
NeoBundle 'kana/vim-operator-user'
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

NeoBundle 'haya14busa/incsearch.vim' " {{{
	let g:incsearch#consistent_n_direction = 1
	map /  <Plug>(incsearch-forward)
	map ?  <Plug>(incsearch-backward)
	map g/ <Plug>(incsearch-stay)
	map   n <Plug>(incsearch-nohl-n)
	map   N <Plug>(incsearch-nohl-N)
	nmap  n <Plug>(incsearch-nohl)<Plug>(anzu-n-with-echo)
	nmap  N <Plug>(incsearch-nohl)<Plug>(anzu-N-with-echo)
" }}}

NeoBundle 'deris/vim-shot-f'

NeoBundle 'osyo-manga/vim-anzu'
" }}}

" Textobj {{{

NeoBundle 'rhysd/vim-operator-surround' " {{{
	nmap ys <Plug>(operator-surround-append)
	nmap ds <Plug>(operator-surround-delete)
	nmap cs <Plug>(operator-surround-replace)
	let g:operator#surround#blocks = deepcopy(g:operator#surround#default_blocks)
	call add(g:operator#surround#blocks['-'],
	\     {'block': ['\<\[a-zA-z0-9_?!]\+\[(\[]', '\[)\]]'], 'motionwise': 'char', 'keys': ['c']} )
" }}}

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

	call textobj#user#plugin('methodcall', {
	\   'methodcall': {
	\     'pattern': ['\<[a-zA-z0-9_?!]\+[(\[]', '[)\]]'],
	\     'select-a': 'ac',
	\     'select-i': 'ic'
	\   },
	\})
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
NeoBundle 'tpope/vim-commentary'
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
let g:unite_redraw_hold_candidates=300000

let g:unite_source_rec_max_cache_files = 50000

call unite#filters#sorter_default#use(['sorter_smart'])

call unite#custom#profile('default', 'context', {'custom_rec_ignore_directory_pattern': 
			\'/\%(\.hg\|\.git\|\.bzr\|\.svn\|\.\%(sass\|pygments\)-cache\|\.themes\|target\|classes\|build\)/'})
" }}}
" unite-file_mru {{{
let g:unite_source_file_mru_limit=1000
let g:unite_source_file_mru_time_format=''
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
	if path =~# '\v\.rbenv|gems|\.vim'
		let path = substitute(path, '\v\~\/.rbenv\/versions\/([^/]+)\/', '[rbenv:\1] ', '')
		let path = substitute(path, '\v[\/ ]lib\/ruby\/gems\/([^/]+)\/gems\/([^/]+)\/', '[gem:\2] ', '')
		let path = substitute(path, '\v\~\/\.vim\/bundle\/([^/]+)\/', '[.vim/\1] ', '')
	endif
	if path[0] !=# '['
		let info = current_project#file_info(a:path)
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

call unite#custom#source('file_mru', 'matchers', ['converter_index', 'matcher_context'])

for g:source in ['file_mru', 'file_rec', 'buffer']
	call unite#custom#source(g:source, 'converters', ['converter_remove_trash_files', 'converter_summarize_path', 'converter_hide_unimportant_path'])
endfor
unlet g:source

call unite#custom#source('file_rec', 'max_candidates', 0)
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
let g:unite_source_outline_info = {
\  'ref-man': unite#sources#outline#defaults#man#outline_info(),
\ }
let s:x = unite#sources#outline#modules#ctags#import()
let s:x.exe .= ' --languages=+Java'
unlet s:x
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
nnoremap <C-Q>P :<C-u>exec 'Unite file_rec:'.current_project#info(expand('%')).main_path<CR>
nnoremap <C-Q>p :<C-u>exec 'Unite file_rec:'.current_project#info(expand('%')).sub_path<CR>
nnoremap <C-Q>c :<C-u>exec 'Unite file_rec:'.expand('%:p:h').'/'<CR>
nnoremap <C-Q>l :<C-u>Unite line<CR>
nnoremap <C-Q>b :<C-u>Unite buffer<CR>
nnoremap <C-Q>gc :<C-u>Unite git/files/conflict<CR>
nnoremap <C-Q>gf :<C-u>Unite gitreview/changed_files<CR>
nnoremap <C-Q><C-P> :<C-u>UnitePrevious<CR>
nnoremap <C-Q><C-N> :<C-u>UniteNext<CR>
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
" }}}

if(has('lua'))
NeoBundle 'Shougo/neocomplete.vim' "{{{
let g:neocomplete#enable_at_startup = 1
let g:neocomplete#force_overwrite_completefunc = 1
let g:neocomplete#enable_prefetch=1
let g:neocomplete#enable_smart_case = 1
let g:neocomplete#lock_iminsert = 1
if !exists('g:neocomplete#keyword_patterns')
	let g:neocomplete#keyword_patterns = {}
endif
let g:neocomplete#keyword_patterns.scala = '\v\h\w*%(\.\h\w*)*'
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
				\   'project_name': '%{current_project#info().name}',
				\   'project_path': '%{Vimrc_summarize_project_path(current_project#file_info(expand(''%''))["file_path"])}',
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
		if exists('*gitreview#fugitive#branch_string')
			let s = gitreview#fugitive#branch_string()
			if len(s)
				let s .= '(' . s . ')'
			endif
			let b:vimrc_statusline_git_branch = s
			let b:vimrc_statusline_git_branch_updated_at = reltime()
		else
			return ''
		endif
	endfunction " }}}
	function! Vimrc_build_status() abort " {{{
		let proc = qf_sbt#get_proc()
		if empty(proc) " sbt not started
			return ''
		elseif !qf_sbt#is_valid(proc) " sbt started, but died unexpectedly.
			return '(>_<)'
		else
			" throttle for prevent too many updates
			if !exists('b:vimrc_build_status_last_updated')
				let b:vimrc_build_status_last_updated = reltime()
			endif
			if str2float(reltimestr(reltime(b:vimrc_build_status_last_updated))) > 0.5
				let build_number = proc.last_build_number
				call proc.update()
				if build_number < proc.last_build_number
					call proc.set_qf() " Set build result to quickfix
				endif
				let b:vimrc_build_status_last_updated = reltime()
			endif
			if !exists('w:Vimrc_build_status_sync') || w:Vimrc_build_status_sync != proc.last_build_number
				SyntasticSetQF
				let w:Vimrc_build_status_sync = proc.last_build_number
			endif
			return proc.build_status_string
		endif
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
	command! SyntasticSetQF call setqflist(g:SyntasticLoclist.current().getRaw())
" }}}

NeoBundle 'todesking/vint-syntastic'
let g:syntastic_vim_checkers = ['vint']


" Colors {{{
NeoBundle 'altercation/vim-colors-solarized'
NeoBundle 'pyte'
NeoBundle 'newspaper.vim'
NeoBundle 'Zenburn'
NeoBundle 'ciaranm/inkpot'
NeoBundle 'w0ng/vim-hybrid'
NeoBundle 'chriskempson/vim-tomorrow-theme'
NeoBundle 'endel/vim-github-colorscheme'
" }}}

" Filetypes {{{

NeoBundle 'wting/rust.vim'

NeoBundle 'GEverding/vim-hocon'

" ruby {{{
NeoBundle 'tpope/vim-rvm' "{{{
" }}}
NeoBundle 'tpope/vim-rbenv'
NeoBundle 'vim-ruby/vim-ruby'
NeoBundle 'tpope/vim-rails'
NeoBundle 'rhysd/vim-textobj-ruby'
NeoBundle 'todesking/ruby_hl_lvar.vim' " {{{
	let g:ruby_hl_lvar_show_warnings = 1
" }}}
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
" markdown {{{
	let g:markdown_fenced_languages = ['ruby', 'scala', 'vim', 'java']
" }}}
" Haskell {{{
NeoBundle 'dag/vim2hs'
NeoBundle 'ujihisa/ref-hoogle'
" }}}
" coffeescript {{{
NeoBundle 'kchmck/vim-coffee-script'
" }}}
NeoBundle 'ekalinin/Dockerfile.vim'
" Vim " {{{
" NeoBundle 'syngan/vim-vimlint', {'depends' : 'ynkdir/vim-vimlparser'}

let g:vim_indent_cont = 0
" }}}

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
			call gitreview#gitgutter#process_buffer(bufnr(''), 0)
			let b:vimrc_gitgutter_version = g:vimrc_gitgutter_version
		endif
	endfunction
	augroup vimrc-gitgutter
		autocmd!
		autocmd BufEnter * call s:vimrc_gitgutter_bufenter()
	augroup END

" }}}
NeoBundle 'todesking/gitreview.vim' " {{{
nmap ,gg <Plug>(gitreview-gitgutter-next-sign)
nmap ,gp <Plug>(gitreview-gitgutter-prev-sign)
nmap ,gd :<C-u>GitReviewDiff<CR>
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

NeoBundle 'mileszs/ack.vim' "{{{
	let g:ackprg = 'ag --nogroup --nocolor --column'
	let g:ack_qhandler = ""
	command! -nargs=+ Pag call Vimrc_ag(current_project#info().path, <f-args>)
	command! -nargs=+ PAg call Vimrc_ag(current_project#info().main_path, <f-args>)
	function! Vimrc_ag(path, ...) abort " {{{
		if a:0 == 1
			let path = a:path
			let query = a:1
		else
			let path = a:path . '/' . a:2
			let query = a:1
		endif
		execute 'Ack ' . query . ' ' . path
	endfunction " }}}
" }}}

NeoBundle 'Shougo/vimfiler.vim'

NeoBundle 'Shougo/vimshell.vim' "{{{
" }}}

NeoBundle 'todesking/ttodo.vim' " {{{
	let &titlestring='[TODO] %{g:todo_current_doing}'
" }}}
