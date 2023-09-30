" Function to serve as foldexpr for bash files with many functions
function! FoldBashFunction(lnum)
    let line = getline(a:lnum)
    let prevline = getline(a:lnum-1)
    if line =~ '^function'
        return 1
    endif
    if prevline =~ '^}'
        return 0
    endif
    return '='
endfunction
