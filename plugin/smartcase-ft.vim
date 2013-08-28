
" Plugs
nnoremap <expr> <silent> <plug>SearchFForward ':<c-u>call <sid>Search("' . <sid>InputChar() . '", "f", "f")<cr>'
nnoremap <expr> <silent> <plug>SearchFBackward ':<c-u>call <sid>Search("' . <sid>InputChar() . '", "b", "f")<cr>'

nnoremap <expr> <silent> <plug>SearchTForward ':<c-u>call <sid>Search("' . <sid>InputChar() . '", "f", "t")<cr>'
nnoremap <expr> <silent> <plug>SearchTBackward ':<c-u>call <sid>Search("' . <sid>InputChar() . '", "b", "t")<cr>'

nnoremap <plug>RepeatSearchForward :<c-u>call <sid>RepeatSearchForward()<cr>
nnoremap <plug>RepeatSearchBackward :<c-u>call <sid>RepeatSearchBackward()<cr>

xnoremap <plug>VisualModeRepeatSearchForward <esc>:call <sid>RepeatSearchForward()<cr>m>gv
xnoremap <plug>VisualModeRepeatSearchBackward <esc>:call <sid>RepeatSearchBackward()<cr>m>gv

xnoremap <expr> <silent> <plug>VisualModeSearchFForward '<esc>:call <sid>Search("'. <sid>InputChar() . '", "f", "f")<cr>m>gv'
xnoremap <expr> <silent> <plug>VisualModeSearchFBackward '<esc>:call <sid>Search("'. <sid>InputChar() . '", "b", "f")<cr>m>gv'
xnoremap <expr> <silent> <plug>VisualModeSearchTForward '<esc>:call <sid>Search("'. <sid>InputChar() . '", "f", "t")<cr>m>gv'
xnoremap <expr> <silent> <plug>VisualModeSearchTBackward '<esc>:call <sid>Search("'. <sid>InputChar() . '", "b", "t")<cr>m>gv'

" Mappings
nmap <silent> ; <plug>RepeatSearchForward
nmap <silent> : <plug>RepeatSearchBackward
nmap <silent> f <plug>SearchFForward
nmap <silent> F <plug>SearchFBackward
nmap <silent> t <plug>SearchTForward
nmap <silent> T <plug>SearchTBackward

xmap <silent> ; <plug>VisualModeRepeatSearchForward
xmap <silent> : <plug>VisualModeRepeatSearchBackward
xmap <silent> f <plug>VisualModeSearchFForward
xmap <silent> F <plug>VisualModeSearchFBackward
xmap <silent> t <plug>VisualModeSearchTForward
xmap <silent> T <plug>VisualModeSearchTBackward

" Variables
let s:lastSearch = 's'
let s:lastSearchDir = 'f'
let s:lastSearchType = 'f'

function! s:InputChar()
    let char = ave#InputChar()
    return escape(char, '"')
endfunction

" Functions
function! s:Search(char, dir, type)
    call s:RunSearch(a:char, a:dir, a:type)
    let s:lastSearch = a:char
    let s:lastSearchDir = a:dir
    let s:lastSearchType = a:type
endfunction

function! s:RunSearch(searchStr, dir, type)
    let caseOption = (a:searchStr =~# '\v\u') ? '\C' : '\c'
    let options = (a:dir ==# 'f') ? 'W' : 'Wb'

    let pattern = caseOption . a:searchStr

    if a:type ==# 't'
        if a:dir ==# 'f'
            let pattern = '\.' . pattern
        else
            let pattern = pattern . '\zs'
        endif
    endif

    let lineNo = search('\V' . pattern, options . 'n')

    " Only add to jumplist if we're changing line
    if lineNo != line(".")
        normal! m`
    endif

    call search('\V' . pattern, options)
endfunction

function! s:RepeatSearchForward()
    call s:RunSearch(s:lastSearch, s:lastSearchDir, s:lastSearchType)
endfunction

function! s:RepeatSearchBackward()
    call s:RunSearch(s:lastSearch, (s:lastSearchDir == 'f') ? 'b' : 'f', s:lastSearchType)
endfunction
