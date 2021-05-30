function projectile(_obj,_target,_sprite,_dmg,_spd,_lifespan,_assistFrames,_findDir,_flashDmg) constructor
{
	inst=_obj
	target=_target
	inst.sprite_index=_sprite
	
	dmg=_dmg
	spd=_spd
	lifespan=_lifespan
	flashDmg=_flashDmg
	
	assistFrames=_assistFrames
	findDir=_findDir
	dir=findDir()
	inst.image_angle=dir-90
	
	step=function()
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
	draw=function()
	{
		with inst
		{
			draw_self()
		}
	}
}