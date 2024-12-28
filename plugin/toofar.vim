" toofar.vim - Warn against deep nesting

let g:toofar_max_indent = get(g:, 'toofar_max_indent', 3)
let g:toofar_ignore_filetypes = get(g:, 'toofar_ignore_filetypes', [])


let s:warnings = {}
sign define nevernest_warn text=NN texthl=TabLineSel

function! DisplayWarning()
    let lnum = line('.')
    if has_key(s:warnings, lnum)
        echo s:warnings[lnum]
    elseif !has_key(s:warnings, lnum)
    " Clear the warning message if the line is no longer warning
        echo ""
    endif
endfunction

function! ClearWarnings()
    let s:warnings = {}
    sign unplace * group=nevernest
endfunction

function! CheckNeverNest()
    " ignore specified files
    if index(g:toofar_ignore_filetypes, &filetype) >= 0
        return
    endif
    call ClearWarnings()

    " max indents and warnings
    let indent_size = &shiftwidth > 0 ? &shiftwidth : &tabstop

    " for gutter
    let warning_count = 0
    for lnum in range(1, line('$'))
        let indent_level = indent(lnum) / indent_size
        if indent_level > g:toofar_max_indent
            execute 'sign place ' . lnum . ' line=' . lnum . ' name=nevernest_warn group=nevernest buffer=' . bufnr('%')
            let warning_count += 1
            let s:warnings[lnum] = 'NN: [' . lnum . '] indent ' . indent_level . ' > ' . g:toofar_max_indent
        endif
    endfor

    return warning_count
endfunction


" Set up autocommands to dynamically check for warnings
augroup NeverNest
    autocmd!
    " Check when text changes
    autocmd TextChanged,TextChangedI * call CheckNeverNest()
    " Also check when exiting insert mode
    autocmd InsertLeave * call CheckNeverNest()
    " Clear signs when leaving the buffer
    autocmd BufLeave * call ClearWarnings()
    " Show warnings
    autocmd CursorMoved * call DisplayWarning()
augroup END
