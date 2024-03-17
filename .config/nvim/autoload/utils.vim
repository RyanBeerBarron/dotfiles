function utils#startsWith(longer, shorter) abort
    return a:longer[0:len(a:shorter)-1] ==? a:shorter
endfunction
