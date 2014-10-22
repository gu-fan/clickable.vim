"=============================================
"  Plugin: link.vim
"    File: link.vim
"  Author: Rykka<rykka@foxmail.com>
"  Update: 2014-10-22
"=============================================
let s:cpo_save = &cpo
set cpo-=C

fun! clickable#class#link#init() "{{{
    if !exists("s:Link")
    " if 1
        let Class = clickable#class#init()
        let Syntax = clickable#class#syntax#init()
        let Link = Class('Link', Syntax)
        let Link.name = 'link'
        let Link.browser = clickable#get_opt('browser')
        function! Link.trigger(...) dict "{{{
            let url = self._hl.obj.str
            let browser = self.browser
            let url = url =~? '\v^%(https=|file|ftp|fap|gopher|mailto|news):' ? url : 'http://'. url
            call clickable#util#browse(url, browser)
        endfunction "}}}
        let s:Link = Link
    endif
    return s:Link
endfun "}}}

let &cpo = s:cpo_save
unlet s:cpo_save
