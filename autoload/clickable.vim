" www.11.cc xx@xx.cc http://www.163.com www.123.com  mailto:www@ee.com
" xxx@xxx.com ee.ee@eee.com  www.143.com eteevim xxx@xx.cim xxx.vim

" www.163.com jfeoijf testtest gogogo
"

" Test {{{

" }}}

fun! clickable#init() "{{{
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

