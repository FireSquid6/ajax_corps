#macro plr obj_player
enum weaponTeams
{
	player,
	enemy
}

function pistol(_team,_obj) constructor
{
	team=_team
	inst=_obj
	
	switch team
	{
		case weaponTeams.player:
			target=par_enemy
			findDir=new player_find_dir()
			break
		case weaponTeams.enemy:
			target=obj_player
			findDir=new enemy_find_dir()
			break
	}
	
	weapon_sprite=spr_none
	bullet_sprite=spr_none
	
	dmg=15
	bulletSpd=14
	
	maxCooldown=20
	magSize=15
	reserveSize=95
	
	inMag=0
	inReserve=0
	cooldown=0
	
	step=function()
	{
		//on shoot
		if plr.key_shoot && cooldown<1 && inMag>0
		{
			var bullet=instance_create_layer(x,y,"bullet",obj_projectile)
			var dir=findDir()
			bullet.struct=new projectile(bullet,target,bullet_sprite,dmg,bulletSpd,dir)
			
			cooldown=maxCooldown
			inMag--
		}
		if cooldown>0 cooldown--
		
	}
	draw=function()
	{
		
	}
}