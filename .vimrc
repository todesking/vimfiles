call pathogen#runtime_append_all_bundles()

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

" abbrev
augroup vimrc-ft-erb
	autocmd!
	autocmd FileType eruby iabbrev {{ <%
	autocmd FileType eruby iabbrev }} %>
augroup END

" keymap
nnoremap <silent>,n :tabnew<CR>
nnoremap <silent>,h :tabprevious<CR>
nnoremap <silent>,l :tabnext<CR>

nnoremap <silent>,bd :bdelete<CR>

inoremap <silent><C-L> <C-X><C-L>

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
nnoremap <silent><C-S> :Unite buffer file_mru<CR>

nnoremap <silent>,ut :Unite tag<CR>
nnoremap <silent>,uf :Unite file_rec<CR>
nnoremap <silent>,uo :Unite outline -no-start-insert<CR>
nnoremap <silent>,ub :Unite buffer<CR>
nnoremap <silent>,u <ESC>

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

nnoremap <silent>,f :call <SID>toggle_fold_column()<CR>
function! s:toggle_fold_column()
	if &foldcolumn == 0
		let &foldcolumn=s:foldcolumn_default
	else
		let &foldcolumn=0
	endif
endfunction

" Don't screw up folds when inserting text that might affect them, until
" leaving insert mode. Foldmethod is local to the window. Protect against
" screwing up folding when switching between windows.
autocmd InsertEnter * if !exists('w:last_fdm') | let w:last_fdm=&foldmethod | setlocal foldmethod=manual | endif
autocmd InsertLeave,WinLeave * if exists('w:last_fdm') | let &l:foldmethod=w:last_fdm | unlet w:last_fdm | endif

augroup vimrc-lazy-folding
	autocmd FileType ruby set foldmethod=syntax | set foldmethod=manual
augroup END


" indent-guides
let g:indent_guides_start_level=2
let g:indent_guides_guide_size=1
let g:indent_guides_level_per_guide=2

" C-] to unite-tag
autocmd BufEnter *
			\   if empty(&buftype)
			\|      nnoremap <buffer> <C-]> :<C-u>UniteWithCursorWord -immediately tag<CR>
			\|  endif

nnoremap <C-Q>  <ESC>
nnoremap <C-Q>o :<C-u>Unite outline<CR>
nnoremap <C-Q>p :<C-u>exec 'Unite file_rec:'.b:rails_root<CR>
nnoremap <C-Q>t :<C-u>Unite tag<CR>
nnoremap <C-Q>f :<C-u>Unite qf -no-start-insert -auto-preview<CR>
nnoremap <C-Q>r <ESC>
nnoremap <C-Q>rm :<C-u>Unite rails/model<CR>
nnoremap <C-Q>rc :<C-u>Unite rails/controller<CR>
nnoremap <C-Q>rv :<C-u>Unite rails/view<CR>
" unite-neco
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

" neocomplcache
if !exists('g:neocomplcache_omni_patterns')
	let g:neocomplcache_omni_patterns = {}
endif
let g:neocomplcache_omni_patterns.ruby = '[^. *\t]\.\h\w*\|\h\w*::'

" unite
let g:unite_enable_start_insert = 1
let g:unite_update_time = 100
augroup unite-keybind
	autocmd!
	autocmd FileType unite nmap <buffer><silent><Esc> q
	autocmd FileType unite NeoComplCacheLock
augroup END

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

call unite#custom_filters('tag',['matcher_glob', 'sorter_nothing', 'converter_tag'])

let g:unite_source_file_mru_limit=300

" yankring
let g:yankring_max_element_length = 1000*10 " 4M

" align
let g:Align_xstrlen=3

"statusline
let &statusline =
			\  '%{VimBuddy()} '
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


" しばらく放置/よそから復帰したときのフック
function! s:hello_again_enter()
	setlocal cursorline
	redraw
	let status_line_width=winwidth(0)
	echo printf('%'.status_line_width.'.'.status_line_width.'s',<SID>fold_navi())
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
  function! s:hello_again_hook(event)
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

" http://vim-users.jp/2011/02/hack202/
" 保存時にディレクトリ作成
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

