nnoremap <C-j>f <Cmd>call <SID>fzf_git_files()<cr>
nnoremap <C-j>b <Cmd>call <SID>fzf_vim_buffer()<cr>
nnoremap <C-j>q <Cmd>call <SID>fzf_vim_qf()<cr>

function s:fzf_git_files()
    let files = systemlist("git ls-files-root | fzf-popup-pipe --keep-right")
    let projectPath = systemlist("projects")[1]
    let length = len(files)
    if length == 1
        execute "edit ".projectPath."/".files[0]
    elseif length > 1
        let qflist = map(files, {key, val -> {"filename": val}})
        call setqflist(qflist)
    endif
endfunction

" TODO: format vim buffers
function s:fzf_vim_buffer()
    redir => buffers
    ls
    redir END
    let buf_list = systemlist("fzf-popup-pipe", buffers)
    let length = len(buf_list)
    if length == 1
        let bufnr = matchstr(buf_list[0], '\d\+')
        execute "buffer " . bufnr
    elseif length > 1
        let qflist = map(bufnr, {key, val -> {"filename": val}})
        call setqflist(qflist)
    endif
endfunction

" TODO: format quickfix picker
function s:fzf_vim_qf()
    let qflist = getqflist()
    let inputlist = map(qflist, {idx, qf -> idx .. "\t" ..  bufname(qf.bufnr) .. ":" .. qf.text})
    let files = systemlist("fzf-popup-pipe", join(qflist))
    let length = len(files)
    if length == 1
        execute "buffer " . files[0]
    elseif length > 1
        let qflist = map(bufnr, {_, val -> {"filename": val}})
        call setqflist(qflist)
    endif
endfunction
function s:format_vim_buffers(name)
    if a:name == ''
        return "[No name]"
    endif
    return fnamemodify(a:name, ":t")
endfunction
