function projectile(_obj,_target,_sprite,_dmg,_spd,_dir) constructor
{
	inst=_obj
	target=_target
	inst.sprite_index=_sprite
	
	dmg=_dmg
	spd=_spd
	dir=_dir
	
	step=function()
	{
		inst.x+=lengthdir_x(spd,dir)
		inst.y+=lengthdir_y(spd,dir)
		
		var col=false
		var targ=target
		with inst
		{
			if place_meeting(x,y,targ) col=true
		}
		if col
		{
			
			instance_destroy(inst)
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