" www.163.com
"
call clickable#init()



" SYNTAX LOADING TEST
"
" fun! s:test() "{{{
"     syn match _clickable_augo `gogogo` containedin=.*
"     hi link _clickable_augo MoreMsg
" endfun "}}}
"
" fun! s:test_au(type) "{{{
"     aug CLICKABLE_TEST
"         exe 'au '.a:type.' *  call s:test()'
"     aug END
" endfun "}}}
"
" NO
" call s:test()
" call s:test_au('FileType')
" call s:test_au('Syntax')
" call s:test_au('BufRead')
" call s:test_au('BufNew')
" call s:test_au('BufWinEnter')
" call s:test_au('FileRead')

" WORKS
" call s:test_au('WinEnter')

" WORKS BUT NEVER USE
" call s:test_au('CursorMoved')

" Can be used.
" call s:test_au('BufEnter')
