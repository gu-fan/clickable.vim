Clickable.vim
=============
    
    Make Things Clickable : ) 

    -- clickable.vim

:version: 0.91 beta

A vim plugin to make things in vim clickable.

.. image :: http://i.imgur.com/9T91tLb.gif

What's New in 0.91
------------------

I've rewrite the clickable.vim to make it more usable.

It has syntax highlighting, hover function and click function.
And can be extened easily with your plugins.

Currently, This project focused on implmenting not performance, so maybe a
little bit slower.

(In fact, it has been optimized already. 
And maybe no more optimzation anymore.)

-------



Usage
-----

By default, folding/links/files are made clickable:

**Links:**
    
    rykka@foxmail.com

    NOTE: there is a known issus here. The 'Google Chrome' under 
    Mac OSX wil not open this as mail. But 'Firefox' works fine.

    http://127.0.0.1:3000

    www.google.com

    https://github.com/Rykka/clickable.vim/issues?q=is%3Aopen+sort%3Acreated-desc
    
**Files and Directories**

    autoload/clickable.vim

    ~/Documents/

    /usr/lib/nodejs/http.js

    

You can use ``<2-leftmouse>`` or ``<CR>`` to open them.

Combine with ``Shift`` and ``Control`` can also be used.

Whilst ``Shift`` means split,
And ``Control`` means create nonexists without confirm.

Install
-------

Using Vundle or NeoBundle, as always:

    ``Bundle "Rykka/clickable.vim"`` 
    ``Bundle "Rykka/os.vim"`` 

    or

    ``NeoBundle "Rykka/clickable.vim"``
    ``NeoBundle "Rykka/os.vim"`` 



Options
-------

**Options:**

options should be prefixed with `g:clickable_`.
e.g. `g:clickalbe_browser`

'browser':  'firefox'
    The default url browser.

'extensions': 'txt,js,css,html,py,vim,java,jade,c,cpp,rst,php,rb',
    The string with such extension will be considered as file pattern.
 
'prefix': '_clickable'
    used for prefixing syntax group name.

'ignored_buf': '^NERD',
    Clickable Ignored  buffer.

'maps': '<2-LeftMouse>,<C-2-LeftMouse>,<S-2-LeftMouse>,<CR>,<C-CR>,<S-CR>,<C-S-CR>'
    The mapping to trigger clickable.

'map_fallback': {'<C-CR>':'kJ'}
    The `map_fallback` option is used for default action
    for a mapping, when it's not triggering anything.

    When it's a string, it will be trigger as a mapping.

    Also it can be a function object.  see ':h funcref'.

'directory':  ''

    The 'clickable' plugin  directory.

Defining clickable plugins
--------------------------

For now, you can defining clickable plugin with your need.

Along with the `g:clickable_directory` directory,
clickable.vim will search all vim file under '&rtp/clickable' and source them.

So you can put your clickable config under 'your_plugin/clickable' directory.

These vim file must use  `clickable#export(object)` to export config queue object to clickable plugin.

**A minimal config for use.**

put it at ``your_plugin/clickable/your_plugin.vim``:

.. code:: vim
    
    " Don't pollute the global namespace
    function s:init() 
        
        " A Class
        let Class = clickable#class#init() 

        let Basic = clickable#class#basic#init() 

        let config = {}
        
        " Create a config object exteding from Basic config object.
        let config.hello = Class('hello', Basic, {
        \ 'name': 'hello',
        \ 'pattern': 'hello'
        \})
    

        " The trigger will be called when mapping are typed. 
        function config.hello.trigger(...) dict 
            echo 'Hello'
        endfunction

        call clickable#export(config)
    endfunction

    call s:init()


So this plugin will highlight all 'hello' with 'Underline', 
and when you click on it, it will echo 'hello'.


**A More specific description**

.. code:: vim

    let Class = clickable#class#init()

    " Basic Config Object
    " clickable.vim/autoload/class/basic.vim
    let Basic = clickable#class#basic#init()

    " Syntax Config Object, extened by File and Link
    " clickable.vim/autoload/class/syntax.vim
    let Syntax = clickable#class#syntax#init()

    " File Config Object, will open file when triggered.
    " clickable.vim/autoload/class/file.vim
    let File = clickable#class#file#init()

    " Link Config Object, will browse url when triggered.
    " clickable.vim/autoload/class/link.vim
    let Link = clickable#class#link#init()

    let local_config = {}

    " exteding the File Config object
    let local_config.test = Class('Test',File, {

        " config object's name
        \ 'name': 'test',

        " pattern for string matching
        \ 'pattern': 'test',

        " tooltip when showing
        \ 'tooltip': 'test:',

        " syntax group name for highlighting. will be prefixed
        \ 'syn_group': 'test',

        " syntax pattern seperator used for define pattern.
        " should not be duplicated with symbol used inside pattern.
        \ 'syn_sep': '`',

        " Highlight group name. The basic syntax highlighting.
        \ 'hl_group': 'Underlined',

        " Highlight group for hover.
        \ 'hover_hl_group': 'MoreMsg',

        " Highlight group for not exists. (used by File)
        \ 'noexists_hl_group': '',

        \})

    " validate function.
    " return 1 if the pattern is valid,
    " return 0 if not.
    function! local_config.test.validate(...) dict "{{{
        return 1
    endfunction "}}}

    " for post validate hook up
    fun! local_confg.test.post_validate() dict "{{{
    endfun "}}}

    " triggering function
    function! local_config.test.trigger(...) dict "{{{
        echo 'test'
    endfunction "}}}

    " Highlight function
    " Don't change this only if you know what you are doing
    function! local_config.test.highlight(...) dict "{{{
            let HL = get(a:000, 0 , 'IncSearch')
            let obj = self._hl.obj
            if has_key(obj, 'str')  
                let bgn = obj.bgn + 1
                let end = obj.end
                let row = self._hl.row
                let col = self._hl.col
        
                if obj.bgn < col && col <= obj.end + 1
                    execute '2match' HL.' /\%'.(row)
                                \.'l\%>'.(bgn-1) .'c\%<'.(end+1).'c/'
                    return 1
                endif

            endif

            return 0
    endfunction "}}}

    " Show Tooltip in cmdline
    fun! local_config.test.show_tooltip(tooltip) dict "{{{
        call clickable#echo(a:tooltip)
    endfun "}}}


    " Hover function. 
    " Don't change this only if you know what you are doing
    function! local_config.test.on_hover(...) dict "{{{
            if !empty(self.validate())
                call self.post_validate()
                call self.show_tooltip(self.tooltip)
                return 1
            else
                return 0
            endif
    endfunction "}}}

    " Click function
    " Don't change this only if you know what you are doing
    function! local_config.test.on_click(...) dict "{{{
            if !empty(self.validate())
                call self.post_validate()
                call self.trigger(a:mapping)
                return 1
            else
                return 0
            endif
    endfunction "}}}

you can check 'riv.vim/clickable' for a working view.

Maybe a detail intro is needed in the future.
So anyone can write one in english are welcome.

There is an (Chinese) intro in my blog: http://rykka.me/rewrite_of_clickable.vim.html


Q & A
-----

1. Not HighLight with cursor hover.
   
   A: The matching is using '2match', 
   So may be conflicted with other highlighting plugins.
