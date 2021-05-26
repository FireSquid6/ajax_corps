//define keys
key_up=keyboard_check(ord("W"))
key_down=keyboard_check(ord("S"))
key_left=keyboard_check(ord("A"))
key_right=keyboard_check(ord("D"))

var movex=key_down-key_up
var movey=key_right-key_left


//move
x+=movex*walkspd
y+=movey*walkspd