
" Plugs

nnoremap <plug>ExtendedFtRepeatSearchForward :<c-u>call <sid>RepeatSearchForward()<cr>
nnoremap <plug>ExtendedFtRepeatSearchBackward :<c-u>call <sid>RepeatSearchBackward()<cr>
nnoremap <expr> <silent> <plug>ExtendedFtSearchFForward ':<c-u>call <sid>Search("' . <sid>InputChar() . '", "f", "f")<cr>'
nnoremap <expr> <silent> <plug>ExtendedFtSearchFBackward ':<c-u>call <sid>Search("' . <sid>InputChar() . '", "b", "f")<cr>'
nnoremap <expr> <silent> <plug>ExtendedFtSearchTForward ':<c-u>call <sid>Search("' . <sid>InputChar() . '", "f", "t")<cr>'
nnoremap <expr> <silent> <plug>ExtendedFtSearchTBackward ':<c-u>call <sid>Search("' . <sid>InputChar() . '", "b", "t")<cr>'

xnoremap <plug>ExtendedFtVisualModeRepeatSearchForward <esc>:call <sid>RepeatSearchForward()<cr>m>gv
xnoremap <plug>ExtendedFtVisualModeRepeatSearchBackward <esc>:call <sid>RepeatSearchBackward()<cr>m>gv
xnoremap <expr> <silent> <plug>ExtendedFtVisualModeSearchFForward '<esc>:call <sid>Search("'. <sid>InputChar() . '", "f", "f")<cr>m>gv'
xnoremap <expr> <silent> <plug>ExtendedFtVisualModeSearchFBackward '<esc>:call <sid>Search("'. <sid>InputChar() . '", "b", "f")<cr>m>gv'
xnoremap <expr> <silent> <plug>ExtendedFtVisualModeSearchTForward '<esc>:call <sid>Search("'. <sid>InputChar() . '", "f", "t")<cr>m>gv'
xnoremap <expr> <silent> <plug>ExtendedFtVisualModeSearchTBackward '<esc>:call <sid>Search("'. <sid>InputChar() . '", "b", "t")<cr>m>gv'

onoremap <plug>ExtendedFtOperationModeRepeatSearchForward :call <sid>RepeatSearchForward()<cr>
onoremap <plug>ExtendedFtOperationModeRepeatSearchBackward :call <sid>RepeatSearchBackward()<cr>
onoremap <expr> <silent> <plug>ExtendedFtOperationModeSearchFForward ':call <sid>Search("'. <sid>InputChar() . '", "f", "p")<cr>'
onoremap <expr> <silent> <plug>ExtendedFtOperationModeSearchFBackward ':call <sid>Search("'. <sid>InputChar() . '", "b", "f")<cr>'
onoremap <expr> <silent> <plug>ExtendedFtOperationModeSearchTForward ':call <sid>Search("'. <sid>InputChar() . '", "f", "f")<cr>'
onoremap <expr> <silent> <plug>ExtendedFtOperationModeSearchTBackward ':call <sid>Search("'. <sid>InputChar() . '", "b", "p")<cr>'

" Todo: create an option to set all six mappings then remap them
" Mappings
nmap <silent> ; <plug>ExtendedFtRepeatSearchForward
nmap <silent> : <plug>ExtendedFtRepeatSearchBackward
nmap <silent> f <plug>ExtendedFtSearchFForward
nmap <silent> t <plug>ExtendedFtSearchFBackward

" We can get away with using ds and sd since they are both
" motions and unlikely to work with each other anyway
nmap <silent> sd <plug>ExtendedFtSearchTForward
nmap <silent> ds <plug>ExtendedFtSearchTBackward

xmap <silent> ; <plug>ExtendedFtVisualModeRepeatSearchForward
xmap <silent> : <plug>ExtendedFtVisualModeRepeatSearchBackward
xmap <silent> f <plug>ExtendedFtVisualModeSearchFForward
xmap <silent> t <plug>ExtendedFtVisualModeSearchFBackward
xmap <silent> sd <plug>ExtendedFtVisualModeSearchTForward
xmap <silent> ds <plug>ExtendedFtVisualModeSearchTBackward

omap <silent> ; <plug>ExtendedFtOperationModeRepeatSearchForward
omap <silent> : <plug>ExtendedFtOperationModeRepeatSearchBackward
omap <silent> f <plug>ExtendedFtOperationModeSearchFForward
omap <silent> t <plug>ExtendedFtOperationModeSearchFBackward
omap <silent> sd <plug>ExtendedFtOperationModeSearchTForward
omap <silent> ds <plug>ExtendedFtOperationModeSearchTBackward

" Allow cancelling substitutions
nnoremap st<esc> <nop>
nnoremap sf<esc> <nop>
nnoremap sF<esc> <nop>
nnoremap sT<esc> <nop>

" Allow cancelling substitutions
nnoremap mt<esc> <nop>
nnoremap mf<esc> <nop>
nnoremap mF<esc> <nop>
nnoremap mT<esc> <nop>

" Variables
let s:lastSearch = 's'
let s:lastSearchDir = 'f'
let s:lastSearchType = 'f'

function! s:InputChar()
    let char = ave#InputChar()

    if char ==# ''
        return ''
    endif

    return escape(char, '\"')
endfunction

" Functions
function! s:Search(char, dir, type)
    if a:char ==# ''
        return
    endif

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
    elseif a:type ==# 'p'
        let pattern = pattern . '\zs'
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
