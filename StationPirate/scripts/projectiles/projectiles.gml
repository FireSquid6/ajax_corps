function projectile_create_popup()
{
	create_popup(inst.x,inst.y,string(dmg),fnt_popup_damage,get_popup_color(dmg),0.01,0.5,270)
}

function bullet_parent(_obj,_target) constructor
{
	inst=_obj
	target=_target
	
	check_alive=function()
	{
		if instance_exists(inst) return true else return false
	}
	
	step=function()
	{
		if check_alive()
		{
			//assist
			assist()
		
			//move
			move()
		
			//check col
			check_collision()
		
			//hit wall
			check_wall()
		
			//lifespan
			change_lifespan()
		}
	}
	
	move=function()
	{
		
	}
	
	assist=function()
	{
		
	}
	
	draw=function()
	{
		if check_alive()
		{
			with inst
			{
				draw_self()
			}
		}
	}
	
	check_collision=function()
	{
		var col=noone
		var targ=target
		with inst
		{
			if place_meeting(x,y,targ) col=instance_place(x,y,targ)
		}
		if col!=noone
		{ 
			deal_damage(dmg,col)
			
			//particles
			var p=global.ptBlood
			part_type_direction(p,dir+160,dir+200,0,0)
			part_particles_create(global.partSystem,col.x,col.y,p,8)
			
			instance_destroy(inst)
		}
		
	}
	
	check_wall=function()
	{
		with inst
		{
			if tile_meeting(x,y,global.collisionTilemap) instance_destroy()
		}
	}
	
	change_lifespan=function()
	{
		lifespan--
		if lifespan==0 instance_destroy(inst)
	}
}

function melee(_obj,_target,_link,_sprite,_dmg,_lifespan,_dir,_dist,_flashDmg,_sound) : bullet_parent(_obj,_target) constructor
{
	
	link=_link
	inst.sprite_index=_sprite
	inst.image_angle=_dir-90
	dir=_dir
	dist=_dist
	sound=_sound
	
	dmg=_dmg
	lifespan=_lifespan
	flashDmg=_flashDmg
	
	check_alive=function()
	{
		if instance_exists(inst) && instance_exists(link) return true else return false
	}
	
	move=function()
	{
		inst.x=link.x+lengthdir_x(dist,dir)
		inst.y=link.y+lengthdir_y(dist,dir)
	}
}

function projectile(_obj,_target,_sprite,_dmg,_spd,_lifespan,_assistFrames,_findDir,_flashDmg,_sound) : bullet_parent(_obj,_target) constructor
{	
	inst=_obj
	target=_target
	inst.sprite_index=_sprite
	
	dmg=_dmg
	spd=_spd
	lifespan=_lifespan
	flashDmg=_flashDmg
	sound=_sound
	
	assistFrames=_assistFrames
	findDir=_findDir
	dir=findDir()
	inst.image_angle=dir-90
	
	findSpd=function()
	{
		if obj_player.slowFieldEnabled
		{
			with obj_player
			{
				var col=collision_circle(x,y,ENERGY_FIELD_SIZE,other.inst,false,true)
			}
			if col!=noone return floor(spd*(0.2)) else return spd
		}
		else return spd
	}
	
	assist=function()
	{
		//assist
		if assistFrames>0
		{
			dir=findDir()
			inst.image_angle=dir-90
			assistFrames--
		}
	}
	
	move=function()
	{
		var moveSpd=findSpd()
		inst.x+=lengthdir_x(moveSpd,dir)
		inst.y+=lengthdir_y(moveSpd,dir)
	}
}

function blast(_obj,_target,_sprite,_dmg,_spd,_lifespan,_assistFrames,_findDir,_flashDmg,_sound,_spdDecay)
: projectile(_obj,_target,_sprite,_dmg,_spd,_lifespan,_assistFrames,_findDir,_flashDmg,_sound) constructor
{
	decay=_spdDecay
	
	move=function()
	{
		spd-=decay
		if spd<0 instance_destroy(inst)
		
		var moveSpd=findSpd()
		inst.x+=lengthdir_x(moveSpd,dir)
		inst.y+=lengthdir_y(moveSpd,dir)
	}
}

function fragment(_obj,_target,_sprite,_dmg,_spd,_lifespan,_assistFrames,_findDir,_flashDmg,_sound,_spread) 
: projectile(_obj,_target,_sprite,_dmg,_spd,_lifespan,_assistFrames,_findDir,_flashDmg,_sound) constructor
{
	spread=_spread
	dir+=(random_range((spread*-1),spread))
	
	assist=function()
	{
		assistFrames=0
	}
}