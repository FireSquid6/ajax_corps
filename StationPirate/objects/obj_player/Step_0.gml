//define keys
var key_up=keyboard_check(ord("W"))
var key_down=keyboard_check(ord("S"))
var key_left=keyboard_check(ord("A"))
var key_right=keyboard_check(ord("D"))
var key_dash=keyboard_check(vk_space)

var movey=key_down-key_up
var movex=key_right-key_left

#macro WALK_SPD 6
var spd=WALK_SPD

//initiate dash
if key_dash && dashCooldown<1 && (movex!=0 || movey!=0)
{
	#macro MAX_DASH_COOLDOWN 25
	#macro DASH_FRAMES 10
	dashTime=DASH_FRAMES
	dashCooldown=MAX_DASH_COOLDOWN+DASH_FRAMES
	
}

//during dash
if dashTime>0
{
	#macro DASH_SPD 12
	spd=DASH_SPD
	dashTime-=1
	image_blend=c_aqua
}
else image_blend=c_white
dashCooldown--

//COLLISIONS
#macro colmap global.collisionTilemap
//collision check x
if tile_meeting(x+(movex*spd),y,colmap)
{
	while !tile_meeting(x+movex,y,colmap)
	{
		x+=movex
	}
	movex=0
}

//collision check y
if tile_meeting(x,y+(movey*spd),colmap)
{
	while !tile_meeting(x,y+movey,colmap)
	{
		y+=movey
	}
	movey=0
}

//move
x+=movex*spd
y+=movey*spd

if keyboard_check_pressed(ord("R")) game_restart()

//check if dead
player_dead=function()
{
	instance_destroy(obj_player)
	//instance_create(x,y,"lay_player",obj_playerDead)
}
if hp<1 player_dead()