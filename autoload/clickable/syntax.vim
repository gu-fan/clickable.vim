"=============================================
"  Plugin: Clickable
"  File:   autoload/pattern/syntax.vim
"  Author: Rykka<rykka@foxmail.com>
"  Update: 2014-10-02
"=============================================
let s:cpo_save = &cpo
set cpo-=C

let s:syn = {}
fun! s:syn.syn_clear() dict "{{{
    " Vim command wrapper
    " syn clear group
    exe "syn clear ". self.syn_group
endfun "}}}
fun! s:syn.syn_match(pattern) dict "{{{
    " Vim command wrapper
    " echom 'syn_init:' bufname('%') self.name 
    " echom self.syn_group
    " NOTE: Syntax seperator for wrapping syntax pattern.
    let s = exists("self.syn_sep") ? self.syn_sep : '`'
    if empty(self.contained_in)
        " echom 1
        " echom "syn match ".self.syn_group." `". a:pattern ."` "
        "             \." containedin=.* "
                    " \."containedin=ALLBUT, ".g:clickable_prefix.'.*'

        exe "syn match ".self.syn_group." ".s. a:pattern .s
                    " \." containedin=.* "
                    " \." containedin=ALLBUT, ".g:clickable_prefix.'.*'
    else
        " echom 2
        exe "syn match ".self.syn_group." ".s. a:pattern .s
                    \." containedin=" . self.contained_in
    endif
endfun "}}}
" Attach the  syn/hi to link
fun! clickable#syntax#init() "{{{
    return s:syn
endfun "}}}


let &cpo = s:cpo_save
unlet s:cpo_save
