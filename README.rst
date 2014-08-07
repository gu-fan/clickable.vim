Clickable.vim
=============
    
    Make Things Clickable : ) 

    -- clickable.vim

:version: 0.6

A vim plugin to make things in vim clickable.

By default, folding, links, files are clickable.

You can use ``<2-leftmouse>`` or ``<CR>`` to open these link.

Install
-------

Using Vundle or NeoBundle, as alwasy::

``Bundle "Rykka/clickable.vim"`` or ``NeoBundle "Rykka/clickable.vim"``


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

    When file is nonexists, confirm for creation

"g:clickable_browser" 

    default ``"firefox"``

    browser for open links
