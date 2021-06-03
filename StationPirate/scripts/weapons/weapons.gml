#macro plr obj_player
enum weaponTeams
{
	player,
	enemy
}

enum weaponRanges
{
	melee,
	short,
	medium,
	long
}

function get_weapon(str,team,obj)
{
	var w
	switch str
	{
		case "none":
			w=new weapon_fist(team,obj)
			break
		case "melee":
			w=new weapon_fist(team,obj)
			break
		case "fist":
			w=new weapon_fist(team,obj)
			break
		case "pistol":
			w=new weapon_pistol(team,obj)
			break
	}
	return w
}

function weapon_fist(_team,_obj) constructor
{
	team=_team
	inst=_obj
	switch team
	{
		case weaponTeams.player:
			target=par_enemy
			assistFrames=3
			findDir=player_find_dir
			break
		case weaponTeams.enemy:
			target=obj_player
			assistFrames=0
			findDir=enemy_find_dir
			break
	}
	
	weapon_sprite=spr_none
	bullet_sprite=spr_melee
	weaponRange=weaponRanges.melee
	
	dmg=5
	knockback=5
	lifespan=18
	
	maxCooldown=15
	flashDmg=3
	reloading=false
	inMag=infinity
	
	dist=24
	
	equip=function()
	{
		cooldown=maxCooldown
		inst.lArmPos=global.arm_pos_walking.l
		inst.rArmPos=global.arm_pos_walking.r
	}
	
	step=function()
	{
		var shoot=inst.key_shoot
		
		if cooldown>0 cooldown--
		if shoot && cooldown<1
		{
			//set cooldown
			cooldown=maxCooldown
			
			//create bullet
			var xx,yy,dir
			dir=findDir()
			xx=inst.x+lengthdir_x(dist,dir)
			yy=inst.y+lengthdir_y(dist,dir)
			var bullet=instance_create_layer(xx,yy,"bullet",obj_projectile)
			bullet.struct=new melee(bullet,target,inst,bullet_sprite,dmg,lifespan,dir,dist,flashDmg)
		}
		
		draw=function()
		{
			
		}
	}
}

function weapon_pistol(_team,_obj) constructor
{
	team=_team
	inst=_obj
	
	switch team
	{
		case weaponTeams.player:
			target=par_enemy
			assistFrames=3
			findDir=player_find_dir
			break
		case weaponTeams.enemy:
			target=obj_player
			assistFrames=0
			findDir=enemy_find_dir
			break
	}
	
	weapon_sprite=spr_pistol
	bullet_sprite=spr_lightBullet
	weaponRange=weaponRanges.medium
	
	dmg=15
	knockback=3
	bulletSpd=18
	lifespan=60
	
	maxCooldown=15
	reloadTime=45
	magSize=7
	switchTime=10
	flashDmg=3
	reloading=false
	
	inMag=magSize
	inReserve=inMag*5
	cooldown=0
	
	equip=function()
	{
		cooldown=switchTime
		inst.lArmPos=global.arm_pos_handgun.l
		inst.rArmPos=global.arm_pos_handgun.r
	}
	
	step=function()
	{
		var shoot=inst.key_shoot
		var reload=inst.key_reload
		
		//get weapon pos
		with inst
		{
			other.posX=x+lengthdir_x(ARM_DIST,image_angle+rArmPos)
			other.posY=y+lengthdir_y(ARM_DIST,image_angle+rArmPos)
		}
		
		//check if not reloading
		if cooldown<1 reloading=false
		
		//on shoot
		if shoot && cooldown<1 && inMag>0
		{
			var bullet=instance_create_layer(posX,posY,"bullet",obj_projectile)
			bullet.struct=new projectile(bullet,target,bullet_sprite,dmg,bulletSpd,lifespan,assistFrames,findDir,flashDmg)
			
			cooldown=maxCooldown
			inMag--
		}
		if cooldown>0 cooldown--
		
		//reload
		if (reload || (inMag<1 && shoot)) && (inReserve>0 && inMag!=magSize)
		{
			cooldown=reloadTime
			inReserve+=inMag
			reloading=true
			
			if inReserve>=magSize
			{
				inMag=magSize
				inReserve-=magSize
			}
			else
			{
				inMag=inReserve
				inReserve=0
			}
		}
	}
	draw=function()
	{
		draw_sprite_ext(weapon_sprite,1,posX,posY,1,1,inst.image_angle,c_white,1)
	}
}