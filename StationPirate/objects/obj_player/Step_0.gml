if alive
{
	//define keys
	var key_up=keyboard_check(ord("W"))
	var key_down=keyboard_check(ord("S"))
	var key_left=keyboard_check(ord("A"))
	var key_right=keyboard_check(ord("D"))
	var key_dash=keyboard_check_pressed(vk_space)
	var key_switch=mouse_check_button_pressed(mb_middle)
	
	//get rid of keys if running into wall because my tile collision code sucks and this is a stupid solution
	if tile_meeting(x,y-1,colmap) key_up=false
	if tile_meeting(x,y+1,colmap) key_down=false
	if tile_meeting(x-1,y,colmap) key_left=false
	if tile_meeting(x+1,y,colmap) key_right=false
	
	key_shoot=mouse_check_button(mb_left)
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
	
	//drop weapon
	if key_drop
	{
		var weapon_create_dir=point_direction(x,y,mouse_x,mouse_y)
		var weapon_x=x+lengthdir_x(24,weapon_create_dir)
		var weapon_y=y+lengthdir_y(24,weapon_create_dir)
		switch weaponSelected
		{
			case 0:
				if primary.display_name!="FISTS"
				{
					create_weapon(weapon_x,weapon_y,"",primary,primary.inReserve)
					primary=new weapon_fist(weaponTeams.player,id)
					primary.equip()
				}
				break
			case 1:
				if secondary.display_name!="FISTS"
				{
					create_weapon(weapon_x,weapon_y,"",secondary,secondary.inReserve)
					secondary=new weapon_fist(weaponTeams.player,id)
					secondary.equip()
				}
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
	if hp<1 && !global.godMode 
	{
		alive=false
		audio_play_sound(snd_playerDead,100,false)
	}
}
else
{
	hp=0
}