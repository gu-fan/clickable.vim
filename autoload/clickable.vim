" Make Things in Vim Clickable.
" vim:tw=78:fdm=marker:

let s:is_clickable = ''
let s:click_text = ''
let [s:hl_row, s:hl_bgn,s:hl_end] = [0, 0 , 0]

let s:link_mail = '<[[:alnum:]_-]+%(\.[[:alnum:]_-])*\@[[:alnum:]]%([[:alnum:]-]*[[:alnum:]]\.)+[[:alnum:]]%([[:alnum:]-]*[[:alnum:]])=>'
let s:link_url  = '<%(%(file|https=|ftp|gopher)://|%(mailto|news):)([^[:space:]''\"<>]+[[:alnum:]/])'
let s:link_www  = '<www[[:alnum:]_-]*\.[[:alnum:]_-]+\.[^[:space:]''\"<>]+[[:alnum:]/]'
let s:link_uri  = '\v'.s:link_url .'|'. s:link_www .'|'.s:link_mail

fun! s:is_fold_closed() "{{{
    return foldclosed('.') != -1
endfun "}}}
fun! s:is_fold_firstline() "{{{
    return &fdm == 'marker' && getline('.') =~ split(&foldmarker,',')[0]
endfun "}}}
fun! s:open_fold() "{{{
    exe "norm! zv"
endfun "}}}
fun! s:close_fold() "{{{
    exe "norm! zc"
endfun "}}}

fun! s:check_file() "{{{
    
endfun "}}}
fun! s:check_link() "{{{
    
endfun "}}}
fun! s:in_hl_region(row, col)
    return !&modified && a:row == s:hl_row && a:col >= s:hl_bgn && col <= s:hl_end
endfun


fun! s:match_object(str,ptn,...) "{{{
    " return a python like match object
    " @param: string, pattern,  [start]
    " @return object { start,end, groups, str}

    let start = a:0 ? a:1 : 0
    let s = {}

    let idx = match(a:str,a:ptn,start)
    if idx == -1
        return s
    endif

    let s.start  = idx
    let s.groups = matchlist(a:str,a:ptn,start)
    let s.str    = s.groups[0]
    let s.end    = s.start + len(s.str)
    return s
endfun "}}}

" We will decide if one thing is clickable 
" when moveing our cursor.
" And will execute it's relevent action when clicked

fun! clickable#hi_cursor()
    " Check if current pos is clickable.
    " Highlight it and make it clickable.
    
    let [row,col] = getpos('.')[1:2]
    let line = getline(row)

    if s:is_fold_closed()
        let s:is_clickable = 'fold_closed'
        return
    endif

    if s:is_fold_firstline()
        let s:is_clickable = 'fold_firstline'
        return
    endif

    let [text, is_link, bgn, end] = s:check_link(line, col)
    if is_link
        let s:is_clickable = 'link'
        let s:click_text = text
    else
        let [text, is_file, bgn, end] = s:check_file(line, col)
        if is_file
            let s:is_clickable = 'file'
            let s:click_text = text
        else
            " FUTURE: other thing here for hook
            return
        endif
    endif

    " Highlight section
    
    " if cursor is still in prev hl region , skip
    if s:in_hl_region(row, col) | return | endif

    let [s:hl_row, s:hl_bgn,s:hl_end] = [row, 0 , 0]
    " >>> echo s:match_object('joeifjie', 'fefe')
    " 3
    let obj = s:match_object(line, s:link_uri)

endfun

fun! s:clickable(...) "{{{
    " and choose action

    " open folding if in a folded line
    if s:is_fold()
        call s:open_fold() | return
    endif

    " close fold if on the marker line
    if s:is_at_first_line_of_fold()
        call s:close_fold() | return
    endif

    " open link if it's a link!
    if s:is_link()
        call s:open_link() | return
    endif

    if s:is_file()
        call s:open_file() | return
    endif
    
    " open file/directory if it's exists
    let file = expand('<cfile>')
    if !filereadable(file) || !isdirectory(file)
        let file = expand(file)
    endif

    if filereadable(file) || isdirectory(file)

        " split if "shift"
        if a:1 =~? '^s-\|-s-'
            echom 1
            split
        endif
        exe "edit ".file
        return
    endif

    " NOTE: 
    " Combine string to get string constant like "\<CR>"
    " Must use double quoting.  ~/bin/
    exe 'exe "norm! \<'.a:1.'>"'

endfun "}}}

fun! clickable#hi_text() "{{{
    
    let [row,col] = getpos('.')[1:2]

    " if col have not move out prev hl region , skip
    if !&modified && row == s:hl_row && col >= s:hl_bgn && col <= s:hl_end
        return
    endif
    let [s:hl_row, s:hl_bgn,s:hl_end] = [row, 0 , 0]

    let line = getline(row)
    let idx = s:get_link_idx(line,col)
    
    if idx != -1

        let obj = s:match_object(line, riv#ptn#link_all(), idx)
        if !empty(obj) && obj.start < col
            let bgn = obj.start + 1
            let end = obj.end
            if col <= end+1
                let [s:hl_row, s:hl_bgn,s:hl_end] = [row, bgn, end]
                if !empty(obj.groups[5]) || !empty(obj.groups[6]) 
                    if !empty(obj.groups[5]) 
                        let file = riv#link#path(obj.str)
                    else
                        let file = expand(obj.str)
                    endif
                    " if link invalid
                    if ( riv#path#is_directory(file) && !isdirectory(file) ) 
                        \ ||( !riv#path#is_directory(file) && !filereadable(file) )
                        execute '2match '.g:riv_file_link_invalid_hl.' /\%'.(row)
                                    \.'l\%>'.(bgn-1) .'c\%<'.(end+1).'c/'
                        return
                    endif
                endif
                execute '2match' "IncSearch".' /\%'.(row)
                            \.'l\%>'.(bgn-1) .'c\%<'.(end+1).'c/'
                return
            endif
        else
            let [is_in,bgn,end,obj] = riv#todo#col_item(line,col)
            if is_in>=2
                execute '2match' "DiffAdd".' /\%'.(row)
                            \.'l\%>'.(bgn-1) .'c\%<'.(end+1).'c/'
                return
            endif
        endif
    endif

    2match none
endfun "}}}
if expand('<sfile>:p') == expand('%:p') "{{{
    call doctest#start()
endif "}}}
