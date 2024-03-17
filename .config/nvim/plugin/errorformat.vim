let s:backup_errorformat = &l:errorformat
let s:backup_makeprg = &l:makeprg

let s:juniterrorformat = join([
            \'%+E%>[ERROR] %.%\+Time elapsed:%.%\+<<< FAILURE!',
            \'%+E%>[ERROR] %.%\+Time elapsed:%.%\+<<< ERROR!',
            \'%+Z%\s%#at %f(%\f%\+:%l)',
            \"%+C%.%#"], ",")

compiler gcc
let s:gccerrorformat = &l:errorformat

let s:errorformats = {
            \ "mvn": '[%tRROR] %f:[%l\,%c] %m',
            \ "junit": s:juniterrorformat,
            \ "gcc": s:gccerrorformat
            \ }
let s:global_vars = [ "BUILD_ERRORFORMAT", "TEST_ERRORFORMAT", "RUN_ERRORFORMAT" ]
command -nargs=* -complete=customlist,s:comp_setErrorFormat SetErrorFormat call <SID>setErrorFormat(<f-args>)

function s:comp_setErrorFormat(arglead, cmdline, cursorpos)
    let list_cmdline = split(a:cmdline, '\s\+')
    if len(list_cmdline) == 1 && a:arglead == ''
        return s:global_vars
    endif
    if len(list_cmdline) == 2 && a:arglead != ''
        return filter(copy(s:global_vars), {idx, string -> utils#startsWith(string, a:arglead)})
    endif
    let keys = keys(s:errorformats)
    if len(list_cmdline) == 2 && a:arglead == ''
        return keys
    endif
    if len(list_cmdline) == 3 && a:arglead != ''
        return filter(keys, {idx, string -> utils#startsWith(string, a:arglead)})
    endif
    return []
endfunction

function s:setErrorFormat(var, key)
    let g:[a:var] = get(s:errorformats, a:key)
endfunction


let &l:errorformat = s:backup_errorformat
let &l:makeprg = s:backup_makeprg
