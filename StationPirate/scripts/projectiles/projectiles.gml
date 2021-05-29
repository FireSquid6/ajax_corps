function projectile(_obj,_target,_sprite,_dmg,_spd,_lifespan,_assistFrames,_findDir) constructor
{
	inst=_obj
	target=_target
	inst.sprite_index=_sprite
	
	dmg=_dmg
	spd=_spd
	lifespan=_lifespan
	
	assistFrames=_assistFrames
	findDir=_findDir
	dir=findDir()
	
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
			instance_destroy(inst)
			col.hp-=dmg
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