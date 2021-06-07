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
	var key_switch=mouse_check_button_pressed(mb_middle)
	
	key_shoot=mouse_check_button(mb_left)
	key_shoot_pressed=mouse_check_button_pressed(mb_left)
	key_reload=keyboard_check_pressed(ord("R"))
	key_drop=keyboard_check_pressed(ord("Q"))
	key_interact=keyboard_check_pressed(ord("E"))

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
		audio_play_sound(snd_dash,dashPriority,false)
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
	
	//drop weapon
	if key_drop
	{
		switch weaponSelected
		{
			case 0:
				create_weapon(x,y,"",primary,primary.inReserve)
				primary=new weapon_fist(weaponTeams.player,id)
				primary.equip()
				break
			case 1:
				create_weapon(x,y,"",secondary,secondary.inReserve)
				secondary=new weapon_fist(weaponTeams.player,id)
				secondary.equip()
				break
		}
	}
	
	//interactables
	var intList=ds_list_create()
	collision_circle_list(x,y,pickupRange,par_interactable,false,true,intList,true)
	interactableSelected=ds_list_find_value(intList,0)
	
	//weapon
	image_angle=point_direction(x,y,mouse_x,mouse_y)-90
	if key_switch 
	{
		weaponSelected=!weaponSelected
		switch weaponSelected
		{
			case 0:
				primary.equip()
				break
			case 1:
				secondary.equip()
				break
		}
	}
	switch weaponSelected
	{
		case 0:
			primary.step()
			break
		case 1:
			secondary.step()
			break
	}

	//check if dead
	if hp<1 && !global.godMode alive=false
}