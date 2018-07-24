" vim:foldmethod=marker
scriptencoding utf-8

" vint: -ProhibitUnnecessaryDoubleQuote

let g:todespm#engine = 'dein'

function! s:bundle(...) abort " {{{
	return call('todespm#bundle', a:000)
endfunction " }}}

function! s:new_hooks(...) abort " {{{
	return call('todespm#new_hooks', a:000)
endfunction " }}}

call todespm#begin(expand('~/.vim/bundle/'))


call s:bundle('Shougo/dein.vim')

call s:bundle('todesking/loadenv.vim')
function! g:todespm#the_hooks.after() abort " {{{
	if executable('/usr/local/bin/bash')
		call loadenv#load(
		\ '/usr/local/bin/bash -i -c __CMD__',
		\ ['PATH', 'JAVA_HOME']
		\ )
	endif
endfunction " }}}

" Library {{{
call s:bundle('Shougo/vimproc.vim', {
      \ 'build' : {
      \     'windows' : 'tools\\update-dll-mingw',
      \     'cygwin' : 'make -f make_cygwin.mak',
      \     'mac' : 'make -f make_mac.mak',
      \     'unix' : 'make -f make_unix.mak',
      \    },
      \ })
call s:bundle('todesking/current_project.vim')

call s:bundle('todesking/metascope.vim')
function! g:todespm#the_hooks.after() abort " {{{
	let def = {'name': 'current_project'}
	function! def.scope_identifier() abort " {{{
		let path = current_project#info().main_path
		return len(path) ? path : '__ROOT__'
	endfunction " }}}
	call metascope#register(def)
endfunction " }}}

call s:bundle('todesking/scoped_qf.vim')
function! g:todespm#the_hooks.after() abort " {{{
	let g:scoped_qf_scope_type = 'current_project'
endfunction " }}}

call s:bundle('mattn/webapi-vim')
call s:bundle('kana/vim-operator-user')

" }}}


" Navigation/Highlight {{{

call s:new_hooks('matchparen')
function! g:todespm#the_hooks.after() abort " matchparen {{{
	let g:matchparen_timeout = 10
	let g:matchparen_insert_timeout = 10
endfunction " }}}

call s:bundle('Lokaltog/vim-easymotion')
function! g:todespm#the_hooks.after() abort " {{{
	nmap <silent><C-J> <Plug>(easymotion-w)
	nmap <silent><C-K> <Plug>(easymotion-b)
	vmap <silent><C-J> <Plug>(easymotion-w)
	vmap <silent><C-K> <Plug>(easymotion-b)
	let g:EasyMotion_keys = 'siogkmjferndlhyuxvtcbwa'
endfunction " }}}

call s:bundle('vim-scripts/a.vim')

call s:bundle('nathanaelkane/vim-indent-guides')
function! g:todespm#the_hooks.after() abort " {{{
	if has('gui_running')
		if exists('#indent_guides')
			autocmd! indent_guides BufEnter *
		endif
		augroup vimrc-indentguide
			autocmd!
			autocmd BufWinEnter,BufNew * highlight IndentGuidesOdd guifg=NONE guibg=NONE
		augroup END
		let g:indent_guides_enable_on_vim_startup=0
		let g:indent_guides_start_level=1
		let g:indent_guides_guide_size=1
	endif
endfunction " }}}

call s:bundle('osyo-manga/vim-brightest')

call s:bundle('deris/vim-shot-f')

call s:bundle('osyo-manga/vim-anzu')

call s:bundle('haya14busa/vim-operator-flashy')
function! g:todespm#the_hooks.after() abort " {{{
	map y <Plug>(operator-flashy)
	nmap Y <Plug>(operator-flashy)$
endfunction " }}}

call s:bundle('Konfekt/FastFold')

" }}}


" Textobj {{{

call s:bundle('kana/vim-textobj-user')
function! g:todespm#the_hooks.after() abort " {{{
	call textobj#user#plugin('lastmofified', {
	\   'lastmodified': {
	\     'select-a': 'al',
	\     'select-a-function': 'g:Vimrc_select_a_last_modified',
	\   },
	\ })
	function! g:Vimrc_select_a_last_modified() abort
		return ['v', getpos("'["), getpos("']")]
	endfunction
endfunction " }}}

call s:bundle('rhysd/vim-operator-surround')
function! g:todespm#the_hooks.after() abort " {{{
	nmap ys <Plug>(operator-surround-append)
	nmap ds <Plug>(operator-surround-delete)
	nmap cs <Plug>(operator-surround-replace)
endfunction " }}}

call s:bundle('todesking/vim-textobj-methodcall')
function! g:todespm#the_hooks.after() abort " {{{
	let g:operator#surround#blocks =
		\ textobj#methodcall#operator_surround_blocks(deepcopy(g:operator#surround#default_blocks), 'c')
endfunction " }}}

call s:bundle('vim-scripts/argtextobj.vim')
" }}}


" Edit support {{{
if 0
	call s:bundle('todesking/YankRing.vim')
	function! g:todespm#the_hooks.after() abort " {{{
		let g:yankring_max_element_length = 0
		let g:yankring_max_history_element_length = 1000 * 10
		map y <Plug>(operator-flashy)
		nmap Y <Plug>(operator-flashy)$
	endfunction " }}}
endif

call s:bundle('LeafCage/yankround.vim')
function! g:todespm#the_hooks.after() abort " {{{
	nmap p <Plug>(yankround-p)
	xmap p <Plug>(yankround-p)
	nmap P <Plug>(yankround-P)
	nmap gp <Plug>(yankround-gp)
	xmap gp <Plug>(yankround-gp)
	nmap gP <Plug>(yankround-gP)
	nmap <C-p> <Plug>(yankround-prev)
	nmap <C-n> <Plug>(yankround-next)
endfunction " }}}

call s:bundle('junegunn/vim-easy-align')

call s:bundle('vim-scripts/Align')
function! g:todespm#the_hooks.after() abort " {{{
	let g:Align_xstrlen='strwidth'
	map (trashbox-leader-rwp) <Plug>RestoreWinPosn
	map (trashbox-leader-swp) <Plug>SaveWinPosn
	let g:loaded_AlignMapsPlugin = 1
endfunction " }}}

call s:bundle('godlygeek/tabular')

call s:bundle('vim-scripts/closetag.vim')
function! g:todespm#the_hooks.after() abort " {{{
	augroup vimrc-closetag-vim
		autocmd!
		autocmd Filetype * call Vimrc_ft_closetag()
	augroup END
	function! Vimrc_ft_closetag() abort " {{{
		if &filetype ==# 'xml'
			let b:unaryTagsStack = ''
		else
			let b:unaryTagsStack='area base br dd dt hr img input link meta param'
		endif
	endfunction " }}}
endfunction " }}}

call s:bundle('Shougo/neosnippet.vim')
function! g:todespm#the_hooks.after() abort " {{{
	let g:neosnippet#disable_runtime_snippets = {
	\ '_': 1,
	\ }
	imap <C-k>     <Plug>(neosnippet_expand_or_jump)
	smap <C-k>     <Plug>(neosnippet_expand_or_jump)
	xmap <C-k>     <Plug>(neosnippet_expand_target)
	let g:neosnippet#snippets_directory='~/.vim/snippets'
endfunction " }}}

call s:bundle('tpope/vim-repeat')
call s:bundle('mbbill/undotree')
call s:bundle('tpope/vim-commentary')
call s:bundle('AndrewRadev/splitjoin.vim')
" }}}


" Utilities {{{
call s:bundle('AndrewRadev/linediff.vim')
call s:bundle('osyo-manga/vim-over')
call s:bundle('taku-o/vim-zoom')
call s:bundle('tyru/capture.vim')
call s:bundle('ciaranm/detectindent')
call s:bundle('osyo-manga/vim-automatic')
" }}}


" Games {{{
call s:bundle('mattn/habatobi-vim')
call s:bundle('thinca/vim-threes')
call s:bundle('katono/rogue.vim')
" }}}


" " Unite {{{
if 0
	call s:bundle('Shougo/unite.vim')
	function! g:todespm#the_hooks.after() abort " {{{
		let g:unite_enable_start_insert = 1
		let g:unite_update_time = 100
		let g:unite_cursor_line_highlight='CursorLine'
		let g:unite_redraw_hold_candidates=300000

		let g:unite_source_rec_max_cache_files = 50000
		let g:unite_source_rec_async_command=[expand('~/.vim/bin/list_file_rec')]
		let g:unite_source_file_async_command=expand('~/.vim/bin/list_file_rec')

		let g:unite_source_history_unite_limit = 1

		call unite#filters#sorter_default#use(['sorter_smart'])

		" unite-file_mru {{{
		let g:unite_source_file_mru_limit=1000
		let g:unite_source_file_mru_time_format=''
		let g:unite_source_mru_do_validate=0
		" }}}


		" hide_unimportant_path {{{
		let filter={'name': 'converter_hide_unimportant_path'}
		function! filter.filter(candidates, context)
			if len(a:candidates) > 1000
				return a:candidates
			endif
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

				if len(components[0]) > 0
					if i > 1
						let cand.abbr = '!!!{'.components[0].join(components[1: i-1], '/').'/}!!!'.join(components[i :], '/')
					elseif i == 1
						let cand.abbr = '!!!{'.components[0].'}!!!'.join(components[i :], '/')
					endif
				endif
				let prev = components
			endfor
			return a:candidates
		endfunction
		call unite#define_filter(filter)
		" }}}

		" Default source config " {{{
		call unite#custom#source('file_mru', 'matchers', ['converter_index', 'matcher_context'])

		for g:source in ['file', 'file_mru', 'file_rec', 'file_rec/async', 'buffer']
			call unite#custom#source(g:source, 'converters', ['converter_summarize_project_path', 'converter_hide_unimportant_path'])
		endfor
		unlet g:source

		for g:source in ['file_rec', 'file_rec/async']
			call unite#custom#source(g:source, 'matchers', ['matcher_default'])
		endfor
		unlet g:source

		call unite#custom#source('file_rec', 'max_candidates', 0)
		call unite#custom#source('file_rec/async', 'max_candidates', 0)
		" }}}
	endfunction " }}}

	" Vimrc_unite_syntax {{{
	function! Vimrc_unite_syntax()
		syntax match unite__word_tag /\[[^]]\+\]/ contained containedin=uniteSource__FileMru,uniteSource__FileRec,uniteSource__FileRecAsync
		highlight link unite__word_tag Identifier
		syntax region UniteUnimportant keepend excludenl matchgroup=UniteUnimportantMarker start=/!!!{/ end=/}!!!/ concealends containedin=uniteSource__FileMru,uniteSource_File,uniteSource__FileRec,uniteSource__FileRecAsync,uniteSource__Buffer
		highlight link UniteUnimportant Comment
		setlocal concealcursor+=i
	endfunction

	augroup vimrc-untie-syntax
		autocmd!
		autocmd FileType unite :call Vimrc_unite_syntax()
	augroup END
	" }}}

	call s:bundle('tsukkee/unite-tag')
	function! g:todespm#the_hooks.after() abort " {{{
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
		let c = {'name': 'converter_tag'}
		function! c.filter(candidates, context) abort
			for c in a:candidates
				let spath = current_project#summarize_path(c.action__path)
				let c.abbr = printf('%-25s @%-100s', c.action__tagname, spath)
				let c.word = c.action__tagname . ' ' . spath
			endfor
			return a:candidates
		endfunction
		call unite#define_filter(c)
		call unite#custom#source('tag','converters', ['converter_tag'])
	endfunction " }}}

	call s:bundle('Shougo/unite-outline')
	function! g:todespm#the_hooks.after() abort " {{{
		let g:unite_source_outline_scala_show_all_declarations = 1
		let g:unite_source_outline_info = {
		\  'ref-man': unite#sources#outline#defaults#man#outline_info(),
		\ }
		let x = unite#sources#outline#modules#ctags#import()
		let x.exe .= ' --languages=+Java,C,C++'
	endfunction " }}}

	call s:bundle('sgur/unite-qf')
	function! g:todespm#the_hooks.after() abort " {{{
		nnoremap <C-Q>f :<C-u>Unite qf -no-start-insert -auto-preview -no-split -winheight=30 -wipe<CR>
		nnoremap <C-Q>F :<C-u>Unite locationlist -no-start-insert -auto-preview -no-split -winheight=30 -wipe<CR>

		for s in ['qf', 'locationlist']
			call unite#custom#profile('source/' . s, 'context', {'max_multi_lines': 20})
			call unite#custom#source(s, 'converters', ['converter_pretty_qf'])
		endfor

		let filter = {'name': 'converter_pretty_qf'}

		function! filter.filter(candidates, context) abort " {{{
			for c in a:candidates
				let message = substitute(c.word, '^.\{-}|\d\+| ', '', '')
				let message = join(map(split(message, "\n"), '"| " . v:val'), "\n") . "\n|"
				let c.word = current_project#summarize_path(c.action__path) . ':' . c.action__line . "\n" . message
			endfor
			return a:candidates
		endfunction " }}}

		call unite#define_filter(filter)
	endfunction " }}}

	call s:bundle('basyura/unite-rails')
	function! g:todespm#the_hooks.after() abort " {{{
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
	endfunction " }}}

	call s:bundle('osyo-manga/unite-fold')
	function! g:todespm#the_hooks.after() abort " {{{
		call unite#custom#source('fold','sorters', ['sorter_nothing'])
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
	endfunction " }}}

	call s:bundle('ujihisa/unite-colorscheme')
	function! g:todespm#the_hooks.after() abort " {{{
		command! Colors Unite colorscheme -auto-preview
	endfunction " }}}

	call s:bundle('ujihisa/unite-font')

	call s:bundle('Shougo/neomru.vim')
	function! g:todespm#the_hooks.after() abort " {{{
		let g:neomru#do_validate = 1
	endfunction " }}}

	call s:bundle('osyo-manga/unite-candidate_sorter')
	function! g:todespm#the_hooks.after() abort " {{{
		augroup vimrc-unite-candidate-sorter
		  autocmd!
		  autocmd FileType unite nmap <silent><buffer> S <Plug>(unite-candidate_sort)
		augroup END
	endfunction " }}}


	" Keymap {{{

	augroup unite-keybind
		autocmd!
		autocmd FileType unite nmap <buffer><silent><Esc> q
	augroup END

	nnoremap <silent><C-S> :Unite file_mru<CR>

	nnoremap <C-Q>  <ESC>

	nnoremap <C-Q>u :UniteResume<CR>
	nnoremap <C-Q>o m':<C-u>Unite outline<CR>
	nnoremap <C-Q>P :<C-u>exec 'Unite file_rec/async:'.current_project#info(expand('%')).main_path<CR>
	nnoremap <C-Q>p :<C-u>exec 'Unite file_rec/async:'.current_project#info(expand('%')).sub_path<CR>
	nnoremap <C-Q>c :<C-u>exec 'Unite file_rec:'.expand('%:p:h').'/'<CR>
	nnoremap <C-Q>l :<C-u>Unite line<CR>
	nnoremap <C-Q>b :<C-u>Unite buffer<CR>
	nnoremap <C-Q>gc :<C-u>Unite git/files/conflict<CR>
	nnoremap <C-Q>gf :<C-u>Unite gitreview/changed_files<CR>
	nnoremap <C-Q><C-P> :<C-u>UnitePrevious<CR>
	nnoremap <C-Q><C-N> :<C-u>UniteNext<CR>
	nnoremap <C-Q><C-Q>p :<C-u>Projects<CR>
	nnoremap <C-Q><C-Q>n :<C-u>Nyandoc<CR>
	" }}}


	" Sources {{{
	call s:new_hooks('unite-neco')
	function! g:todespm#the_hooks.after() abort " unite-neco {{{
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
	endfunction " }}}

	call s:new_hooks('unite-massive-candidates')
	function! g:todespm#the_hooks.after() abort " unite-massive-candidates {{{
		let s:unite_source = {'name': 'massive-candidates'}
		function! s:unite_source.gather_candidates(args, context)
			return map(repeat(['a', 'b', 'c'], 10000), '{
				\ "word": v:val,
				\ "source": "massive-candidates",
				\ "kind": "word",
				\ }')
		endfunction
		call unite#define_source(s:unite_source)
	endfunction " }}}

	call s:new_hooks('unite vim-functions')
	function! g:todespm#the_hooks.after() abort " Unite vim-functions {{{
		let def = {'name': 'vim-functions', 'default_action': 'open'}

		let s:unite_vim_functions_cache = []

		function! def.gather_candidates(args, context) abort " {{{
			if len(s:unite_vim_functions_cache)
				return s:unite_vim_functions_cache
			endif
			let s:unite_vim_functions_cache = s:make_cache_functions()
			for c in s:unite_vim_functions_cache
				let c.kind = 'common'
				let c.action__tagname = c.word . ')'
				let c.abbr = substitute(c.abbr, '\t', '        ', 'g')
			endfor
			return s:unite_vim_functions_cache
		endfunction " }}}

		let def.action_table = {}
		let def.action_table.open = {}

		function! def.action_table.open.func(candidate) abort " {{{
			execute 'help ' . a:candidate.action__tagname
		endfunction " }}}

		call unite#define_source(def)

		" from NeoComplete(https://github.com/Shougo/neocomplete.vim)
		" autoload/neocomplete/sources/vim/helper.vim
		function! s:make_cache_functions() "{{{
		  let helpfile = expand(findfile('doc/eval.txt', &runtimepath))
		  if !filereadable(helpfile)
			return []
		  endif

		  let lines = readfile(helpfile)
		  let functions = []
		  let start = match(lines, '^abs')
		  let end = match(lines, '^abs', start, 2)
		  let desc = ''
		  for i in range(end-1, start, -1)
			let desc = substitute(lines[i], '^\s\+\ze\S', '', '').' '.desc
			let _ = matchlist(desc,
				  \'^\s*\(\(\i\+(\).*)\)\s\+\(\w*\)\s\+\(.\+[^*]\)$')
			if !empty(_)
			  call insert(functions, {
					\ 'word' : _[2],
					\ 'abbr' : substitute(_[0], '(\zs\s\+', '', ''),
					\ })
			  let desc = ''
			endif
		  endfor

		  return functions
		endfunction "}}}
	endfunction "}}}

	call s:new_hooks('unite git sources')
	function! g:todespm#the_hooks.after() abort " Git sources {{{
		" (original: https://github.com/aereal/dotfiles/blob/master/.vim/vimrc )
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
	endfunction " }}}

	" }}}
endif
" }}}


" Denite {{{
if(has('python3'))
	call s:bundle('Shougo/denite.nvim')
	function! g:todespm#the_hooks.after() abort " {{{
		call denite#custom#map('insert', '<C-N>', '<denite:move_to_next_line>', 'noremap')
		call denite#custom#map('insert', '<C-P>', '<denite:move_to_previous_line>', 'noremap')
		call denite#custom#map('insert', '<C-U>', '<denite:scroll_window_upwards>', 'noremap')
		call denite#custom#map('insert', '<C-D>', '<denite:scroll_window_downwards>', 'noremap')

		call denite#custom#option('_', 'direction', 'topleft')

		call denite#custom#source(
			\ 'file_rec,file_mru,project_file_mru',
			\ 'converters',
			\ ['converter/project_name', 'converter/mark_dup']
			\ )
		call denite#custom#source(
			\ 'file_rec,file_mru,project_file_mru',
			\ 'matchers',
			\ ['matcher/substring']
			\ )

		nnoremap <silent><C-S> :<C-u>call Vimrc_denite_mru_if_available()<CR>
		nnoremap <silent><C-Q>s :<C-u>Denite file_mru<CR>
		nnoremap <C-Q>  <ESC>
		nnoremap <C-Q>u :Denite -resume<CR>
		nnoremap <C-Q>P :<C-u>exec 'Denite file_rec:' . current_project#info(expand('%')).main_path<CR>
		nnoremap <C-Q>p :<C-u>exec 'Denite file_rec:' . current_project#info(expand('%')).sub_path<CR>
		nnoremap <C-Q>c :<C-u>DeniteBufferDir file_rec<CR>
		nnoremap <C-Q>l :<C-u>Denite line<CR>
		nnoremap <C-Q>b :<C-u>Denite buffer<CR>
		nnoremap <C-Q>o :<C-u>Denite unite:outline<CR>
		nnoremap <C-Q>d :<C-u>Denite unite:fold<CR>
		nnoremap <C-Q><C-P> :<C-u>Denite -resume -cursor-pos=-1 -immediately<CR>
		nnoremap <C-Q><C-N> :<C-u>Denite -resume -cursor-pos=+1 -immediately<CR>
	endfunction " }}}
	function! Vimrc_denite_mru_if_available() abort " {{{
		let info = current_project#info()
		if empty(info.name)
			Denite file_mru
		else
			call denite#helper#call_denite('Denite', 'project_file_mru:' . info.path, '', '')
		endif
	endfunction " }}}

	call s:bundle('Shougo/neomru.vim')

	" Unite {{{
	call s:bundle('Shougo/unite.vim')
	call s:bundle('Shougo/unite-outline')
	call s:bundle('osyo-manga/unite-fold')
	" }}}

	function! Vimrc_unite_syntax() abort " {{{
		" syntax match MyDeniteProjectName /^\[[^]]\+\]/
		" highlight link MyDeniteProjectName Identifier
		syntax region MyDeniteUnimportant matchgroup=MyDeniteConceal excludenl start=/{{{/ end=/}}}/ concealends containedin=deniteSource_file_rec,deniteSource_file_mru,deniteSource_project_file_mru
		highlight link MyDeniteUnimportant Comment
		setlocal concealcursor+=i
	endfunction " }}}

	augroup vimrc-denite-syntax
		autocmd!
		autocmd FileType denite :call Vimrc_unite_syntax()
	augroup END
endif
" }}}


if 0 && has('lua') " Neocomplete {{{
	call s:bundle('Shougo/neocomplete.vim')
	function! g:todespm#the_hooks.after() abort " {{{
		let g:neocomplete#enable_at_startup = 1
		let g:neocomplete#force_overwrite_completefunc = 1
		let g:neocomplete#enable_prefetch=1
		let g:neocomplete#enable_smart_case = 1
		" let g:neocomplete#lock_iminsert = 1
		if !exists('g:neocomplete#keyword_patterns')
			let g:neocomplete#keyword_patterns = {}
		endif
		let g:neocomplete#keyword_patterns.scala = '\v\h\w*%(\.\h\w*)*'
		augroup vimrc-neocomplete
			autocmd!
			" autocmd CursorMovedI * call Vimrc_neocomplete_control()
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
	endfunction " }}}
endif
" }}}

if !has('nvim')
  call s:bundle('roxma/nvim-yarp')
  call s:bundle('roxma/vim-hug-neovim-rpc')
endif
call s:bundle('Shougo/deoplete.nvim')
function! g:todespm#the_hooks.after() abort " {{{
	let g:deoplete#enable_at_startup = 1
endfunction " }}}

call s:bundle('itchyny/lightline.vim')
function! g:todespm#the_hooks.after() abort " {{{
	function! Vimrc_summarize_project_path(path) abort " {{{
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
	endfunction " }}}
	" let g:lightline {{{
	let g:lightline = {
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
	" }}}
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
		let throttle_key = 'Vimrc_statusline_git_branch'
		if !throttle#can_enter('b', throttle_key, 3.0)
			return throttle#previous_data('b', throttle_key)
		endif

		if exists('*gitreview#branch_string')
			let s = gitreview#branch_string(expand('%'))
			if len(s)
				let s = '(' . s . ')'
			endif
		else
			let s = ''
		endif
		call throttle#entered('b', throttle_key, s)
		return s
	endfunction " }}}
	function! Vimrc_build_status() abort " {{{
		let throttle_key = 'Vimrc_statusline_build_status'
		if !throttle#can_enter('b', throttle_key, 1.0)
			return throttle#previous_data('b', throttle_key)
		endif

		let proc = qf_sbt#get_proc()
		if !qf_sbt#is_valid(proc)
			if empty(proc)
				let loc_list = g:SyntasticLoclist.current()
				let status = ''

				let errors = len(loc_list.errors())
				let warns = len(loc_list.warnings())

				if 0 < errors
					let status .= 'E' . string(errors)
				endif
				if 0 < warns
					let status .= 'W' . string(errors)
				endif
				if len(status)
					let status = '[' . status . ']'
				endif
			else
				let status = '(>_<)'
			endif
		else
			let build_number = proc.last_build_number
			call proc.update()
			let status = proc.build_status_string
			let build_finished = proc.last_build_number != build_number

			if build_finished
				call scoped_qf#set(proc.getqflist())
			endif

			let sync = [proc.path, proc.last_build_number]
			if !exists('w:Vimrc_build_status_sync') || w:Vimrc_build_status_sync != sync
				call Vimrc_sync_qf_to_syntastic()
				let w:Vimrc_build_status_sync = sync
			endif
		endif
		call throttle#entered('b', throttle_key, status)
		return status
	endfunction " }}}
endfunction " }}}

call s:bundle('scrooloose/syntastic')
function! g:todespm#the_hooks.after() abort " {{{
	let g:syntastic_scala_checkers=['fsc']
	let g:syntastic_always_populate_loc_list=1

	" qf to syntastic {{{
	function! Vimrc_sync_qf_to_syntastic() abort " {{{
		if g:SyntasticLoclist.current().getRaw() == getqflist()
			return
		endif
		let notifier = g:SyntasticNotifiers.Instance()
		call notifier.reset(g:SyntasticLoclist.current())

		if(!has_key(b:, 'syntastic_loclist')) " TODO
			return
		endif

		if(has_key(b:syntastic_loclist, 'destroy')) " TODO: BUG?
			call b:syntastic_loclist.destroy()
		endif

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
endfunction " }}}

call s:bundle('todesking/vint-syntastic')
function! g:todespm#the_hooks.after() abort " {{{
	let g:syntastic_vim_checkers = ['vint']
endfunction " }}}

" }}}


" Colors {{{
call s:bundle('altercation/vim-colors-solarized')
call s:bundle('vim-scripts/pyte')
call s:bundle('vim-scripts/newspaper.vim')
call s:bundle('vim-scripts/Zenburn')
call s:bundle('ciaranm/inkpot')
call s:bundle('w0ng/vim-hybrid')
call s:bundle('chriskempson/vim-tomorrow-theme')
call s:bundle('endel/vim-github-colorscheme')
" }}}


" Filetypes {{{

call s:bundle('tmhedberg/SimpylFold')

call s:bundle('wting/rust.vim')

call s:bundle('GEverding/vim-hocon')

" ruby {{{
call s:bundle('tpope/vim-rvm')

call s:bundle('tpope/vim-rbenv')
call s:bundle('vim-ruby/vim-ruby')
call s:bundle('tpope/vim-rails')
call s:bundle('rhysd/vim-textobj-ruby')
call s:bundle('todesking/ruby_hl_lvar.vim')
function! g:todespm#the_hooks.after() abort " {{{
	let g:ruby_hl_lvar_show_warnings = 1
endfunction " }}}
" }}}


" Scala {{{
call s:bundle('derekwyatt/vim-scala')
call s:bundle('derekwyatt/vim-sbt')
call s:bundle('gre/play2vim')

" call s:bundle('ensime/ensime-vim')
function! g:todespm#the_hooks.after() abort " {{{
	let g:ensime_auto_start = 0
endfunction " }}}

call s:bundle('slim-template/vim-slim')
function! g:todespm#the_hooks.after() abort " {{{
	augroup vimrc-plugin-vim-slim
		autocmd!
		autocmd BufNewFile,BufRead *.slim set filetype=slim
		autocmd FileType slim setlocal shiftwidth=2 expandtab
	augroup END
endfunction " }}}

call s:bundle('todesking/qf_sbt.vim')
function! g:todespm#the_hooks.after() abort " {{{
	let g:qf_sbt_additional_args___ = [
	\ 'set commands += Command.command("qf_sbt_disable_scalariform"){s =>'
	\ . 'val key = "scalariformFormat";'
	\ . 'if(Project.extract(s).getOpt(SettingKey[Any](key)).isDefined || true){println("found");'
	\ . 's"""set SettingKey[List[Nothing]]("${key}") in compile := List()""" :: s}else{s}}',
	\ 'qf_sbt_disable_scalariform'
	\ ]
endfunction " }}}

" }}}


call s:bundle('roalddevries/yaml.vim')
function! g:todespm#the_hooks.after() abort " {{{
	function! Vimrc_autocmd_yaml_vim()
		if &foldmethod !=# 'syntax'
			runtime yaml.vim
			set foldmethod=syntax
		endif
	endfunction
	augroup vimrc-yaml-vim
		autocmd!
		autocmd FileType yaml nmap <buffer><leader>f :<C-U>call Vimrc_autocmd_yaml_vim()<CR>
		autocmd FileType yaml setlocal shiftwidth=2 expandtab
	augroup END
endfunction " }}}

" call s:bundle('evanmiller/nginx-vim-syntax')

call s:bundle('wavded/vim-stylus')

call s:new_hooks('ft: markdown') " markdown {{{
function! g:todespm#the_hooks.after() abort
	let g:markdown_fenced_languages = ['ruby', 'scala', 'vim', 'java', 'javascript']
endfunction " }}}

call s:bundle('kchmck/vim-coffee-script')

call s:bundle('ekalinin/Dockerfile.vim')

" Vim " {{{
" call s:bundle('syngan/vim-vimlint'), {'depends' : 'ynkdir/vim-vimlparser'}

let g:vim_indent_cont = 0
" }}}

" }}}}


" Git {{{
call s:bundle('tpope/vim-fugitive')
call s:bundle('int3/vim-extradite')
call s:bundle('Kocha/vim-unite-tig')
call s:bundle('gregsexton/gitv')
call s:bundle('airblade/vim-gitgutter')
function! g:todespm#the_hooks.after() abort " {{{
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
endfunction " }}}

call s:bundle('todesking/gitreview.vim')
function! g:todespm#the_hooks.after() abort " {{{
	nmap ,gg <Plug>(gitreview-gitgutter-next-sign)
	nmap ,gp <Plug>(gitreview-gitgutter-prev-sign)
	nmap ,gd :<C-u>GitReviewDiff<CR>
endfunction " }}}

" }}}


call s:bundle('thinca/vim-ref')
function! g:todespm#the_hooks.after() abort " {{{
	let g:ref_refe_cmd="~/local/bin/refe"
	let g:ref_man_cmd = 'man'
	command! -nargs=1 Man :Ref man <args>
	command! -nargs=1 Refe :Ref refe <args>
	augroup vimrc-filetype-ref
		autocmd!
		autocmd FileType ref setlocal bufhidden=hide
	augroup END
endfunction " }}}

call s:bundle('taka84u9/vim-ref-ri', {'rev': 'master'})
function! g:todespm#the_hooks.after() abort " {{{
	command! -nargs=1 Ri :Ref ri <args>
endfunction " }}}

call s:bundle('mileszs/ack.vim')
function! g:todespm#the_hooks.after() abort " {{{
	let g:ackprg = 'ag'
	let g:ack_default_options = '-s -H --nogroup --nocolor --column'
	let g:ack_qhandler = ''
	command! -nargs=* Pag call g:Vimrc_ag(current_project#info().path, [<f-args>])
	command! -nargs=* PAg call g:Vimrc_ag(current_project#info().main_path, [<f-args>])
	function! g:Vimrc_ag(path, args) abort " {{{
		if len(a:args) == 0
			let path = a:path
			let query = expand('<cword>')
			let opts = []
		elseif len(a:args) == 1
			let path = a:path
			let query = a:args[0]
			let opts = []
		else
			let path = a:path . '/' . a:args[1]
			let query = a:args[0]
			let opts = a:args[2:-1]
		endif
		execute 'Ack ' . join(map(opts, 'v:val'), ' ') . ' ' . query . ' ' . path
	endfunction " }}}
endfunction " }}}

call s:bundle('Shougo/vimfiler.vim')

call s:bundle('Shougo/vimshell.vim')

call s:bundle('todesking/ttodo.vim')
function! g:todespm#the_hooks.after() abort " {{{
	let &titlestring='[TODO] %{g:todo_current_doing}'
endfunction " }}}

call todespm#end()
