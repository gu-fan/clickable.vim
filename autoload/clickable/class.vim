"=============================================
"  Plugin: Clickabble.vim
"  File:   autoload/clickable/class.vim
"  Author: Rykka<rykka@foxmail.com>
"  Update: 2014-10-01
"=============================================
let s:cpo_save = &cpo
set cpo-=C

" ROOT
" unlet s:object
if !exists("s:object") "{{{
    let s:__TYPE = clickable#type#init()
    let s:object = {'type': 'object', 'parent': '', 'is_instance':0}
    fun! s:object.init() dict "{{{
        " A placeholding function for init a new instance.
    endfun "}}}
    fun! s:object.new(...) dict "{{{
        " Create a instance
        let o = copy(self)
        let o.is_instance = 1

        let arg = get(a:000, 0 , '')
        if !empty(arg) && type(arg) == s:__TYPE.DICT
            call extend(o, arg)
        endif
        call o.init()
        return o
    endfun "}}}
    " Make it unchangeable
    lockvar s:object
    fun! s:Class(...) "{{{
        " Inherit from object class
        " if empty(a:000)
            let c = copy(s:object)
        " else
        "     let c = {}
        " endif
        let type = ''

        " Mixin Class With multiple classes.
        " If it's a list, then mixin each item of list
        " If it's a object, then extend it.
        " return extend(copy(self), obj)
        for o in a:000
            if type(o) == s:__TYPE.LIST
                for obj in o
                    try
                        call extend(c, obj)
                    catch
                        " pass
                    endtry
                endfor
            elseif type(o) == s:__TYPE.DICT
                call extend(c, o)
            elseif type(o) == s:__TYPE.STRING
                let type = o
            endif
            unlet o
        endfor

        if !empty(type)
            let c.type = type
        endif
        return c 

    endfun "}}}

endif "}}}

fun! clickable#class#init() "{{{
    return function('s:Class')
endfun "}}}


if expand('<sfile>:p') == expand('%:p') "{{{
    echo clickable#class#init()
endif "}}}

let &cpo = s:cpo_save
unlet s:cpo_save
