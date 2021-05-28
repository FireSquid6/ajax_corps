//define keys
key_up=keyboard_check(ord("W"))
key_down=keyboard_check(ord("S"))
key_left=keyboard_check(ord("A"))
key_right=keyboard_check(ord("D"))

var movey=key_down-key_up
var movex=key_right-key_left

var xspd=WALK_SPD
var yspd=WALK_SPD

//collision check x
if tile_meeting(x+(movex*xspd),y,colmap)
{
	while !tile_meeting(x+movex,y,colmap)
	{
		x+=movex
	}
	movex=0
}

//collision check y
if tile_meeting(x,y+(movey*yspd),colmap)
{
	while !tile_meeting(x,y+movey,colmap)
	{
		y+=movey
	}
	movey=0
}

//move
x+=movex*xspd
y+=movey*yspd

if keyboard_check_pressed(ord("R")) game_restart()