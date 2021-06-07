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
enum ammoTypes
{
	none=0,
	light=1,
	medium=2,
	heavy=3,
	shell=4,
	battery=5,
	superBattery=6
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
		case "machinePistol":
			w=new weapon_machinePistol(team,obj)
			break
		case "machine_pistol":
			w=new weapon_machinePistol(team,obj)
			break
	}
	return w
}

function weapon_fist(_team,_obj) constructor
{
	ammoType=ammoTypes.none
	team=_team
	inst=_obj
	switch team
	{
		case weaponTeams.player:
			target=par_enemy
			assistFrames=3
			findDir=player_find_dir
			doBar=true
			break
		case weaponTeams.enemy:
			target=obj_player
			assistFrames=0
			findDir=enemy_find_dir
			doBar=false
			break
	}
	
	weapon_sprite=spr_none
	bullet_sprite=spr_melee
	pickup_sprite=spr_pistolPickup
	weaponRange=weaponRanges.melee
	
	hitSound=snd_smallDamage
	shootSound=snd_fist
	display_name="FISTS"
	
	dmg=5
	knockback=5
	lifespan=14
	
	maxCooldown=20
	flashDmg=3
	reloading=false
	inMag=infinity
	
	dist=32
	
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
			bullet.struct=new melee(bullet,target,inst,bullet_sprite,dmg,lifespan,dir,dist,flashDmg,hitSound)
			
			//sound
			audio_play_sound(shootSound,shootPriority,false)
		}
		
		draw=function()
		{
			draw_set_color(c_white)
			draw_set_font(fnt_default)
			if global.debugMode draw_text(inst.x,inst.y-32,string(ammoType))
		}
		draw_reload_bar=function()
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
			doBar=true
			break
		case weaponTeams.enemy:
			target=obj_player
			assistFrames=0
			findDir=enemy_find_dir
			doBar=false
			break
	}
	
	hitSound=snd_smallDamage
	shootSound=snd_shootPistol
	
	weapon_sprite=spr_pistol
	bullet_sprite=spr_lightBullet
	pickup_sprite=spr_machinePistolPickup
	weaponRange=weaponRanges.medium
	
	display_name="HANDGUN"
	
	ammoType=ammoTypes.light
	dmg=20
	knockback=3
	bulletSpd=18
	lifespan=60
	
	maxCooldown=15
	reloadTime=45
	magSize=8
	switchTime=10
	flashDmg=3
	reloading=false
	
	inMag=magSize
	reserveSize=magSize*10
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
		
		//check if not reloading
		if cooldown<1 reloading=false
		
		//on shoot
		if shoot && cooldown<1 && inMag>0
		{
			var bullet=instance_create_layer(posX,posY,"bullet",obj_projectile)
			bullet.struct=new projectile(bullet,target,bullet_sprite,dmg,bulletSpd,lifespan,assistFrames,findDir,flashDmg,hitSound)
			audio_play_sound(shootSound,shootPriority,false)
			
			cooldown=maxCooldown
			inMag--
		}
		if cooldown>0 cooldown--
		
		//reload
		if (reload || (inMag<1 && shoot)) && (inReserve>0 && inMag!=magSize)
		{
			if team==weaponTeams.player audio_play_sound(snd_reload,reloadPriority,false)
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
		
		//clamp reserve
		inReserve=clamp(inReserve,0,reserveSize)
	}
	draw=function()
	{
		//get weapon pos
		with inst
		{
			other.posX=x+lengthdir_x(ARM_DIST,image_angle+rArmPos)
			other.posY=y+lengthdir_y(ARM_DIST,image_angle+rArmPos)
		}
		
		draw_set_color(c_white)
		draw_set_font(fnt_default)
		draw_sprite_ext(weapon_sprite,1,posX,posY,1,1,inst.image_angle,c_white,1)
		if global.debugMode draw_text(inst.x,inst.y-32,string(ammoType))
	}
	draw_reload_bar=function()
	{
		if reloading
		{
			draw_healthbar(inst.x-15,inst.y-24,inst.x+15,inst.y-30,(cooldown/reloadTime)*100,c_white,c_white,c_white,0,false,true)
		}
	}
}

function weapon_machinePistol(_team,_obj) : weapon_pistol(_team,_obj) constructor
{
	weapon_sprite=spr_machinePistol
	bullet_sprite=spr_lightBullet
	weaponRange=weaponRanges.medium
	
	display_name="MACHINE PISTOL"
	
	dmg=10
	bulletSpd=18
	magSize=18
	
	maxCooldown=7
}