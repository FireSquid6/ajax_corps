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

function projectile(_obj,_target) : bullet_parent(_obj,_target) constructor
{	
	inst=_obj
	target=_target
	if target==obj_player findDir=enemy_find_dir else findDir=player_find_dir
	dir=findDir()
	inst.image_angle=dir-90
	
	//editable vars
	inst.sprite_index=spr_lightBullet
	dmg=0
	spd=12
	lifespan=60
	assistFrames=0
	
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