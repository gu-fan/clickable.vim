" vim:tw=78:fdm=marker:
"
aug CLICKABLE_BUFFER
    " ~/.vimrc
    au! CursorMoved *  call riv#link#hi_hover()
    " clear the highlight before bufwin/winleave
    au! WinLeave,BufWinLeave     *  2match none
aug END
