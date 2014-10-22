"=============================================
"  Plugin: file.vim
"    File: file.vim
"  Author: Rykka<rykka@foxmail.com>
"  Update: 2014-10-22
"=============================================
let s:cpo_save = &cpo
set cpo-=C

fun! clickable#class#file#init() "{{{
    if !exists("s:File")
    " if 1
        let Class = clickable#class#init()
        let Syntax = clickable#class#syntax#init()
        let File = Class('File', Syntax)

        let File.name = 'file'

        " call clickable#util#BEcho(File)
        " call clickable#util#BEcho(Syntax)

        fun! File.post_validate() dict "{{{
            let self.full_path = fnamemodify(self._hl.obj.str, ':p')
            let self.short_path = fnamemodify(self._hl.obj.str, ':t')
        endfun "}}}
        fun! File.on_hover() dict "{{{
            if !empty(self.validate())
                call self.post_validate()
                if self.is_file_exists()
                    call self.highlight()
                else
                    call self.highlight('ErrorMsg')
                endif
                call self.show_tooltip(self.tooltip. self.full_path)
                return 1
            else
                return 0
            endif
        endfun "}}}
        fun! File.on_click(mapping) dict "{{{
            if !empty(self.validate())
                call self.post_validate()
                call self.trigger(a:mapping)
                return 1
            else
                return 0
            endif
        endfun "}}}
        fun! File.trigger(...)  dict "{{{
            let action = get(a:000, 0 , '')
            let [_ctrl, _shift] = [0 , 0]
            if action =~? '\[c-\|-c-\|Ctrl-' | let _ctrl = 1 | endif
            if action =~? '\[s-\|-s-\|Shift-' | let _shift = 1| endif
            if self.is_file_exists()
                if _shift == 1 | split | endif
                call clickable#util#edit(self.full_path)  
            else
                if _ctrl == 1 || input("'". self.full_path ."' is not exists, create it? (yes/no):") == "yes"
                    call clickable#util#mkdir(self.full_path)
                    if _shift == 1 | split | endif
                    call clickable#util#edit(self.full_path)
                endif
            endif
        endfun "}}}
        fun! File.is_file_exists() dict "{{{
            return isdirectory(self.full_path) || filereadable(self.full_path) 
        endfun "}}}

        let s:File = File
    endif

    return s:File
endfun "}}}

let &cpo = s:cpo_save
unlet s:cpo_save
