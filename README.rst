Clickable.vim
=============
    
    Make Things Clickable : ) 

    -- clickable.vim

:version: 0.91 alpha

:NOTE:

      **This Plugin Has Been Totally Rewrited!**

      **And It'S In Unstable State!**

      **Please Helping Finish it!**


I've write an intro in my blog(Chinese): http://rykka.me/rewrite_of_clickable.vim.html

Some Time are needed for further work.

Or your guys can contribute to it as you like~~






-------

**OLD README**



A vim plugin to make things in vim clickable.

.. image :: http://i.imgur.com/9T91tLb.gif

Usage
-----

By default, folding/links/files are made clickable:

**Links:**
    
    rykka@foxmail.com

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

    or

    ``NeoBundle "Rykka/clickable.vim"``


Options
-------


"g:clickable_filetypes"  

    default: ``'txt,javascript,css,html,py,vim,java,jade,c,cpp'``

    The buffer of these filetype will have clickable links

"g:clickable_extensions" 

    default: ``'txt,js,css,html,py,vim,java,jade,c,cpp'``

    File link of these extenstions will be clickable

"g:clickable_maps"   

    default: ``"<2-leftmouse>,<CR>,<S-CR>,<C-CR>,<C-2-leftmouse>,<s-2-leftmouse>,gn"``

    The mapping to trigger clickable

"g:clickable_confirm_creation" 

    default ``1``

    When file is nonexists, confirm for creation, When using Ctrl,
    This will be ignored.

"g:clickable_browser" 

    default ``"firefox"``

    browser for open links


Q & A
-----

1. Not HighLight with cursor hover.
   
   A: The matching is using '2match', 
   So may be conflicted with other highlighting plugins.
