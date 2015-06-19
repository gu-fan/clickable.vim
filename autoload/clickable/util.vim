"=============================================
"  Plugin: Clickable
"  File:   util.vim
"  Author: Rykka<rykka@foxmail.com>
"  Update: 2014-10-08
"=============================================
let s:cpo_save = &cpo
set cpo-=C


let s:V = vital#of('clickable_vim')

let s:File = s:V.import('System.File')


let s:is_unix = has('unix')
let s:is_windows = has('win16') || has('win32') || has('win64') || has('win95')
let s:is_cygwin = has('win32unix')
let s:is_mac = !s:is_windows && !s:is_cygwin
      \ && (has('mac') || has('macunix') || has('gui_macvim') ||
      \   (!isdirectory('/proc') && executable('sw_vers')))

fun! clickable#util#open(...)
    return call(s:File.open , a:000 , s:File)
endfun
fun! clickable#util#edit(file) "{{{
    exe 'e ' a:file
endfun "}}}
fun! clickable#util#mkdir(path) "{{{
    if !isdirectory(fnamemodify(a:path,':h'))
        call mkdir(fnamemodify(a:path,':h'),'p')
    endif
endfun "}}}
fun! clickable#util#system(expr) abort "{{{
    call s:system(a:expr)
endfun "}}}

fun! s:system(expr) abort "{{{
    if exists("*vimproc#system")
        call vimproc#system(a:expr)
    else
        call system(a:expr)
    endif
endfun "}}}

fun! s:BEcho(Obj, ...) "{{{
    let Obj = a:Obj
    let idt = get(a:000, 0 , '')
    let suf = get(a:000, 1 , '')
    let sameline = get(a:000 , 2, 0)
    if type(Obj) == type({})
        call s:BEcho('{', idt,'',1)
        for [Key, Var] in items(Obj)
            call s:BEcho('"'.Key.'":', idt.'  ')
            call s:BEcho(Var, idt.'  ', ',', 1)
            unlet Var
        endfor
        call s:BEcho('}', idt, ',')
    elseif type(Obj) == type([])
        call s:BEcho('[', idt,'',1)
        for Var in Obj
            call s:BEcho(Var, idt.'  ', ',')
            unlet Var
        endfor
        call s:BEcho(']', idt, ',')
    elseif type(Obj) == type(function('tr'))
        echon ' '.string(Obj).suf
    else
        if sameline
            echon ' '.Obj.suf
        else
            echo idt.Obj.suf
        endif
    endif
endfun "}}}

fun! s:BEchon(Obj,...) "{{{
    let Obj = a:Obj
    let idt = get(a:000, 0 , '')
    let suf = get(a:000, 1 , '')
    echon ' '.Obj.suf
endfun "}}}


function! clickable#util#BEcho(...) "{{{
    return call('s:BEcho', a:000)
endfunction "}}}

fun! clickable#util#nop(mapping) "{{{
    " run the default action of mapping
    let action = a:mapping
    " replace back
    let action = substitute(action,
                \ '\[\([-0-9a-zA-Z]\+\)\]',
                \ '\\<\1>','g')
    exe 'exe "norm! '.action.'"'
endfun "}}}

fun! clickable#util#fallback(mapping) "{{{
    let m = a:mapping
    let m = substitute(m,
                \ '\[\([-0-9a-zA-Z]\+\)\]',
                \ '<\1>','g')
    let s:fbk = clickable#get_opt('map_fallback')
    if exists('s:fbk[m]')
        if type(s:fbk[m]) == type(function('tr'))
            call call(s:fbk[m], [])
        elseif type(s:fbk[m]) == type('1')
            " replace back
            let k = s:fbk[m]
            let k = substitute(k,
                        \ '<\([-0-9a-zA-Z]\+\)>',
                        \ '\\<\1>','g')
            exe 'exe "norm! '.k.'"'
        endif
    else
        call clickable#util#nop(a:mapping)
    endif
    
endfun "}}}

fun! clickable#util#clear_highlight() "{{{
    2match none
    redraw
endfun "}}}

fun! clickable#util#browse(url, ...) "{{{
    let url = a:url
    " let url = url =~? '\v^%(https=|file|ftp|fap|gopher|mailto|news):' ? url : 'http://'. url
    let browser = get(a:000, 0, clickable#get_opt('browser'))
    if s:is_mac
        let browser = substitute(browser, '\<\w', '\U\0','g')
        let cmd = 'open ' . ( browser ? '-a "'. browser .'"' : ''). ' "'. url .'" &'
    else
        let cmd = browser. ' ' . url. ' &'
    endif
    echom cmd 
    call system(cmd)
endfun "}}}

if expand('<sfile>:p') == expand('%:p') "{{{
    call clickable#util#open('~/Downloads/')
    call clickable#util#browse('www.163.com')
    call clickable#util#BEcho({1:1,2:[1,2,3,[1,2,3,4]]})
endif "}}}


let &cpo = s:cpo_save
unlet s:cpo_save
