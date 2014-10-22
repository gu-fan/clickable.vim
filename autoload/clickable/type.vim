"=============================================
"  Plugin: Clickabble.vim
"  File:   autoload/clickable/class.vim
"  Author: Rykka<rykka@foxmail.com>
"  Update: 2014-10-01
"=============================================
let s:cpo_save = &cpo
set cpo-=C


fun! clickable#type#init() "{{{
    if !exists("s:__TYPE")
        let s:__TYPE = {}
        let [
        \   s:__TYPE.NUMBER,
        \   s:__TYPE.STRING,
        \   s:__TYPE.FUNCREF,
        \   s:__TYPE.LIST,
        \   s:__TYPE.DICT,
        \   s:__TYPE.FLOAT] = [
              \   type(3),
              \   type(""),
              \   type(function('tr')),
              \   type([]),
              \   type({}),
              \   has('float') ? type(str2float('0')) : -1]
    endif

    return s:__TYPE
    
endfun "}}}

let &cpo = s:cpo_save
unlet s:cpo_save
