function melee(_obj,_target,_link,_sprite,_dmg,_lifespan,_dir,_dist,_flashDmg,_sound) constructor
{
	inst=_obj
	target=_target
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
			}
			if col!=noone
			{
				//particles
				var p=global.ptBlood
				part_type_direction(p,dir+160,dir+200,0,0)
				part_particles_create(global.partSystem,col.x,col.y,p,8)
			
				//damage
				col.hp-=dmg
				col.flashTime=flashDmg
			
				//knockback
			
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
	
	step=function()
	{
		if instance_exists(inst)
		{
			//assist
			if assistFrames>0
			{
				dir=findDir()
			}
			if assistFrames>0 assistFrames--
		
			//move
			inst.x+=lengthdir_x(spd,dir)
			inst.y+=lengthdir_y(spd,dir)
		
			var col=noone
			var targ=target
		
			//check col
			with inst
			{
				col=instance_place(x,y,targ)
			}
			if col!=noone
			{
				//particles
				var p=global.ptBlood
				part_type_direction(p,dir+160,dir+200,0,0)
				part_particles_create(global.partSystem,col.x,col.y,p,8)
			
				//damage
				col.hp-=dmg
				col.flashTime=flashDmg
			
				//knockback
			
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
	}
	draw=function()
	{
		with inst
		{
			draw_self()
		}
	}
}