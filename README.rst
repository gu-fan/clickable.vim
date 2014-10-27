clickable.vim
=============
    
    Make Things Clickable : ) 

    -- clickable.vim

:version: 0.91 beta

Make things clickable, even in vim.


An old image but shows how it works.

.. image :: http://i.imgur.com/9T91tLb.gif

What's New in 0.91
------------------

I've rewrite the clickable.vim to make it more usable.

It has syntax highlighting, hover function and click function.

And can be easily extened.

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

**And More Clickable Things**

You can add 'rykka/clickable-things' to your bundle to include more clickable
things.

Like bundle: clicking the 'Bundle "xxx/xxx"' will jump to the bundle directory directly.

see clickable-things_.

Also you can define your own clickable things easily.

Install
-------

Using Vundle or NeoBundle, as always::

    Bundle "Rykka/clickable.vim"
    Bundle "Rykka/clickable-things"
    Bundle "Rykka/os.vim"

or ``NeoBundle``

the os.vim may migrate to vital.vim sooner or later.
but for now, just keep it there.

Options
-------

Options will be prefixed with ``g:clickable_``.

e.g.:

You can set 'browser' options by ``g:clickable_browser``

You can get it's value by ``clickable#get_opt('browser')``

'browser':  'firefox'
    For Links, The default url browser.

'extensions': 'txt,js,css,html,py,vim,java,jade,c,cpp,rst,php,rb',
    For Files, Strings with such extension will be considered as a file.
 

'ignored_buf': '^NERD',
    The buffer name matched will be ignored by clickable.vim

'maps': '<2-LeftMouse>,<C-2-LeftMouse>,<S-2-LeftMouse>,<CR>,<C-CR>,<S-CR>,<C-S-CR>'
    The mapping to trigger clickable 'click' action.

'map_fallback': {'<C-CR>':'kJ'}
    Default action when a 'click' action does not trigger any clickable item.

    When it's a string, it will be triggered as a mapping.

    When it's function object, it will be called. (see ':h funcref')

'directory':  ''
    The Additional 'clickable' plugin directory, to store your own items.

'prefix': '_clickable'
    Used for prefixing syntax group name. Change this only if there is a syntax name
    conflict, which should never happen though.

Defining clickable plugins
--------------------------

For now, you can defining clickable plugin with your need.

Along with the `g:clickable_directory` directory,
clickable.vim will search all vim file under '&rtp/clickable' and source them.

So you can put your clickable config under 'your_plugin/clickable' directory.

These vim file must use  `clickable#export(object)` to export config queue object to clickable plugin.


NOTE:  Syntax Match First.

When things not highlighted/hovered/triggered.

You should know that the Syntax Object's validation is based on the syntax item. 
So make sure it's correctly syntax matched with your pattern.


**A minimal config for use.**

put it at ``your_plugin/clickable/your_plugin.vim``:

.. code:: vim
    
    " Don't pollute the global namespace
    function s:init() 
        
        " A Class
        let Class = clickable#class#init() 

        let Basic = clickable#class#basic#init() 

        
        " Create a config object exteding from Basic config object.
        let hello = Class('hello', Basic, {
        \ 'name': 'hello',
        \ 'pattern': 'hello',
        \ 'hl_group': 'Keyword',
        \})
    

        " The trigger will be called when mapping are typed. 
        function hello.trigger(...) dict 
            echo 'Hello'
        endfunction

        let config = {'hello': hello}
        call clickable#export(config)
    endfunction

    call s:init()


So this plugin will highlight all 'hello' with 'Keyword' group, 
and when you click on it, it will echo 'hello'.

----

**A More Specific Description**

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

        " Valid when filetype is vim or html
        \ 'filetype': 'vim,html',

        " tooltip when showing
        \ 'tooltip': 'test:',

        " syntax group name for highlighting. will be prefixed
        \ 'syn_group': 'test',

        " syntax pattern seperator used for define pattern
        " should not be duplicated with symbol used inside pattern
        \ 'syn_sep': '`',

        " Additional syntax arguments.
        " when empty it will be set to 'containedin=ALLBUT,_clickable.*'
        " If you want to make your pattern doesn't have visual effect.
        " You can use 'containedin=.* transparent'
        " See ':h syn-arguments' for details
        \ 'syn_args': '',

        " Highlight group name. The basic syntax highlighting
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

    " triggering functio, should return 1 if triggered.
    function! local_config.test.trigger(...) dict "{{{
        echo 'test'
        return 1
    endfunction "}}}

    " Highlight function, should return 1 if highlighted
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


    " Hover function. should return 1 if highlighted
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
   
    " for file object only.
    " return 1 if exists
    fun! local_config.test.is_file_exists() dict "{{{
        return isdirectory(self.full_path) || filereadable(self.full_path) 
    endfun "}}}


You can check clickable-things_ for working examples.


Maybe a detail intro is needed in the future.
So anyone can write one in english are welcome.

There is an (Chinese) intro in my blog: http://rykka.me/rewrite_of_clickable.vim.html


Issues
-----

Please post issues at Github.

1. Not HighLight with cursor hover.
   
   The matching is using '2match', 
   So may be conflicted with other highlighting plugins.



.. _clickable-things: https://github.com/Rykka/clickable-things
