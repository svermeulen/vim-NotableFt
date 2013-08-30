
" Plugs

nnoremap <plug>RepeatSearchForward :<c-u>call <sid>RepeatSearchForward()<cr>
nnoremap <plug>RepeatSearchBackward :<c-u>call <sid>RepeatSearchBackward()<cr>
nnoremap <expr> <silent> <plug>SearchFForward ':<c-u>call <sid>Search("' . <sid>InputChar() . '", "f", "f")<cr>'
nnoremap <expr> <silent> <plug>SearchFBackward ':<c-u>call <sid>Search("' . <sid>InputChar() . '", "b", "f")<cr>'
nnoremap <expr> <silent> <plug>SearchTForward ':<c-u>call <sid>Search("' . <sid>InputChar() . '", "f", "t")<cr>'
nnoremap <expr> <silent> <plug>SearchTBackward ':<c-u>call <sid>Search("' . <sid>InputChar() . '", "b", "t")<cr>'

xnoremap <plug>VisualModeRepeatSearchForward <esc>:call <sid>RepeatSearchForward()<cr>m>gv
xnoremap <plug>VisualModeRepeatSearchBackward <esc>:call <sid>RepeatSearchBackward()<cr>m>gv
xnoremap <expr> <silent> <plug>VisualModeSearchFForward '<esc>:call <sid>Search("'. <sid>InputChar() . '", "f", "f")<cr>m>gv'
xnoremap <expr> <silent> <plug>VisualModeSearchFBackward '<esc>:call <sid>Search("'. <sid>InputChar() . '", "b", "f")<cr>m>gv'
xnoremap <expr> <silent> <plug>VisualModeSearchTForward '<esc>:call <sid>Search("'. <sid>InputChar() . '", "f", "t")<cr>m>gv'
xnoremap <expr> <silent> <plug>VisualModeSearchTBackward '<esc>:call <sid>Search("'. <sid>InputChar() . '", "b", "t")<cr>m>gv'

onoremap <plug>OperationModeRepeatSearchForward :call <sid>RepeatSearchForward()<cr>
onoremap <plug>OperationModeRepeatSearchBackward :call <sid>RepeatSearchBackward()<cr>
onoremap <expr> <silent> <plug>OperationModeSearchFForward ':call <sid>Search("'. <sid>InputChar() . '", "f", "p")<cr>'
onoremap <expr> <silent> <plug>OperationModeSearchFBackward ':call <sid>Search("'. <sid>InputChar() . '", "b", "f")<cr>'
onoremap <expr> <silent> <plug>OperationModeSearchTForward ':call <sid>Search("'. <sid>InputChar() . '", "f", "f")<cr>'
onoremap <expr> <silent> <plug>OperationModeSearchTBackward ':call <sid>Search("'. <sid>InputChar() . '", "b", "p")<cr>'

" Todo: create an option to set all six mappings then remap them
" Mappings
nmap <silent> ; <plug>RepeatSearchForward
nmap <silent> : <plug>RepeatSearchBackward
nmap <silent> f <plug>SearchFForward
nmap <silent> t <plug>SearchFBackward
nmap <silent> ) <plug>SearchTForward
nmap <silent> ( <plug>SearchTBackward

xmap <silent> ; <plug>VisualModeRepeatSearchForward
xmap <silent> : <plug>VisualModeRepeatSearchBackward
xmap <silent> f <plug>VisualModeSearchFForward
xmap <silent> t <plug>VisualModeSearchFBackward
xmap <silent> ) <plug>VisualModeSearchTForward
xmap <silent> ( <plug>VisualModeSearchTBackward

omap <silent> ; <plug>OperationModeRepeatSearchForward
omap <silent> : <plug>OperationModeRepeatSearchBackward
omap <silent> f <plug>OperationModeSearchFForward
omap <silent> t <plug>OperationModeSearchFBackward
omap <silent> ) <plug>OperationModeSearchTForward
omap <silent> ( <plug>OperationModeSearchTBackward

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
