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

function RunInTerm(arg = "")
    let cmd = a:arg
    if empty(cmd)
        let cmd = input("Command to run: ")
    endif
    if getenv('TMUX') != v:null
        call system('tmux split-window -v -l 33% ' .. cmd)
    else
        execute "botright " .. float2nr(floor(&lines * 0.33)) .. "split"
        execute "term " .. cmd
    endif
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

function s:openFiles()
    let pattern = input("Open files: ")
    execute "arg **/*" .. pattern .. "*"
endfunction
nnoremap <C-x>f <cmd>call <SID>openFiles()<Cr>

function s:filterQuickfixList()
    let qflist = getqflist()
    let pattern = input("Filter Quickfix: ")
    let qflist = filter(qflist, {key,val -> <SID>matchPattern(key, val, pattern)})
    call setqflist(qflist)
endfunction

function s:matchPattern(qf_key, qf_val, pattern)
    let qf_text = a:qf_val.text
    let qf_filename = bufname(a:qf_val.bufnr)
    if a:pattern[0] == '!'
        return qf_text !~ a:pattern[1:] && qf_filename !~ a:pattern[1:]
    else
        return qf_text =~ a:pattern || qf_filename =~ a:pattern
    endif
endfunction

nnoremap <C-x>q <cmd>call <SID>filterQuickfixList()<Cr>

command! -nargs=? -range Dec2hex call s:Dec2hex(<line1>, <line2>, '<args>')
function! s:Dec2hex(line1, line2, arg) range
  if empty(a:arg)
    if histget(':', -1) =~# "^'<,'>" && visualmode() !=# 'V'
      let cmd = 's/\%V\<\d\+\>/\=printf("0x%x",submatch(0)+0)/g'
    else
      let cmd = 's/\<\d\+\>/\=printf("0x%x",submatch(0)+0)/g'
    endif
    try
      execute a:line1 . ',' . a:line2 . cmd
    catch
      echo 'Error: No decimal number found'
    endtry
  else
    echo printf('%x', a:arg + 0)
  endif
endfunction
