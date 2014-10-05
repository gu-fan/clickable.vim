DESIGN 
======

What do we do when we design a vim plugin?

TARGET
------

1. MouseOver: Highlight Clickable Item, And Show Tips.
2. Click: Executing the Desired Function
   Based on Target Pattern 
   And FileType 
   And Project Type(File Place).

PROCEDURE
---------

1. INIT CONFIG
2. BUF INIT AND CHECK BUF ENV(PROJECT/ROOT/CACHE...).
3. CURSOR

   IF MATCH PTN: HIGHLIGHT AND SHOW TIP
       IF CLICK(CLICK_MAPPING[MOUSELEFT/CR]): TRIGGER ACTION
           IF SHIFT: SPLIT WINDOW AND JUMP(IF IS A VIM BUFFER)
           IF CONTROL??: WITHOUT ASKING CREATING (IF EMPTY FILE)
           (ALIAS: QUITE MODE FOR SPEED UP ACTION)
4. JUMP TO NEXT/PREV CLICKABLE (TAB/S-TAB)

LAYER
-----


CONFIG LAYER

1. CONFIG
2. BUF CONFIG


INIT LAYER

3. BUF INIT
4. PTN DEFINE
5. Map DEFINE ( Do We REALLY NEED NEW MAPS?)
   
   NORMAL/VISUAL

       2-MOUSELEFT
       CR
       gF


   NORMAL

       TAB
       S-TAB

TRIGGER LAYER

5. CURSOR CHECK
6. HIGHLIGHT
7. TOOLTIP
8. CLICKING TRIGGER
9. NAV NEXT/PREV

API
---

LOAD CONFIG
    
    " basic config
    config = clickable#load_config

INIT CONFIG

    " normalized config
    config = clickable#init_config


INIT BUFFER


INIT BUF CONFIG
    buf_config = clickable#buf_init_config
INIT BUF PTN
    buf_ptn = clickable#buf_init_ptn
INIT BUF MAP
    clickable#buf_init_map


TRIGGERING

    buffer_highlight 
        highlight pattern.
        (use syn highlight)

        syn match ModeMsg 'ptn' containedin=.*

    cursor_check

        check move_out_hl_region and change_tick

        for config_object of current env, check if it's right ptn

        return a clickable object.

    on hover

        cursor_check

        obj.highlight

    on click

        cursor_check

        obj.trigger

    CACHE OBJECT
        IF NOT MOVED OUT OF REGION RETURNS CACHE ONE.

    CLICKABLE OBJECT:

        name: (namespace)
        pattern:
        highlight_pattern:
        highlight_group:
        contained_in_group
        
        validate_function: check if it's the pattern for the env.
            returns row,col,ptn_obj if it is

        highlight_function:
            highlight the ptn_obj at row, col

        trigger_function:
            action 
            

        existense_function:
        noexist_hl_group:

    BASIC_config_object:

        name: (namespace)
        pattern:
        highlight_pattern:
        highlight_group:

        filetype: for the filetype only.
        buffer: for buffer match the pattern.

        validate_function: 

        highlight_function:
        trigger_function:
        

    navigate/prev/next


    
LAYOUT
------
autoload/clickable/ ::

    config
    init
    buffer
    pattern
    mapping

    trigger

        highlight
        action
        navigate(prev/next)

    test







