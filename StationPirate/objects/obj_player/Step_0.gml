//define keys
key_up=keyboard_check(ord("W"))
key_down=keyboard_check(ord("S"))
key_left=keyboard_check(ord("A"))
key_right=keyboard_check(ord("D"))
var key_dash=keyboard_check_pressed(vk_space)

key_shield=mouse_check_button(mb_right) || keyboard_check(ord("V"))
key_shoot=(mouse_check_button(mb_left))
key_reload=keyboard_check_pressed(ord("R"))
key_drop=keyboard_check_pressed(ord("Q"))
key_interact=keyboard_check_pressed(ord("E"))

if alive
{
	//define locals
	var movey=key_down-key_up
	var movex=key_right-key_left
	
	var spd=WALK_SPD

	//initiate dash
	if (key_dash || dashBuffered) && dashCooldown<1 && (movex!=0 || movey!=0)
	{
		dashTime=DASH_FRAMES
		dashCooldown=MAX_DASH_COOLDOWN+DASH_FRAMES
		dashBuffered=false
		audio_play_sound(snd_dash,dashPriority,false)
	}
	else if (key_dash) && dashCooldown<11 && (movex!=0 || movey!=0) dashBuffered=true

	//during dash
	if dashTime>0
	{
		spd=DASH_SPD
		
		var list=ds_list_create()
		var targ
		
		collision_circle_list(x,y,DASH_SHIELD_RADIUS,par_bullet,false,true,list,false)
		while ds_list_size(list)>0
		{
			targ=ds_list_find_value(list,0)
			instance_destroy(targ)
			ds_list_delete(list,0)
		}
		
		part_particles_create(global.partSystem,obj_player.x,obj_player.y,global.ptDashTrail,5)
		dashTime-=1
		image_blend=c_aqua
	}
	else image_blend=c_white
	if dashCooldown>0 dashCooldown--

	//set spd
	hsp=spd*movex
	vsp=spd*movey

	//collision setup
	#macro colmap global.collisionTilemap
	var bbox_side
	
	//collision check x
	if(hsp>0) bbox_side=bbox_right else bbox_side=bbox_left
	if (tilemap_get_at_pixel(colmap,bbox_side+hsp,bbox_top) !=0)
	|| (tilemap_get_at_pixel(colmap,bbox_side+hsp,bbox_bottom) !=0)
	{
		if (hsp>0)
		{
			x=x-(x mod 32) + (31) - (bbox_right-x)
		}
		else
		{
			x=x-(x mod 32) - (bbox_left-x)
		}
		hsp=0
	}

	//move x
	x+=hsp

	//collision check y
	if (vsp>0) bbox_side=bbox_bottom else bbox_side=bbox_top
	if (tilemap_get_at_pixel(colmap,bbox_left,bbox_side+vsp) !=0)
	|| (tilemap_get_at_pixel(colmap,bbox_right,bbox_side+vsp) !=0)
	{
		if (vsp>0)
		{
			y=y-(y mod 32) + (31) - (bbox_bottom-y)
		}
		else
		{
			y=y-(y mod 32) - (bbox_top-y)
		}
		vsp=0
	}

	//move y
	y+=vsp
	
	//drop weapon
	if key_drop && weapon.display_name!="FISTS"
	{
		var weapon_create_dir=point_direction(x,y,mouse_x,mouse_y)
		var weapon_x=x+lengthdir_x(24,weapon_create_dir)
		var weapon_y=y+lengthdir_y(24,weapon_create_dir)
		create_pickup_weapon(weapon_x,weapon_y,get_weapon_string(weapon),weapon.inReserve)
		weapon=new weapon_fist(weaponTeams.player,id)
		weapon.equip()
	}
	
	//interactables
	var intList=ds_list_create()
	collision_circle_list(x,y,pickupRange,par_interactable,false,true,intList,true)
	interactableSelected=ds_list_find_value(intList,0)
	
	//ammo alpha
	if weapon.id!=weaponIds.fist
	{
		if weapon.lastShot>60 ammoAlpha-=0.05 else ammoAlpha=1
		ammoAlpha=clamp(ammoAlpha,0,1)
	}
	
	//weapon
	image_angle=point_direction(x,y,mouse_x,mouse_y)-90
	weapon.step()
	
	//check if dead
	if hp<1 && !global.godMode 
	{
		part_particles_create(global.partSystem,x,y,global.ptDead,DEAD_PARTICLES_AMMOUNT)
		alive=false
		audio_play_sound(snd_playerDead,playerDeadPriority,false)
		sprite_index=spr_cross
	}
	
	lastHit++
	lastHit=clamp(lastHit,0,MAX_LAST_HIT)
	
	//TIME SLOWDOWN
	//make all bullets fast
	slowFieldEnabled=false
	
	//check if in shield
	if energy>0 && energyCooldown<1
	{
		//actvate
		if key_shield
		{
			//set vars
			canStop=true;
			energy-=ENERGY_LOSS;
			
			//set enabled
			slowFieldEnabled=true
		}
		
		//reset
		if (canStop=true && !key_shield)|| energy<1
		{
			energyCooldown=MAX_ENERGY_COOLDOWN;
			canStop=false;
		}
	}
	
	//regen
	if !key_shield && energyCooldown<1
	{
		energy+=ENERGY_GAIN
		energy=clamp(energy,0,MAX_ENERGY)
	}
	
	energyCooldown--;
	energyCooldown=clamp(energyCooldown,0,MAX_ENERGY_COOLDOWN);
}
else
{
	//part_particles_create(global.partSystem,x,y,global.ptDead,DEAD_PARTICLES_AMMOUNT)
	hp=0
	if key_reload room_restart()
}

