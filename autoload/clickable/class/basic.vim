"=============================================
"  Plugin: basic.vim
"    File: basic.vim
"  Author: Rykka<rykka@foxmail.com>
"  Update: 2014-10-22
"=============================================
let s:cpo_save = &cpo
set cpo-=C

fun! clickable#class#basic#init() "{{{
    " Basic Object
    " have tooltip function
    " Should implement validate and trigger.
    
    if !exists('s:Basic')
    " if 1
        let Class = clickable#class#init()
        let Hi = clickable#highlight#init()
        let Syn = clickable#syntax#init()
        let Basic = Class('Basic', Hi, Syn)

        let Basic.name = 'basic'
        let Basic.tooltip = 'This is a Basic Tooltip'

        fun! Basic.validate(...) dict "{{{
            " Validate
            " return 0 if invalid
            " return a non empty object/string/number if valid
        endfun "}}}
        fun! Basic.trigger(...) dict "{{{
            " triggering event
            " accept optional mapping to get Shift/Control
        endfun "}}}
        fun! Basic.post_validate() dict "{{{
            " for post validate hook up
        endfun "}}}

        fun! Basic.on_hover() dict "{{{
            if !empty(self.validate())
                call self.post_validate()
                call self.show_tooltip(self.tooltip)
                return 1
            else
                return 0
            endif
        endfun "}}}
        fun! Basic.on_click(mapping) dict "{{{
            if !empty(self.validate())
                call self.post_validate()
                call self.trigger(a:mapping)
                return 1
            else
                return 0
            endif
        endfun "}}}

        fun! Basic.show_tooltip(tooltip) dict "{{{
            " Show Tooltip in cmdline
            call clickable#echo(a:tooltip)
        endfun "}}}

        let s:Basic = Basic
    endif

    return s:Basic
endfun "}}}

let &cpo = s:cpo_save
unlet s:cpo_save
