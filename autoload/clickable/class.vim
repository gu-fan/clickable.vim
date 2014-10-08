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
let [
\   s:__TYPE_NUMBER,
\   s:__TYPE_STRING,
\   s:__TYPE_FUNCREF,
\   s:__TYPE_LIST,
\   s:__TYPE_DICT,
\   s:__TYPE_FLOAT] = [
      \   type(3),
      \   type(""),
      \   type(function('tr')),
      \   type([]),
      \   type({}),
      \   has('float') ? type(str2float('0')) : -1]
    let s:object = {'type': 'object', 'parent': '', 'is_instance':0}
    fun! s:object.init() dict "{{{
        " A placeholding function for init a new instance.
    endfun "}}}
    fun! s:object.new(...) dict "{{{
        " Create a instance
        let o = copy(self)
        let o.is_instance = 1

        let arg = get(a:000, 0 , '')
        if !empty(arg) && type(arg) == s:__TYPE_DICT
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
            if type(o) == s:__TYPE_LIST
                for obj in o
                    try
                        call extend(c, obj)
                    catch
                        " pass
                    endtry
                endfor
            elseif type(o) == s:__TYPE_DICT
                call extend(c, o)
            elseif type(o) == s:__TYPE_STRING
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

fun! clickable#class#Class() "{{{
    return function('s:Class')
endfun "}}}

fun! clickable#class#Basic() "{{{
    " Basic Object
    " have tooltip function
    " Should implement validate and trigger.
    
    if !exists('s:Basic')
    " if 1
        let Class = clickable#class#Class()
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
            echohl ModeMsg
            echon '[CLICKABLE]'
            echohl Normal
            echon ' '. a:tooltip
        endfun "}}}

        let s:Basic = Basic
    endif

    return s:Basic
endfun "}}}
fun! clickable#class#Syntax() "{{{
    " The Class provides syntax highlighting method
    if !exists("s:Syntax")
    " if 1
        let Class = clickable#class#Class()
        let Basic = clickable#class#Basic()
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
                let self.syn_group = g:clickable_prefix . self.name
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
                    if name =~ '^'.g:clickable_prefix
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
fun! clickable#class#Link() "{{{
    if !exists("s:Link")
    " if 1
        let Class = clickable#class#Class()
        let Syntax = clickable#class#Syntax()
        let Link = Class('Link', Syntax)
        let Link.name = 'link'
        let Link.browser = 'firefox'
        function! Link.trigger(...) dict "{{{
            call clickable#util#system(self.browser.' '.self._hl.obj.str)
        endfunction "}}}
        let s:Link = Link
    endif

    return s:Link
endfun "}}}
fun! clickable#class#File() "{{{
    if !exists("s:File")
    " if 1
        let Class = clickable#class#Class()
        let Syntax = clickable#class#Syntax()
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
                call self.show_tooltip(self.tooltip. self.short_path)
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



" The global function, with name as the key of object
" then map it with the objects

fun! s:OnHover(name) "{{{
    let e = 0
    let objects = s:_ConfigQue[a:name].objects
    " if exists('s:ConfigQue[a:name].extend')
    "     let ext = s:ConfigQue[a:name].extend
    "     call extend(objects, s:ConfigQue[ext].objects )
    " endif
    for obj in objects
        " call obj.on_{self.name}()
        " exe 'let e = obj.on_'.self.name.'()'
        let e = obj.on_hover()
        if e == 1
            break
        endif
    endfor
    if e == 0
        call clickable#util#clear_highlight()
    endif
endfun "}}}
fun! s:OnClick(mapping, name) "{{{
    let e = 0
    let objects = s:_ConfigQue[a:name].objects
    if has_key(s:_ConfigQue[a:name], 'extend')
        let ext = s:_ConfigQue[a:name].extend
        call extend(objects, s:_ConfigQue[ext].objects )
    endif
    for obj in objects
        " exe 'let e = obj.on_'.self.name.'("'.a:mapping.'")'
        let e = obj.on_click(a:mapping)
        if e == 1
            break
        endif
    endfor
    if e == 0
        call clickable#util#fallback(a:mapping)
    endif
endfun "}}}
fun! s:InitObj(name) "{{{
    " init with autocmd to 
    let n = a:name
    let objects = s:_ConfigQue[n].objects
    
    " inited ConfigQue
    if !exists("b:clickable_init") 
        let b:clickable_init = {}
    endif

    if !exists("b:clickable_init[n]")
            \ || b:clickable_init[n] != 1
        for obj in objects
            call obj.init()
        endfor
        let b:clickable_init[n] = 1
    endif
endfun "}}}

" The global [private] config queue
" let g:_clickable_config_queue = {}

fun! clickable#class#ConfigQue() "{{{
    " The config class Queue for control the config items.

    if !exists("s:ConfigQue")
    " if 1

        let s:_ConfigQue = g:_clickable_config_queue

        let Class = clickable#class#Class()

        let ConfigQue = Class('ConfigQue')
        let ConfigQue.name = 'config_queue'
        let ConfigQue.mappings = '<2-LeftMouse>,<C-2-LeftMouse>,<S-2-LeftMouse>,<CR>,<C-CR>,<S-CR>,<C-S-CR>'
        let ConfigQue.au_group = 'CursorMoved,CursorMovedI'
        let ConfigQue.buffer_only = 1
        " extend is the key for extending objects
        " let ConfigQue.extend = "ALL"
        
        fun! ConfigQue.init() "{{{
            " if !exists("b:clickable_init") || b:clickable_init != 1
                let self._mappings = split(self.mappings, ',')
                if exists('self.filetype')
                    let self._filetype = split(self.filetype , ',')
                endif
                " NOTE:
                " Use it here to avoid duplicated list reference
                let self.objects = []
                " let b:clickable_init = 1
            " endif
            " push self to the global config dict
            " let s:_ConfigQue[self.name] = self
        endfun "}}}
        fun! ConfigQue.load() dict "{{{
            " call self.init_obj()
            call self.autocmd()
            call self.mapping()
        endfun "}}}
        fun! ConfigQue.autocmd() dict "{{{
        "  This should be load at first.
            " call s:InitObj(self.name)
            exe "aug CLICKABLE_AUTOCMD_".self.name
                au!


                if self.buffer_only

                    " echom self.name
                    " echom 'au BufEnter,BufWinEnter <buffer> call s:InitObj("'.self.name.'")'
                    exe 'au BufEnter <buffer> call s:InitObj("'.self.name.'")'
                    exe 'au '. self.au_group . ' <buffer> call s:OnHover("'.self.name.'")'
                    au! WinLeave,BufWinLeave <buffer> 2match none
                else
                    " echom 'au BufEnter,BufWinEnter * call s:InitObj("'.self.name.'")'
                    exe 'au BufEnter * call s:InitObj("'.self.name.'")'
                    exe 'au '. self.au_group . ' * call s:OnHover("'.self.name.'")'
                    au! WinLeave,BufWinLeave *  2match none
                endif
            aug END 
        endfun "}}}
        fun! ConfigQue.mapping() dict "{{{
            for mapping in self._mappings
                " replace < to [ to avoid parsed as raw mapping by vim
                let map2 = substitute(mapping, '<\([-0-9a-zA-Z]\+\)>','[\1]','g')

                if self.buffer_only
                    exe "nnoremap <silent><buffer> ".mapping." :call <SID>OnClick(\"".map2."\",\"". self.name ."\")<CR>"
                else
                    exe "nnoremap <silent> ".mapping." :call <SID>OnClick(\"".map2."\",\"". self.name ."\")<CR>"
                endif
            endfor
        endfun "}}}
        fun! ConfigQue.init_obj() dict "{{{
            " echom 'init' self.name bufname('%')
            for c in self.objects
                call c.init()
            endfor
        endfun "}}}
    
        let s:ConfigQue = ConfigQue
    endif

    return s:ConfigQue

endfun "}}}

if expand('<sfile>:p') == expand('%:p') "{{{
    call clickable#class#Class()
endif "}}}

let &cpo = s:cpo_save
unlet s:cpo_save
