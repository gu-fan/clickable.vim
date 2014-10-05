"=============================================
"  Plugin: Clickabble.vim
"  File:   autoload/clickable/highlight.vim
"  Author: Rykka<rykka@foxmail.com>
"  Update: 2014-10-01
"=============================================
let s:cpo_save = &cpo
set cpo-=C


let s:hi = {}

fun! s:hi.hi_link(to, ...) dict "{{{
    " Vim command wrapper
    " hi! link from-group to-group
    let bang = get(a:000, 0 , '!')
    exe "hi".bang." link ". self.syn_group ." ".a:to
endfun "}}}



" Attach the  syn/hi to link
fun! clickable#highlight#init()
    return s:hi
endfun


let &cpo = s:cpo_save
unlet s:cpo_save
