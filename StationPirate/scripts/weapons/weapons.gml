#macro plr obj_player
enum weaponTeams
{
	player,
	enemy
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
	
	dmg=15
	bulletSpd=18
	lifespan=60
	
	maxCooldown=15
	reloadTime=45
	magSize=7
	switchTime=10
	flashDmg=3
	
	inMag=magSize
	inReserve=inMag*5
	cooldown=0
	
	equip=function()
	{
		cooldown=switchTime
		obj_player.lArmPos=global.arm_pos_handgun.l
		obj_player.rArmPos=global.arm_pos_handgun.r
	}
	
	step=function()
	{
		var shoot=obj_player.key_shoot
		var reload=obj_player.key_reload
		
		//get weapon pos
		with inst
		{
			other.posX=x+lengthdir_x(ARM_DIST,image_angle+rArmPos)
			other.posY=y+lengthdir_y(ARM_DIST,image_angle+rArmPos)
		}
		
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
		if (reload || (inMag<1 && shoot)) && inReserve>0
		{
			cooldown=reloadTime
			inReserve+=inMag
			
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