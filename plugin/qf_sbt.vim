" Dependencies: vimproc, current_project.vim

" {project_dir: sbt_proc}
if !exists('s:procs')
	let s:procs = {}
endif

augroup qf_sbt
	autocmd!
	autocmd QuitPre * call SbtQuitAll()
augroup END

function! SbtQuitAll() abort " {{{
	for path in keys(s:procs)
		call s:procs[path].kill()
		call remove(s:procs, path)
	endfor
endfunction " }}}

function! SbtStart() abort " {{{
	let info = CurrentProjectInfo()
	let proc = s:getProc()
	if s:is_valid(proc)
		echo "sbt already started"
		return
	endif

	execute 'lcd ' . info.path
	let proc = s:CProc.new(['sbt', '-J-Dsbt.log.format=false', '~compile'])
	let s:procs[info.path] = proc
	lcd -
endfunction " }}}

function! SbtStop() abort " {{{
	let proc = s:getProc()
	if !s:is_valid(proc)
		echo "sbt already stopped"
		return
	endif

	call proc.kill()
endfunction " }}}

function! SbtUpdateState() abort " {{{
	let proc = s:getProc()
	if !s:is_valid(proc)
		return
	endif
	call proc.update()
	return proc.last_compile_events
endfunction " }}}

function! s:getProc() abort " {{{
	let info = CurrentProjectInfo()
	return get(s:procs, info.path, {})
endfunction " }}}

" Class system
function! s:new_instance(proto, data) abort " {{{
	for name in keys(a:proto)
		let a:data[name] = a:proto[name]
	endfor
	return a:data
endfunction " }}}

function! s:default_initialize(...) dict abort " {{{
endfunction " }}}

function! s:new(...) dict abort " {{{
	let instance = s:new_instance(self, {})
	call call(self.initialize, a:000, instance)
	return instance
endfunction " }}}

function! s:new_class() abort " {{{
	return {'new': function('s:new'), 'initialize': function('s:default_initialize')}
endfunction " }}}
" }}}

" Class Proc {{{
	let s:CProc = s:new_class()
	function! s:CProc.initialize(cmd) dict abort " {{{
		let self.proc = vimproc#popen2(a:cmd)
		let self.last_compile_events = []
		let self._buf = []
		let self._ongoing_events = []
		let self._state = 'idle'
	endfunction " }}}
	function! s:CProc.is_valid() dict abort " {{{
		return self.proc.is_valid
	endfunction " }}}
	function! s:CProc.kill() dict abort " {{{
		if self.is_valid()
			call self.proc.kill()
		endif
	endfunction " }}}
	function! s:CProc.update() dict abort " {{{
		for l in self.proc.stdout.read_lines()
			if self._state == 'idle'
				if l ==# '^\v\[info\] Compiling '
					let self._state = 'compile'
				endif
			elseif self._state == 'compile'
				if l ==# '\v^\[(success|error)\] Total time\:.*completed.*'
					let self.last_compile_events = self.s:build_compile_events(self._buf)
					let self._buf = []
				else
					call add(self._buf, l)
				endif
			endif
		endfor
	endfunction " }}}
" }}}

function! s:is_valid(proc) abort " {{{
	return !empty(a:proc) && a:proc.is_valid()
endfunction " }}}

function! s:build_compile_events(lines) abort " {{{
	let result = []
	let cur = {}
	for l in a:lines
		if l =~ '\v (error|warning)s? found$'
			continue
		endif
		let m = matchlist(l, '^\v\[(error|warn)\] (.*\.%(java|scala)):([0-9]+):(.*)')
		if !empty(m)
			" start of error/warn
			if !empty(cur)
				call add(result, cur)
			endif
			let cur = {'path': m[2], 'line': str2nr(m[3]), 'message': [m[4]]}
		elseif has_key(cur, 'path')
			" error/warn message
			call add(cur.message, substitute(l, '\v^\[(error|warn)\] ', '', 'g'))
		else
			" do nothing
		endif
	endfor
	if get(cur, 'path', '') != ''
		call add(result, cur)
	endif
	return result
endfunction " }}}

function! Test() abort " {{{
	return s:build_compile_result([
	\ "3. Waiting for source changes... (press enter to interrupt)",
	\ "[info] Compiling 4 Scala sources to /Users/ariyamizutani/projects/async_task_pipeline/target/scala-2.10/classes...",
	\ "[warn] /Users/ariyamizutani/projects/async_task_pipeline/src-main-scala/impl.scala:127: postfix operator toString should be enabled",
	\ "[warn] by making the implicit value scala.language.postfixOps visible.",
	\ "[warn] This can be achieved by adding the import clause 'import scala.language.postfixOps'",
	\ "[warn] or by setting the compiler option -language:postfixOps.",
	\ "[warn] See the Scala docs for value scala.language.postfixOps for a discussion",
	\ "[warn] why the feature should be explicitly enabled.",
	\ "[warn]   threadPoolConfig toString",
	\ "[warn]                    ^",
	\ "[warn] one warning found",
	\ ])
endfunction " }}}
