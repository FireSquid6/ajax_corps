function projectile_create_popup()
{
	create_popup(inst.x,inst.y,string(dmg),fnt_popup_damage,get_popup_color(dmg),0.01,0.5,270)
}

function is_invincible(_id)
{
	if variable_instance_exists(_id,"dashTime")
	{
		if _id.dashTime>0 return true else return false
	}
}

function bullet_parent(_obj,_target) constructor
{
	inst=_obj
	target=_target
}

function melee(_obj,_target,_link,_sprite,_dmg,_lifespan,_dir,_dist,_flashDmg,_sound) constructor
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
	
	step=function()
	{
		if instance_exists(link)
		{
			var col=noone
			var targ=target
		
			//move
			inst.x=link.x+lengthdir_x(dist,dir)
			inst.y=link.y+lengthdir_y(dist,dir)
		
			//check col
			with inst
			{
				col=instance_place(x,y,targ)
				if is_invincible(col) col=noone
			}
			if col!=noone
			{
				col.lastHit=0
				
				//particles
				var p=global.ptBlood
				part_type_direction(p,dir+160,dir+200,0,0)
				part_particles_create(global.partSystem,col.x,col.y,p,8)
			
				//damage
				col.hp-=dmg
				col.flashTime=flashDmg
			
				//popup
				projectile_create_popup()
			
				//sound
				audio_play_sound(sound,hitPriority,false)
				
				//destroy
				instance_destroy(inst)
			}
		
			//hit wall
			with inst
			{
				if tile_meeting(x,y,global.collisionTilemap) instance_destroy()
			}
		
			//lifespan
			lifespan--
			if lifespan==0 instance_destroy(inst)
		}
		else instance_destroy(inst)
	}
	
	draw=function()
	{
		with inst
		{
			draw_self()
		}
	}
}

function projectile(_obj,_target,_sprite,_dmg,_spd,_lifespan,_assistFrames,_findDir,_flashDmg,_sound) constructor
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
	
	check_collision=function()
	{
		var col=noone
		var targ=target
		with inst
		{
			col=instance_place(x,y,targ)
			if is_invincible(col) col=noone
		}
		if col!=noone
		{
			col.lastHit=0
			//particles
			var p=global.ptBlood
			part_type_direction(p,dir+160,dir+200,0,0)
			part_particles_create(global.partSystem,col.x,col.y,p,8)
			
			//damage
			col.hp-=dmg
			col.flashTime=flashDmg
			
			//sound
			audio_play_sound(sound,hitPriority,false)
			
			//popup
			projectile_create_popup()
				
			//destroy
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
		inst.x+=lengthdir_x(spd,dir)
		inst.y+=lengthdir_y(spd,dir)
	}
	
	step=function()
	{
		if instance_exists(inst)
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
			lifespan--
			if lifespan==0 instance_destroy(inst)
		}
	}
	
	draw=function()
	{
		with inst
		{
			draw_self()
		}
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
		inst.x+=lengthdir_x(spd,dir)
		inst.y+=lengthdir_y(spd,dir)
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