//define keys
key_up=keyboard_check(ord("W"))
key_down=keyboard_check(ord("S"))
key_left=keyboard_check(ord("A"))
key_right=keyboard_check(ord("D"))

var movey=key_down-key_up
var movex=key_right-key_left

//collision check x
if tile_meeting(x+(movex*walkspd),y,"collision")
{
	while !tile_meeting(x+movex,y,"collision")
	{
		x+=movex
	}
	movex=0
}

//collision check y
if tile_meeting(x,y+(movey*walkspd),"collision")
{
	while !tile_meeting(x,y+movey,"collision")
	{
		x+=movex
	}
	movex=0
}

//move
x+=movex*walkspd
y+=movey*walkspd