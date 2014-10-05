"=============================================
"  Plugin: Clickable.vim
"  File:   autoload/clickable/config.vim
"  Author: Rykka<rykka@foxmail.com>
"  Update: 2014-09-30
"=============================================
let s:cpo_save = &cpo
set cpo-=C

" The Config object will load all configs 
" from vim file and clickable_type file
"
" then wrap them in a config object and push in a config queue.
"   There are two kind of queue:
"
"   The All Queue: for all file 
"   The FileType Queue: a dict of ft:queues.
"
"
" Then When executing in buffer,
" The relevent config object will be load
" Then highlight/hover/click/navigate events will be added
" and be triggered at the right time.

let g:clickable_prefix = '_clickable_'
let g:clickable_extensions = 'txt,js,css,html,py,vim,java,jade,c,cpp'

fun! s:load_config_queue(var, ...) "{{{
    " Load Config from local Var, 
    " And optionally 
    "   local file
    "   remote file
    
    " Create A Config Class
    let Class = clickable#class#Class()
    " let Config = Class('Config',{'FileType':{}, 'All':[] })

    let g:_clickable_config_queue = {}
    let s:_ConfigQue = g:_clickable_config_queue

    let ConfigQue = clickable#class#ConfigQue()
    
    " Create A config Instance
    " have config instance
    " let config = {}
    " let config.ALL = Config.new({'name': 'ALL'})
    let s:_ConfigQue.ALL = ConfigQue.new({'name': 'ALL', 'buffer_only':0})
    " Load All Configs
    let all_configs = a:var
    
    " put config into FileType queue and All queue.
    for key in keys(all_configs)
        if has_key(all_configs[key], 'filetype')
            for ft in split(all_configs[key]['filetype'],',')
                if !exists("s:_ConfigQue[ft]")
                    let s:_ConfigQue[ft] = ConfigQue.new({'name':ft, 'extend':'ALL'})
                endif
                call add(s:_ConfigQue[ft].objects, all_configs[key])
            endfor
        else
            call add(s:_ConfigQue.ALL.objects, all_configs[key])
        endif
    endfor

    " call clickable#util#BEcho(len(s:_ConfigQue.ALL.objects))
    " call clickable#util#BEcho(len(s:_ConfigQue.javascript.objects))

    " return the config object
    return s:_ConfigQue
endfun "}}}

fun! clickable#config#init() "{{{


    let Class = clickable#class#Class()
    let Basic = clickable#class#Basic()
    let File = clickable#class#File()
    let Link = clickable#class#Link()

    " let Config = clickable#class#Config()
    let local_config = {}

    let local_config.mail = Class('Mail',Link, {
        \ 'name': 'mail',
        \ 'pattern': '\v<[[:alnum:]_-]+%(\.[[:alnum:]_-]+)*[@#][[:alnum:]]%([[:alnum:]-]*[[:alnum:]]\.)+[[:alnum:]]%([[:alnum:]-]*[[:alnum:]])=>',
        \ 'tooltip': 'mail:',
        \})

    function! local_config.mail.trigger(...) dict "{{{
        let mail = 'mailto:'. self._hl.obj.str
        let mail = substitute(mail, '#', '@', '')
        call clickable#util#system(self.browser.' '.mail)  
    endfunction "}}}

    let local_config.link = Class(Link, {
        \ 'name': 'link',
        \ 'pattern': 
        \ '\v<%(%(file|https=|ftp|gopher)://|%(mailto|news):)([^[:space:]''\"<>]+[[:alnum:]/])|<www[[:alnum:]_-]*\.[[:alnum:]_-]+\.[^[:space:]''\"<>]+[[:alnum:]/]',
        \ 'tooltip': 'link:',
        \})

    let local_config.file = Class(File, {
        \ 'name': 'file',
        \ 'tooltip': 'file:',
        \ 'filetype': 'vim',
        \})

    " let local_config.file.filetype = 'vim'


    let fname_bgn = '%(^|\s|[''"([{<,;!?])'
    let fname_end = '%($|\s|[''")\]}>:.,;!?])'
    let file_ext_lst = clickable#pattern#norm_list(split(g:clickable_extensions,','))
    let file_ext_ptn = join(file_ext_lst,'|')

    let file_name = '[[:alnum:]~./][[:alnum:]~:./\\_-]*[[:alnum:]/\\]'
    let local_config.file.pattern  = '\v' . fname_bgn
                \. '@<=' . file_name
                \.'%(\.%('. file_ext_ptn .')|/)\ze'
                \.fname_end 
    " let local_config.file.pattern = 'tevim'
    " echo local_config.file.pattern
    " echo '12312' =~ local_config.file.pattern
    " echo '" Load mappings/commands etc' =~ local_config.file.pattern


    let local_config.folding = Class('Folding', Basic, {
        \ 'name': 'folding',
        \ 'tooltip': 'This is a closed folding',
        \})
    function! local_config.folding.validate(...) dict "{{{
        return foldclosed('.') != -1
    endfunction "}}}
    function! local_config.folding.trigger(...) dict "{{{
        exe "norm! zv"
    endfunction "}}}

    let local_config.fold_marker = Class('FoldMarker', Basic, {
        \ 'name': 'fold_marker',
        \ 'tooltip': 'This is a fold marker',
        \})
    function! local_config.fold_marker.validate(...) dict "{{{
        return &fdm == 'marker' && getline('.') =~ split(&foldmarker,',')[0].'\s*$' && foldclosed('.') == -1
    endfunction "}}}
    function! local_config.fold_marker.trigger(...) dict "{{{
        exe "norm! zc"
    endfunction "}}}

    return s:load_config_queue(local_config)
endfun "}}}

if expand('<sfile>:p') == expand('%:p') "{{{
    call clickable#util#BEcho(clickable#config#init())
endif "}}}

let &cpo = s:cpo_save
unlet s:cpo_save
