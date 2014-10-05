"=============================================
"  Plugin: Clickable.vim
"  File:   autoload/clickable/test.vim
"  Author: Rykka<rykka@foxmail.com>
"  Update: 2014-09-30
"=============================================
let s:cpo_save = &cpo
set cpo-=C


let s:test = {}

function s:test.class() dict "{{{

    let Class = clickable#class#init()

    let hi = Class()
    function hi.link()
        echo 1
    endfunction
    let t = hi.new()

    Should be equal t.is_instance, 1

    " Create another class
    let syn = Class('syn')
    function! syn.match()
        echo 'syn match'
    endfunction

    let k = syn.new()
    call k.match()

    let k = syn.new({'name':'kitty'})
    Should be equal k.name, 'kitty'

    " Mixin Two Class
    "
    let S2 = Class(hi, syn)
    let s2 = S2.new()

    call s2.match()
    call s2.link()

endfun "}}}

fun! clickable#test#init() "{{{
    for k in keys(s:test)
        call s:test[k]()
    endfor
endfun "}}}

if expand('<sfile>:p') == expand('%:p') "{{{
        call clickable#test#init()
    let s:_r = !exists('s:_r') ? 0 : s:_r
    if s:_r == 0
        Spec
        let s:_r = 1
    endif
endif "}}}


let &cpo = s:cpo_save
unlet s:cpo_save

