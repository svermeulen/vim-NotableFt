
"""""""""""""""""""""""
" Variables
"""""""""""""""""""""""
let s:lastSearch = ''
let s:lastSearchType = 'f'
let s:lastSearchDir = 'f'

"""""""""""""""""""""""
" Plugs
"""""""""""""""""""""""

nnoremap <plug>NotableFtForceEnableHighlight :call <sid>EnableHighlight()<cr>

nnoremap <plug>NotableFtRepeatSearchForward :<c-u>call <sid>RepeatSearchForward(v:count, 'n')<cr>
nnoremap <plug>NotableFtRepeatSearchBackward :<c-u>call <sid>RepeatSearchBackward(v:count, 'n')<cr>

nnoremap <plug>NotableFtRepeatSearchCenterForward :<c-u>call <sid>RepeatSearchForward(v:count, 'n')<cr>zz
nnoremap <plug>NotableFtRepeatSearchCenterBackward :<c-u>call <sid>RepeatSearchBackward(v:count, 'n')<cr>zz

nnoremap <expr> <silent> <plug>NotableFtSearchFForward ':<c-u>call <sid>Search('. v:count . ', "' . <sid>InputChar() . '", "f", "f", "n")<cr>'
nnoremap <expr> <silent> <plug>NotableFtSearchFBackward ':<c-u>call <sid>Search('. v:count . ', "' . <sid>InputChar() . '", "b", "f", "n")<cr>'
nnoremap <expr> <silent> <plug>NotableFtSearchTForward ':<c-u>call <sid>Search('. v:count . ', "' . <sid>InputChar() . '", "f", "t", "n")<cr>'
nnoremap <expr> <silent> <plug>NotableFtSearchTBackward ':<c-u>call <sid>Search('. v:count . ', "' . <sid>InputChar() . '", "b", "t", "n")<cr>'

xnoremap <expr> <plug>NotableFtRepeatSearchForward '<esc>:<c-u>call <sid>RepeatSearchForward('. v:count . ', "x")<cr>m>gv'
xnoremap <expr> <plug>NotableFtRepeatSearchBackward '<esc>:<c-u>call <sid>RepeatSearchBackward('. v:count . ', "x")<cr>m>gv'

xnoremap <expr> <silent> <plug>NotableFtSearchFForward '<esc>`>:<c-u>call <sid>Search('. v:count . ', "'. <sid>InputChar() . '", "f", "f", "x")<cr>m>gv'
xnoremap <expr> <silent> <plug>NotableFtSearchFBackward '<esc>:<c-u>call <sid>Search('. v:count . ', "'. <sid>InputChar() . '", "b", "f", "x")<cr>m>gv'
xnoremap <expr> <silent> <plug>NotableFtSearchTForward ':<c-u>call <sid>Search('. v:count . ', "'. <sid>InputChar() . '", "f", "t", "x")<cr>m>gv'
xnoremap <expr> <silent> <plug>NotableFtSearchTBackward '<esc>:<c-u>call <sid>Search('. v:count . ', "'. <sid>InputChar() . '", "b", "t", "x")<cr>m>gv'

onoremap <plug>NotableFtRepeatSearchForward :call <sid>RepeatSearchForward(v:count, 'o')<cr>
onoremap <plug>NotableFtRepeatSearchBackward :call <sid>RepeatSearchBackward(v:count, 'o')<cr>

onoremap <expr> <silent> <plug>NotableFtSearchFForward ':call <sid>Search('. v:count . ', "'. <sid>InputChar() . '", "f", "p", "o")<cr>'
onoremap <expr> <silent> <plug>NotableFtSearchFBackward ':call <sid>Search('. v:count . ', "'. <sid>InputChar() . '", "b", "f", "o")<cr>'
onoremap <expr> <silent> <plug>NotableFtSearchTForward ':call <sid>Search('. v:count . ', "'. <sid>InputChar() . '", "f", "f", "o")<cr>'
onoremap <expr> <silent> <plug>NotableFtSearchTBackward ':call <sid>Search('. v:count . ', "'. <sid>InputChar() . '", "b", "p", "o")<cr>'

"""""""""""""""""""""""
" Mappings
"""""""""""""""""""""""
if !exists('g:NotableFtUseDefaults') || g:NotableFtUseDefaults
    nmap <silent> ; <plug>NotableFtRepeatSearchForward
    nmap <silent> , <plug>NotableFtRepeatSearchBackward
    nmap <silent> f <plug>NotableFtSearchFForward
    nmap <silent> F <plug>NotableFtSearchFBackward
    nmap <silent> t <plug>NotableFtSearchTForward
    nmap <silent> T <plug>NotableFtSearchTBackward

    xmap <silent> ; <plug>NotableFtRepeatSearchForward
    xmap <silent> , <plug>NotableFtRepeatSearchBackward
    xmap <silent> f <plug>NotableFtSearchFForward
    xmap <silent> F <plug>NotableFtSearchFBackward
    xmap <silent> t <plug>NotableFtSearchTForward
    xmap <silent> T <plug>NotableFtSearchTBackward

    omap <silent> ; <plug>NotableFtRepeatSearchForward
    omap <silent> , <plug>NotableFtRepeatSearchBackward
    omap <silent> f <plug>NotableFtSearchFForward
    omap <silent> F <plug>NotableFtSearchFBackward
    omap <silent> t <plug>NotableFtSearchTForward
    omap <silent> T <plug>NotableFtSearchTBackward
endif

"""""""""""""""""""""""
" Functions
"""""""""""""""""""""""

function! s:AttachSearchToggleAutoCommands()
    augroup SearchTypeToggle
        autocmd!
        autocmd InsertEnter,WinLeave,BufLeave <buffer> autocmd! SearchTypeToggle * <buffer>
        "set up *nested* CursorMoved autocmd to skip the _first_ CursorMoved event.
        autocmd CursorMoved <buffer> autocmd SearchTypeToggle CursorMoved <buffer> autocmd! SearchTypeToggle * <buffer>
    augroup END
endfunction

function! s:InputChar()
    let charNr = getchar()
    let char = nr2char(charNr)

    if char == ''
        return ''
    endif

    return escape(char, '\"')
endfunction

function! s:RemoveHighlight()
    if w:charHighlightId != -1
        silent! call matchdelete(w:charHighlightId)
    endif
    let w:charHighlightId = -1
endfunction

function! s:AttachAutoCommands()
    augroup NotableFtHighlight
        autocmd!
        autocmd InsertEnter,WinLeave,BufLeave <buffer> call <sid>RemoveHighlight() | autocmd! NotableFtHighlight * <buffer>
        autocmd CursorMoved <buffer> autocmd NotableFtHighlight CursorMoved <buffer> call <sid>RemoveHighlight() | autocmd! NotableFtHighlight * <buffer>
    augroup END
endfunction

function! s:Assert(cond)
    if !a:cond
        throw "AssertException in NotableFt"
    endif
endfunction

function! s:Search(count, char, dir, type, mode)
    call s:Assert(a:mode == 'n' || a:mode == 'x' || a:mode == 'o')

    if a:char ==# ''
        return
    endif

    let s:lastSearch = a:char
    let s:lastSearchType = a:type
    let s:lastSearchDir = a:dir

    call s:RunSearch(a:count, a:char, a:dir, a:type, 1, a:mode)

    if a:type ==# 'p' && a:mode ==# 'o'
        " Not 100% sure why this is necessary in this case but it is
        normal! l
    endif
endfunction

function! s:GetPatternFromInput(searchStr, type, forHighlight)

    let nonWordChar = '\(\W\|_\)'
    let bolOrNonWordChar = '\(' . nonWordChar . '\|\^\)' 
    let uppercaseChar = '\[A-Z]'
    let eolOrNonWordOrUpperCaseChar = '\(' . nonWordChar . '\|\$\|\[A-Z]\)' 

    if a:searchStr ==# ','
        let searchStr = '\(,\|<\)'

    elseif a:searchStr ==# '.'
        let searchStr = '\(.\|>\)'

    elseif a:searchStr ==# '`'
        let searchStr = '\(`\|~\)'

    elseif a:searchStr ==# '1'
        let searchStr = '\(1\|!\)'

    elseif a:searchStr ==# '2'
        let searchStr = '\(2\|@\)'

    elseif a:searchStr ==# '3'
        let searchStr = '\(3\|#\)'

    elseif a:searchStr ==# '4'
        let searchStr = '\(4\|$\)'

    elseif a:searchStr ==# '5'
        let searchStr = '\(5\|%\)'

    elseif a:searchStr ==# '6'
        let searchStr = '\(6\|^\)'

    elseif a:searchStr ==# '7'
        let searchStr = '\(7\|&\)'

    elseif a:searchStr ==# '8'
        let searchStr = '\(8\|*\)'

    elseif a:searchStr ==# '9'
        let searchStr = '\(9\|(\)'

    elseif a:searchStr ==# '0'
        let searchStr = '\(0\|)\)'

    elseif a:searchStr ==# '='
        let searchStr = '\(=\|+\)'

    elseif a:searchStr ==# '['
        let searchStr = '\([\|{\)'

    elseif a:searchStr ==# ']'
        let searchStr = '\(]\|}\)'

    elseif a:searchStr ==# '\'
        let searchStr = '\(\\\||\)'

    elseif a:searchStr ==# '/'
        let searchStr = '\(/\|?\)'

    elseif a:searchStr ==# '-'
        let searchStr = '\(-\|_\)'

    elseif a:searchStr ==# ';'
        let searchStr = '\(;\|:\)'

    elseif a:searchStr ==# "'"
        let searchStr = '\(''\|"\)'

    else
        let searchStr = a:searchStr
    endif

    if searchStr =~# '\v[A-Z]'
        if a:type ==# 'f' || a:type ==# 'p' || a:forHighlight
            return '\c' . tolower(searchStr)
        else
            if s:lastSearchDir == 'f'
                return '\c\zs\.' . tolower(searchStr)
            else
                return '\c' . tolower(searchStr) . '\zs\.'
            endif
        endif
    else
        if a:type ==# 'f' || a:type ==# 'p'
            return '\C\(' . searchStr . '\ze' . eolOrNonWordOrUpperCaseChar . '\|' . bolOrNonWordChar . '\zs' . searchStr . '\|' . toupper(searchStr) . '\)'
        else
            if s:lastSearchDir == 'f'
                if a:forHighlight
                    return '\C\(' . nonWordChar . '\zs' . searchStr . '\|\.\zs'. searchStr . '\ze' . eolOrNonWordOrUpperCaseChar . '\|\.\zs' . toupper(searchStr) . '\)'
                else
                    return '\C\(' . nonWordChar . searchStr . '\|\.'. searchStr . '\ze' . eolOrNonWordOrUpperCaseChar . '\|\.' . toupper(searchStr) . '\)'
                endif
            else
                call s:Assert(s:lastSearchDir ==# 'b')

                if a:forHighlight
                    return '\C\(' . bolOrNonWordChar . '\zs' . searchStr . '\|\.\zs'. searchStr . '\ze' . eolOrNonWordOrUpperCaseChar . '\|\.\zs' . toupper(searchStr) . '\)'
                else
                    return '\C\(' . bolOrNonWordChar . searchStr . '\zs\|\.'. searchStr . '\zs' . eolOrNonWordOrUpperCaseChar . '\|\.' . toupper(searchStr) . '\zs\)'
                endif
            endif
        endif
    endif

    return searchStr
endfunction

function! s:RunSearch(count, searchStr, dir, type, shouldSaveMark, mode)

    call s:Assert(a:dir == 'f' || a:dir == 'b')
    call s:Assert(a:type == 'f' || a:type == 't' || a:type == 'p')

    let pattern = s:GetPatternFromInput(a:searchStr, a:type, 0)

    call s:MoveCursor(a:count, a:dir, pattern, a:shouldSaveMark, a:mode)
    call s:EnableHighlight()

    call s:AttachSearchToggleAutoCommands()
endfunction

function! s:MoveCursor(count, dir, pattern, shouldSaveMark, mode)

    let cnt = a:count > 0 ? a:count : 1

    let options = (a:dir ==# 'f') ? 'W' : 'Wb'

    for i in range(cnt)
        let newPos = searchpos('\V' . a:pattern, options . 'n')

        if newPos == [0, 0]
            " No match
            continue
        endif

        let minLine = line("w0") + &scrolloff

        if line("w0") > 1 && newPos[0] < minLine
            break
        endif

        if line("$") - line("w$") < &scrolloff
            " Need to ignore &scrolloff when at the bottom of the file
            let maxLine = line("$")
        else
            let maxLine = line("w$") - &scrolloff
        endif

        if newPos[0] > maxLine
            break
        endif

        if newPos[0] != line('.') || newPos[1] != col('.')

            if a:shouldSaveMark
                normal! m`
            endif

            call setpos('.', [bufnr('%'), newPos[0], newPos[1], 0])

            " This is necessary for some reason otherwise sometimes after doing f[char] and going down a line it jumps to a different column
            if col('.') == col('$')-1
                normal! hl
            else
                normal! lh
            endif
        endif
    endfor
endfunction

function! s:EnableHighlight(...)

    if a:0
        let pattern = a:1
    else
        let pattern = s:GetPatternFromInput(s:lastSearch, s:lastSearchType, 1)
    endif

    call s:RemoveHighlight()
    call s:AttachAutoCommands()

    let matchQuery = '\V' . pattern
    let currentLine = line('.')

    let nextMatchLine = searchpos(matchQuery .'\%>' . currentLine . 'l', 'Wn')[0]
    let prevMatchLine = searchpos(matchQuery .'\%<' . currentLine . 'l', 'bWn')[0]

    if prevMatchLine == 0
        let prevMatchLine = 1
    endif

    if nextMatchLine == 0
        let nextMatchLine = line('$')
    endif

    " Only show the matches in the above and below lines
    let matchQuery = matchQuery .'\%>' . max([0, prevMatchLine-1]) . 'l\%<' . (nextMatchLine+1) . 'l'

    let w:charHighlightId = matchadd('Search', matchQuery, 2, get(w:, 'charHighlightId', -1))
endfunction

function! s:RepeatSearchForward(count, mode)
    if empty(s:lastSearch)
        echo 'Nothing to repeat'
    else
        let shouldSaveMark = (get(w:, "charHighlightId", -1) == -1)

        if get(g:, 'NotableFtUseFixedDirection', 0)
            let dir = 'f'
        else
            let dir = s:lastSearchDir
        endif

        call s:RunSearch(a:count, s:lastSearch, dir, s:lastSearchType, shouldSaveMark, a:mode)

        if a:mode ==# 'o'
            " Not 100% sure why this is necessary in this case but it is
            normal! l
        endif
    endif
endfunction

function! s:RepeatSearchBackward(count, mode)
    if empty(s:lastSearch)
        echo 'Nothing to repeat'
    else
        let shouldSaveMark = (get(w:, "charHighlightId", -1) == -1)

        if get(g:, 'NotableFtUseFixedDirection', 0)
            let dir = 'b'
        else
            if s:lastSearchDir == 'b'
                let dir = 'f'
            else
                let dir = 'b'
            endif
        endif

        call s:RunSearch(a:count, s:lastSearch, dir, s:lastSearchType, shouldSaveMark, a:mode)
    endif
endfunction

