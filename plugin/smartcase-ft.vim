
" Plugs
nnoremap <expr> <plug>SearchForward ':<c-u>call <sid>Search("' . ave#InputChar() . '", "f")<cr>'
nnoremap <expr> <plug>SearchBackward ':<c-u>call <sid>Search("' . ave#InputChar() . '", "b")<cr>'

nnoremap <plug>RepeatSearchForward :<c-u>call <sid>RepeatSearchForward()<cr>
nnoremap <plug>RepeatSearchBackward :<c-u>call <sid>RepeatSearchBackward()<cr>

xnoremap <plug>VisualModeRepeatSearchForward <esc>:call <sid>RepeatSearchForward()<cr>m>gv
xnoremap <plug>VisualModeRepeatSearchBackward <esc>:call <sid>RepeatSearchBackward()<cr>m>gv

xnoremap <expr> <plug>VisualModeSearchForward '<esc>:call <sid>Search("'. ave#InputChar() . '", "f")<cr>m>gv'
xnoremap <expr> <plug>VisualModeSearchBackward '<esc>:call <sid>Search("'. ave#InputChar() . '", "b")<cr>m>gv'

" Mappings
nmap ; <plug>RepeatSearchForward
nmap : <plug>RepeatSearchBackward
nmap f <plug>SearchForward
nmap F <plug>SearchBackward

xmap ; <plug>VisualModeRepeatSearchForward
xmap : <plug>VisualModeRepeatSearchBackward
xmap f <plug>VisualModeSearchForward
xmap F <plug>VisualModeSearchBackward

" Variables
let s:lastSearch = 's'
let s:lastSearchDir = 'f'

" Functions
function! s:Search(char, dir)
    call s:RunSearch(a:char, a:dir)
    let s:lastSearch = a:char
    let s:lastSearchDir = a:dir
endfunction

function! s:RunSearch(searchStr, dir)
    let caseOption = (a:searchStr =~# '\v\u') ? '\C' : '\c'
    let options = (a:dir ==# 'f') ? 'W' : 'Wb'

    call search('\V' . caseOption . a:searchStr, options)
endfunction

function! s:RepeatSearchForward()
    call s:RunSearch(s:lastSearch, s:lastSearchDir)
endfunction

function! s:RepeatSearchBackward()
    call s:RunSearch(s:lastSearch, (s:lastSearchDir == 'f') ? 'b' : 'f')
endfunction
