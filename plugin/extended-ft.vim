
" Plugs

nnoremap <plug>ExtendedFtRepeatSearchForward :<c-u>call <sid>RepeatSearchForward(v:count, 'n')<cr>
nnoremap <plug>ExtendedFtRepeatSearchBackward :<c-u>call <sid>RepeatSearchBackward(v:count)<cr>
nnoremap <expr> <silent> <plug>ExtendedFtSearchFForward ':<c-u>call <sid>Search('. v:count . ', "' . <sid>InputChar() . '", "f", "f")<cr>'
nnoremap <expr> <silent> <plug>ExtendedFtSearchFBackward ':<c-u>call <sid>Search('. v:count . ', "' . <sid>InputChar() . '", "b", "f")<cr>'
nnoremap <expr> <silent> <plug>ExtendedFtSearchTForward ':<c-u>call <sid>Search('. v:count . ', "' . <sid>InputChar() . '", "f", "t")<cr>'
nnoremap <expr> <silent> <plug>ExtendedFtSearchTBackward ':<c-u>call <sid>Search('. v:count . ', "' . <sid>InputChar() . '", "b", "t")<cr>'

xnoremap <expr> <plug>ExtendedFtVisualModeRepeatSearchForward '<esc>:<c-u>call <sid>RepeatSearchForward('. v:count . ', "x")<cr>m>gv'
xnoremap <expr> <plug>ExtendedFtVisualModeRepeatSearchBackward '<esc>:<c-u>call <sid>RepeatSearchBackward('. v:count . ')<cr>m>gv'
xnoremap <expr> <silent> <plug>ExtendedFtVisualModeSearchFForward ':<c-u>call <sid>Search('. v:count . ', "'. <sid>InputChar() . '", "f", "f")<cr>m>gv'
xnoremap <expr> <silent> <plug>ExtendedFtVisualModeSearchFBackward ':<c-u>call <sid>Search('. v:count . ', "'. <sid>InputChar() . '", "b", "f")<cr>m>gv'
xnoremap <expr> <silent> <plug>ExtendedFtVisualModeSearchTForward ':<c-u>call <sid>Search('. v:count . ', "'. <sid>InputChar() . '", "f", "t")<cr>m>gv'
xnoremap <expr> <silent> <plug>ExtendedFtVisualModeSearchTBackward ':<c-u>call <sid>Search('. v:count . ', "'. <sid>InputChar() . '", "b", "t")<cr>m>gv'

onoremap <plug>ExtendedFtOperationModeRepeatSearchForward :call <sid>RepeatSearchForward(v:count, 'o')<cr>
onoremap <plug>ExtendedFtOperationModeRepeatSearchBackward :call <sid>RepeatSearchBackward(v:count)<cr>
onoremap <expr> <silent> <plug>ExtendedFtOperationModeSearchFForward ':call <sid>Search('. v:count . ', "'. <sid>InputChar() . '", "f", "p")<cr>'
onoremap <expr> <silent> <plug>ExtendedFtOperationModeSearchFBackward ':call <sid>Search('. v:count . ', "'. <sid>InputChar() . '", "b", "f")<cr>'
onoremap <expr> <silent> <plug>ExtendedFtOperationModeSearchTForward ':call <sid>Search('. v:count . ', "'. <sid>InputChar() . '", "f", "f")<cr>'
onoremap <expr> <silent> <plug>ExtendedFtOperationModeSearchTBackward ':call <sid>Search('. v:count . ', "'. <sid>InputChar() . '", "b", "p")<cr>'

" Variables
let s:lastSearch = ''
let s:lastSearchDir = 'f'
let s:lastSearchType = 'f'

function! s:InputChar()
    let char = nr2char(getchar())

    if char ==# ''
        return ''
    endif

    return escape(char, '\"')
endfunction

" Functions
function! s:Search(count, char, dir, type)
    if a:char ==# ''
        return
    endif

    call s:RunSearch(a:count, a:char, a:dir, a:type)
    let s:lastSearch = a:char
    let s:lastSearchDir = a:dir
    let s:lastSearchType = a:type
endfunction

function! s:RunSearch(count, searchStr, dir, type)
    if !exists('g:ExtendedFT_caseOption')
        let caseOption = (a:searchStr =~# '\v\u') ? '\C' : '\c'
    else
        let caseOption = g:ExtendedFT_caseOption
    endif

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

    let cnt = a:count > 0 ? a:count : 1

    for i in range(cnt)
        let lineNo = search('\V' . pattern, options . 'n')

        " Only add to jumplist if we're changing line
        if lineNo != line(".")
            normal! m`
        endif

        call search('\V' . pattern, options)
    endfor
endfunction

function! s:RepeatSearchForward(count, mode)
    if empty(s:lastSearch)
        echo 'Nothing to repeat'
    else
        call s:RunSearch(a:count, s:lastSearch, s:lastSearchDir, s:lastSearchType)

        if a:mode ==# 'o' && s:lastSearchDir ==# 'f'
            " Not 100% sure why this is necessary in this case but it is
            normal! l
        endif
    endif
endfunction

function! s:RepeatSearchBackward(count)
    if empty(s:lastSearch)
        echo 'Nothing to repeat'
    else
        call s:RunSearch(a:count, s:lastSearch, (s:lastSearchDir == 'f') ? 'b' : 'f', s:lastSearchType)
    endif
endfunction

if !exists('g:ExtendedFTUseDefaults') || g:ExtendedFTUseDefaults
    nmap <silent> ; <plug>ExtendedFtRepeatSearchForward
    nmap <silent> , <plug>ExtendedFtRepeatSearchBackward
    nmap <silent> f <plug>ExtendedFtSearchFForward
    nmap <silent> F <plug>ExtendedFtSearchFBackward
    nmap <silent> t <plug>ExtendedFtSearchTForward
    nmap <silent> T <plug>ExtendedFtSearchTBackward

    xmap <silent> ; <plug>ExtendedFtVisualModeRepeatSearchForward
    xmap <silent> , <plug>ExtendedFtVisualModeRepeatSearchBackward
    xmap <silent> f <plug>ExtendedFtVisualModeSearchFForward
    xmap <silent> F <plug>ExtendedFtVisualModeSearchFBackward
    xmap <silent> t <plug>ExtendedFtVisualModeSearchTForward
    xmap <silent> T <plug>ExtendedFtVisualModeSearchTBackward

    omap <silent> ; <plug>ExtendedFtOperationModeRepeatSearchForward
    omap <silent> , <plug>ExtendedFtOperationModeRepeatSearchBackward
    omap <silent> f <plug>ExtendedFtOperationModeSearchFForward
    omap <silent> F <plug>ExtendedFtOperationModeSearchFBackward
    omap <silent> t <plug>ExtendedFtOperationModeSearchTForward
    omap <silent> T <plug>ExtendedFtOperationModeSearchTBackward
endif
