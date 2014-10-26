Clickable.vim
=============
    
    Make Things Clickable : ) 

    -- clickable.vim

:version: 0.91 beta

A vim plugin to make things in vim clickable.

.. image :: http://i.imgur.com/9T91tLb.gif

What's New in 0.91
------------------

I've rewrite the clickable.vim to make it more scalable.

There is an intro in my blog(Chinese): http://rykka.me/rewrite_of_clickable.vim.html

Currently, This project focused on implmenting not performance, so maybe a
little bit slower.

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


'ignored_buf': '^NERD',
    Clickable Ignored  buffer.

'maps': '<2-LeftMouse>,<C-2-LeftMouse>,<S-2-LeftMouse>,<CR>,<C-CR>,<S-CR>,<C-S-CR>'
    The mapping to trigger clickable.

'map_fallback': {'<C-CR>':'kJ'}
    the `map_fallback` option is used for default action
    for a mapping, when it's not triggered by the event.

    it can be a function object.  see ':h funcref'.

'directory':  ''

    The 'clickable' plugin  directory.

Defining clickable plugins
--------------------------


Along with the `g:clickable_directory` directory, clickable.vim will search all vim file under '&rtp/clickable' and
source them.

These vim file must use  `clickable#export(object)` to export config object
to clickable plugin.

you can check 'riv.vim/clickable' for a detail view.




Q & A
-----

1. Not HighLight with cursor hover.
   
   A: The matching is using '2match', 
   So may be conflicted with other highlighting plugins.
