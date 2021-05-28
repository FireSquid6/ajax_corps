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
			findDir=player_find_dir
			break
		case weaponTeams.enemy:
			target=obj_player
			findDir=enemy_find_dir
			break
	}
	
	weapon_sprite=spr_none
	bullet_sprite=spr_test
	
	dmg=15
	bulletSpd=14
	lifespan=60
	
	maxCooldown=20
	magSize=15
	reserveSize=95
	
	inMag=infinity
	inReserve=0
	cooldown=0
	
	step=function()
	{
		//on shoot
		if obj_player.key_shoot && cooldown<1 && inMag>0
		{
			var bullet=instance_create_layer(inst.x,inst.y,"bullet",obj_projectile)
			var dir=findDir()
			bullet.struct=new projectile(bullet,target,bullet_sprite,dmg,bulletSpd,lifespan,dir)
			
			cooldown=maxCooldown
			inMag--
		}
		if cooldown>0 cooldown--
		
	}
	draw=function()
	{
		
	}
}