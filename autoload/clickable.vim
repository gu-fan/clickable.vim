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
            \'directory':  '',
            \'extensions': 'txt,js,css,html,py,vim,java,jade,c,cpp,rst,php,rb',
            \ 'prefix': '_clickable_',
            \ 'ignored_buf': '^NERD',
            \ 'maps': '<2-LeftMouse>,<C-2-LeftMouse>,<S-2-LeftMouse>,<CR>,<C-CR>,<S-CR>,<C-S-CR>'
            \ }

fun! s:trim(t) "{{{
    " ensure the message displays as one line
    let w = printf(' %%.%ss', (&co-25))
    " trim the ending whitespace
    let d = substitute(printf(w, a:t), '\s*$', '','')
    return d
endfun "}}}
fun! clickable#echo(msg) "{{{
    redraw
    echohl Type
    echo '[CLICK]'
    echohl Normal
    echon s:trim(a:msg)
endfun "}}}
fun! clickable#error(msg) "{{{
    redraw
    echohl ErrorMsg
    echo '[CLICK]'
    echohl Normal
    echon s:trim(a:msg)
endfun "}}}
fun! clickable#warning(msg) "{{{
    redraw
    echohl WarningMsg
    echo '[CLICK]'
    echohl Normal
    echon s:trim(a:msg)
endfun "}}}
fun! clickable#debug(msg) "{{{
    redraw
    if g:riv_debug
        echohl KeyWord
        echom "[CLICK]"
        echohl Normal
        echon s:trim(a:msg)
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
    if exists("g:clickable_".a:name)
        return g:clickable_{a:name}
    else
        return ''
    endif
endfun "}}}

let s:opt_loaded = 0
fun! clickable#init() "{{{

    if !s:opt_loaded 
        call clickable#load_opt()
        let s:opt_loaded = 1
    endif

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

let s:_f_config_queue = []
fun! clickable#export(var) "{{{
    call add(s:_f_config_queue, a:var)
endfun "}}}
fun! clickable#get_file_queue() "{{{
    return s:_f_config_queue
endfun "}}}

if !s:opt_loaded "{{{
    call clickable#load_opt()
    let s:opt_loaded = 1
endif "}}}

if expand('<sfile>:p') == expand('%:p') "{{{
    call clickable#load_opt()
    call clickable#echo('hello')
    echo clickable#get_opt('browser')
    echo clickable#get_opt('ignored_buf')
endif "}}}
