SpecBegin 'title': 'Class'

let Class = clickable#class#init()

let hi = Class()
function hi.link()
    echo 1
endfunction
let t = hi.new()

It should have class
Should be equal t.is_instance, 1


It should have 
