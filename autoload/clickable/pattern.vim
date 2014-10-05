"=============================================
"  Plugin: Clickable.vim
"  File:   autoload/clickable/pattern.vim
"  Author: Rykka<rykka@foxmail.com>
"  Update: 2014-09-30
"=============================================
let s:cpo_save = &cpo
set cpo-=C

fun! clickable#pattern#norm_list(list,...) "{{{
    " return list with words
    return filter(map(a:list,'matchstr(v:val,''\w\+'')'), ' v:val!=""')
endfun "}}}
fun! clickable#pattern#get_WORD_bgn(line, col) "{{{
    " Get Current WORD's idx
    "
    " @param 
    " line: a string, usually is a line
    " col: the cursor's colnum position
    "
    " col num start from 1 
    " hello world
    " 123456789
    "
    " @return 
    " the match index (byte offset), start from 0
    "
    " >>> echo clickable#get_WORD_bgn("hello world", 2)
    " 0
    
    let ptn = printf('\%%%dc.', a:col)
    if matchstr(a:line, ptn)=~'\S'
        return match(a:line, '\S*'.ptn)
    else
        return -1
    endif
endfun "}}}

fun! clickable#pattern#match_object(str,ptn,...) "{{{
    " return a python like match object
    " @param: string, pattern,  [bgn]
    " @return object { bgn,end, groups, str}

    let bgn = get(a:000, 0 , 0)
    let s = {'bgn':-1, 'end':-1}

    let bgn = match(a:str,a:ptn, bgn)
    if bgn == -1
        return s
    endif

    let s.bgn  = bgn
    let s.groups = matchlist(a:str,a:ptn, bgn)
    let s.str    = s.groups[0]
    let s.end    = s.bgn + len(s.str)
    return s
endfun "}}}

fun! clickable#pattern#init()
    return pattern
endfun


let &cpo = s:cpo_save
unlet s:cpo_save
