"=============================================
"  Plugin: config_queue.vim
"    File: config_queue.vim
"  Author: Rykka<rykka@foxmail.com>
"  Update: 2014-10-22
"=============================================
let s:cpo_save = &cpo
set cpo-=C

" The global function, with name as the key of object
" then map it with the objects

fun! s:OnHover(name) "{{{
    " inited ConfigQue
   
    " buffer var to check if highlighted by any group
    if !exists("b:clickable_hover") 
        let b:clickable_hover = {}
    endif
    let n = a:name
    let objects = copy(s:_ConfigQue[n].objects)
    " if has_key(s:_ConfigQue[a:name], 'extend')
    "     let ext = s:_ConfigQue[a:name].extend
    "     call extend(objects, s:_ConfigQue[ext].objects )
    " endif
    let b:clickable_hover[n] = 0
    for obj in objects
        " call obj.on_{self.name}()
        " exe 'let e = obj.on_'.self.name.'()'
        let b:clickable_hover[n] = obj.on_hover()
        if b:clickable_hover[n] == 1
            break
        endif
    endfor

    let e = 0
    for v in values(b:clickable_hover)
        let e += v
    endfor

    if e == 0
        call clickable#util#clear_highlight()
    endif
endfun "}}}
fun! s:OnClick(mapping, name) "{{{
    let e = 0
    let objects = copy(s:_ConfigQue[a:name].objects)
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
    let objects = copy(s:_ConfigQue[n].objects)
    
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

fun! clickable#class#config_queue#init() "{{{
    " The config Queue for control the config items.

    if !exists("s:ConfigQue")
    " if 1

        let s:_ConfigQue = g:_clickable_config_queue

        let Class = clickable#class#init()

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

let &cpo = s:cpo_save
unlet s:cpo_save
