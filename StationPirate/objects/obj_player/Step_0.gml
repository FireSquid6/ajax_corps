if keyboard_check(vk_lcontrol) room_speed=2 else room_speed=60
if keyboard_check(ord("G")) global.godMode=true
if alive
{
	//define keys
	var key_up=keyboard_check(ord("W"))
	var key_down=keyboard_check(ord("S"))
	var key_left=keyboard_check(ord("A"))
	var key_right=keyboard_check(ord("D"))
	var key_dash=keyboard_check_pressed(vk_space)

	key_shoot=mouse_check_button(mb_left)
	key_shoot_pressed=mouse_check_button_pressed(mb_left)
	key_reload=keyboard_check_pressed(ord("R"))

	//define locals
	var movey=key_down-key_up
	var movex=key_right-key_left

	#macro WALK_SPD 6
	var spd=WALK_SPD

	//initiate dash
	if (key_dash || dashBuffered) && dashCooldown<1 && (movex!=0 || movey!=0)
	{
		#macro MAX_DASH_COOLDOWN 25
		#macro DASH_FRAMES 10
		dashTime=DASH_FRAMES
		dashCooldown=MAX_DASH_COOLDOWN+DASH_FRAMES
		dashBuffered=false
	}
	else if (key_dash) && dashCooldown<11 && (movex!=0 || movey!=0) dashBuffered=true

	//during dash
	if dashTime>0
	{
		#macro DASH_SPD 12
		spd=DASH_SPD
	
		part_particles_create(global.partSystem,plr.x,plr.y,global.ptDashTrail,5)
		dashTime-=1
		image_blend=c_aqua
	}
	else image_blend=c_white
	if dashCooldown>0 dashCooldown--

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

	//move x
	x+=movex*spd
	x=floor(x)

	//collision check y
	if tile_meeting(x,y+(movey*spd),colmap)
	{
		while !tile_meeting(x,y+movey,colmap)
		{
			y+=movey
		}
		movey=0
	}

	//move y
	y+=movey*spd
	y=floor(y)

	if keyboard_check_pressed(vk_escape) game_restart()

	//weapon
	image_angle=point_direction(x,y,mouse_x,mouse_y)-90
	weapon.step()

	//check if dead
	if hp<1 && !global.godMode alive=false
}