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
			assistFrames=5
			findDir=player_find_dir
			break
		case weaponTeams.enemy:
			target=obj_player
			assistFrames=0
			findDir=enemy_find_dir
			break
	}
	
	weapon_sprite=spr_none
	bullet_sprite=spr_test
	
	dmg=15
	bulletSpd=18
	lifespan=60
	
	maxCooldown=15
	reloadTime=45
	magSize=7
	reserveSize=95
	switchTime=10
	
	inMag=magSize
	inReserve=inMag*2
	cooldown=0
	
	step=function()
	{
		var shoot=obj_player.key_shoot
		var reload=obj_player.key_reload
		
		//on shoot
		if shoot && cooldown<1 && inMag>0
		{
			var bullet=instance_create_layer(inst.x,inst.y,"bullet",obj_projectile)
			bullet.struct=new projectile(bullet,target,bullet_sprite,dmg,bulletSpd,lifespan,assistFrames,findDir)
			
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
		
	}
}