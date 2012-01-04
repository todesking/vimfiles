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

set tags+=./tags,../tags,../../tags,../../../tags,../../../../tags

if(has('gui'))
	set noballooneval
	set guifont=Osaka-Mono:h18
	set guioptions=erL
endif


" keymap
nnoremap <silent>,n :tabnew<CR>
nnoremap <silent>,h :tabprevious<CR>
nnoremap <silent>,l :tabnext<CR>

nnoremap <silent>,bd :bdelete<CR>

inoremap <silent><C-L> <C-X><C-L>

function! s:register_jump_key(key)
	exec 'nnoremap' '<silent>'.a:key
				\ a:key.':call <SID>auto_cursorline(''CursorHold'')<CR>zo'
endfunction

call s:register_jump_key('n')
call s:register_jump_key('N')
call s:register_jump_key('*')
call s:register_jump_key('#')
call s:register_jump_key('g*')
call s:register_jump_key('g#')
call s:register_jump_key('{')
call s:register_jump_key('}')
call s:register_jump_key('<C-I>')
call s:register_jump_key('<C-O>')
call s:register_jump_key('zz')
call s:register_jump_key('H')
call s:register_jump_key('M')
call s:register_jump_key('L')
" call s:register_jump_key('<C-T>')
" call s:register_jump_key('<C-]>')

nnoremap <silent>_ :let &hlsearch=!&hlsearch<CR>
nnoremap <silent><C-S> :Unite buffer file_mru<CR>

nnoremap <silent>,ut :Unite tag<CR>
nnoremap <silent>,uo :Unite outline<CR>
nnoremap <silent>,ub :Unite buffer<CR>

nmap <silent> ,p <Plug>ToggleProject

" C-] to unite-tag
autocmd BufEnter *
			\   if empty(&buftype)
			\|      nnoremap <buffer> <C-]> :<C-u>UniteWithCursorWord -immediately tag<CR>
			\|  endif

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
	autocmd FileType unite imap <buffer><silent><Esc> <ESC>q
augroup END

"statusline
let &statusline = '%< %F%=%m%y%{"[".(&fenc!=""?&fenc:&enc).",".&ff."]"}[%{GetB()}] %3l,%3c %3p%%'
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


" normalでしばらく放置するとcursorline
augroup vimrc-auto-cursorline
  autocmd!
  autocmd CursorMoved * call s:auto_cursorline('CursorMoved')
  autocmd CursorHold * call s:auto_cursorline('CursorHold')
  autocmd WinEnter * call s:auto_cursorline('WinEnter')
  autocmd WinLeave * call s:auto_cursorline('WinLeave')

  let s:cursorline_lock = 0
  function! s:auto_cursorline(event)
    if a:event ==# 'WinEnter'
      setlocal cursorline
      let s:cursorline_lock = 2
    elseif a:event ==# 'WinLeave'
      setlocal nocursorline
    elseif a:event ==# 'CursorMoved'
      if s:cursorline_lock
        if 1 < s:cursorline_lock
          let s:cursorline_lock = 1
        else
          setlocal nocursorline
          let s:cursorline_lock = 0
        endif
      endif
    elseif a:event ==# 'CursorHold'
      setlocal cursorline
      let s:cursorline_lock = 1
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
