"=============================================
"  Plugin: syntax.vim
"    File: syntax.vim
"  Author: Rykka<rykka@foxmail.com>
"  Update: 2014-10-22
"=============================================
let s:cpo_save = &cpo
set cpo-=C

fun! clickable#class#syntax#init() "{{{
    " The Class provides syntax highlighting method
    if !exists("s:Syntax")
    " if 1
        let Class = clickable#class#init()
        let Basic = clickable#class#basic#init()
        let Syntax = Class('Syntax', Basic)
        let Syntax.name = 'syntax'
        let Syntax.pattern = ''
        let Syntax.syn_group = ''
        let Syntax.hl_group = 'Underlined'
        let Syntax.hover_hl_group = 'MoreMsg'
        let Syntax.noexists_hl_group = ''
        let Syntax.contained_in = ''
        " XXX
        " we can not simply use this as we should init 
        " for every window/buffer
        " let Syntax.initialized = 0

        fun! Syntax.init() dict "{{{
                let self.syn_group = clickable#get_opt('prefix') . self.name
                let self._hl = { 'row':0,'bgn':0,'end':0, 'col':0, 'buf':bufnr('%'),
                                \ 'obj':{} }
                let self._changedtick = b:changedtick
                call self.syntax()
        endfun "}}}

        fun! Syntax.on_hover() dict "{{{
            if !empty(self.validate())
                call self.post_validate()
                call self.highlight()
                call self.show_tooltip(self.tooltip. self._hl.obj.str)
                return 1
            else
                return 0
            endif
        endfun "}}}
        fun! Syntax.validate() dict "{{{
            " TODO: add a validate cache for BASIC
            " check if it's the right pattern/env
            " returns object or 0
            
            " also set self._hl.obj, self._hl.bgn...
            let [row, col] = getpos('.')[1:2]
            let line = getline(row)

            " return 0 if not in syntax region
            let _stack = synstack(row, col)
            " Stop on no syntax highlight or minified file
            if empty(_stack) || col > 500
                return 0
            else
                let _i = 0
                for s in _stack
                    let name = synIDattr(s, 'name')
                    if name =~ '^'.clickable#get_opt('prefix')
                        let _i = 1
                        break
                    endif
                endfor
                if _i == 0
                    return 0
                endif
            endif

            " return the correct hl_obj 
            if self.is_same_region(row, col)
                let obj = self._hl.obj
            else
                let obj = self.get_hl_obj(line, row, col)
            endif

            let [self._hl.row, self._hl.col, 
                \ self._hl.bgn, self._hl.end, self._hl.obj] = 
                \ [row, col, obj.bgn, obj.end, obj]

            if has_key(obj, 'str')
                return obj
            else
                return 0
            endif

        endfun "}}}
        fun! Syntax.syntax() dict "{{{
            " Syntax Highlighting
            
            call self.hi_link(self.hl_group)
            call self.syn_clear()
            call self.syn_match(self.pattern)
            
        endfun "}}}
        fun! Syntax.highlight(...) dict "{{{
            " highlight on cursor hover.
            " return 1 if highlighted
            "
            " Use '2match' to highlight
            " As the '\%#' of syn can not be updated automatically.
            
            let HL = get(a:000, 0 , 'IncSearch')
            let obj = self._hl.obj
            if has_key(obj, 'str')  
                let bgn = obj.bgn + 1
                let end = obj.end
                let row = self._hl.row
                let col = self._hl.col
        
                if obj.bgn < col && col <= obj.end + 1
                    " echon '|' obj.bgn ',' obj.end
                    " echon ':' col
                    " echon 'hi'
                    " echon obj.str
                    execute '2match' HL.' /\%'.(row)
                                \.'l\%>'.(bgn-1) .'c\%<'.(end+1).'c/'
                    return 1
                " else
                "     echon '|' obj.bgn ',' obj.end
                "     echon ':' col
                "     echon 'no hi'
                "     echon obj.str
                endif

            endif

            return 0
        
        endfun "}}}
        fun! Syntax.get_hl_obj(line, row, col) dict "{{{
            let [line, col, row] = [a:line, a:col, a:row]

            let obj  = {'bgn':-1, 'end':-1}
            let bgn = 0
            let end = 0

            " will loop at least once
            while end < col && end != -1
                " let last_bgn = bgn
                " let last_obj = obj
                let obj = clickable#pattern#match_object(line, 
                            \ self.pattern, end)

                " " break if No match
                " if !has_key(obj, 'str') 
                "     echom 'break str'
                "     break | endif

                let end = obj.end

                " " break if No More match
                " if bgn == last_bgn 
                "     echom 'break no more'
                "     break | endif
            endwhile


            " check if cursor is in the object range
            if obj.bgn <= col && col <= obj.end
                return obj
            else
                return {'bgn':-1, 'end':-1}
            else
            endif
            
        endfun "}}}
        fun! Syntax.is_same_region(row, col) dict "{{{
            if self._changedtick != b:changedtick
                let self._changedtick = b:changedtick
                return 0
            else
                return a:row == self._hl.row 
                \ && a:col >= self._hl.bgn
                \ && a:col <= self._hl.end
            endif
        endfun "}}}

        let s:Syntax = Syntax
    endif

    return s:Syntax
    
endfun "}}}

let &cpo = s:cpo_save
unlet s:cpo_save
