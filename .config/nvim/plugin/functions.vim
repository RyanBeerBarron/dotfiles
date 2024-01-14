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

" Function to fold paragraph of texts
function! FoldParagraphs(lnum)
    let line = getline(a:lnum)
    return line =~ '\S'? 1 : '<1'
endfunction

" Return the character on the cursor, or in front for insert mode
function! Get_char()
    let [_, l:lnum, l:col, _, _] = getcurpos()
    return getline('.')[l:col-1]
endfunction

function! RGBtoBase10(rgb)
	let i = 0
	if a:rgb[0] == '#'
		let i = 1
	endif
	let red = str2nr(a:rgb[i:i+1], 16)
	let green = str2nr(a:rgb[i+2:i+3], 16)
	let blue = str2nr(a:rgb[i+4:i+5], 16)
	return red .. ", " .. green .. ", " .. blue
endfunction
