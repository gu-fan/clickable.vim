" www.11.cc xx@xx.cc http://www.163.com www.123.com  mailto:www@ee.com
" xxx@xxx.com ee.ee@eee.com  www.143.com eteevim xxx@xx.cim xxx.vim

" www.163.com jfeoijf testtest gogogo

" Test {{{

" }}}
"
"
"
let g:clickable_version = '0.9.1'
let s:default = {'version': g:clickable_version}
let s:default.options = {
            \'browser':  'firefox',
            \ }

fun! clickable#echo(msg) "{{{
    redraw
    echohl Type
    echo '[CLICK]'
    echohl Normal
    echon a:msg
endfun "}}}
fun! clickable#error(msg) "{{{
    redraw
    echohl ErrorMsg
    echo '[CLICK]'
    echohl Normal
    echon a:msg
endfun "}}}
fun! clickable#warning(msg) "{{{
    redraw
    echohl WarningMsg
    echo '[CLICK]'
    echohl Normal
    echon a:msg
endfun "}}}
fun! clickable#debug(msg) "{{{
    redraw
    if g:riv_debug
        echohl KeyWord
        echom "[CLICK]"
        echohl Normal
        echon a:msg
    endif
endfun "}}}
fun! clickable#load_opt(...) "{{{
    let opts = get(a:000, 0, s:default.options)
    for [opt,var] in items(opts)
        if !exists('g:clickable_'.opt)
            let g:clickable_{opt} = var
        elseif type(g:clickable_{opt}) != type(var)
            call clickable#error("[CLICKABLE]: Wrong type for Option:'g:clickable_".opt."'! Use default.")
            unlet! g:clickable_{opt}
            let g:clickable_{opt} = var
        endif
        unlet! var
    endfor
endfun "}}}
fun! clickable#get_opt(name) "{{{
    return g:clickable_{a:name}
endfun "}}}


fun! clickable#init() "{{{


    call clickable#load_opt()

    let s:_ConfigQue = clickable#config#init()

    call s:_ConfigQue.ALL.load()

    aug clickable_FILETYPE
        au!
        " au BufEnter * call s:_ConfigQue.ALL.load()
        " au Syntax * call s:_ConfigQue.ALL.load()
        for key in keys(s:_ConfigQue)
            if key != 'ALL'
                " echom "au FileType ".key."  call s:_ConfigQue.". key .".load()"
                exe "au FileType ".key."  call s:_ConfigQue.". key .".load()"
            endif
        endfor
    aug END
endfun "}}}


if expand('<sfile>:p') == expand('%:p') "{{{
    call clickable#load_opt()
    echo clickable#get_opt('browser')
endif "}}}
