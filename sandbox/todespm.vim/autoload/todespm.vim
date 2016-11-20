" [[type, hooks]]
" type:
"   {type: "bundle", name: "", args: []}
"   {type: "hooks", name: ""}
let s:plugins = []

function! todespm#engine(name) abort " {{{
	return call('todespm#engine#' . a:name . '#get', [])
endfunction " }}}

function! todespm#current() abort " {{{
	return todespm#engine(g:todespm#engine)
endfunction " }}}

function! todespm#begin() abort " {{{
	let s:plugins = []
	call todespm#current().begin()
endfunction " }}}

function! todespm#end() abort " {{{
	call todespm#current().end()
	call todespm#run_after_hooks()
endfunction " }}}

function! todespm#enabled(name) abort " {{{
	return todespm#current().enabled(a:name)
endfunction " }}}

function! todespm#bundle(name, ...) abort " {{{
	let hooks = {}
	let g:todespm#the_hooks = hooks
	let type = {"type": "bundle", "name": a:name, "hooks": hooks}
	if a:0 == 0
		let type.args = []
	elseif a:0 == 1
		let type.args = a:000
	else
		throw 's:bundle: invalid options' . string(a:000)
	endif
	call add(s:plugins, type)
endfunction " }}}

function! todespm#new_hooks(name) abort " {{{
	let hooks = {}
	call add(s:plugins, {"type": "hooks", "name": a:name, "hooks": hooks})
	let g:todespm#the_hooks = hooks
endfunction " }}}

function! todespm#run_after_hooks() abort " {{{
	call todespm#current().begin()
	for p in s:plugins
		if p.type == "bundle"
			call todespm#current().bundle(p.name, p.args)
		endif
	endfor
	call todespm#current().end()

	for p in s:plugins
		if todespm#current().enabled(p.name) && has_key(p.hooks, 'after')
			let m = ''
			try
				call p.hooks.after()
			catch /.*/
				let m = 'Error in setting ' . p.name . ': ' . v:exception
			endtry
			if !empty(m)
				echoerr m
			endif
		endif
	endfor
endfunction " }}}
