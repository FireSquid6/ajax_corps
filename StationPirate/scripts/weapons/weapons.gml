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
		case "handgun":
			w=new weapon_pistol(team,obj)
			break
		case "machinePistol":
			w=new weapon_machinePistol(team,obj)
			break
		case "machine_pistol":
			w=new weapon_machinePistol(team,obj)
			break
		case "pump shotgun":
			w=new weapon_pump_shotgun(team,obj)
			break
		case "auto shotgun":
			w=new weapon_auto_shotgun(team,obj)
			break
		case "pump_shotgun":
			w=new weapon_pump_shotgun(team,obj)
			break
		case "auto_shotgun":
			w=new weapon_auto_shotgun(team,obj)
			break
	}
	return w
}

function get_weapon_string(_id)
{
	var s
	switch _id
	{
		case weapon_fist:
			s="melee"
			break
		case weapon_pistol:
			s="pistol"
			break
		case weapon_machinePistol:
			s="machine_pistol"
			break
		case weapon_pump_shotgun:
			s="pump_shotgun"
			break
		case weapon_auto_shotgun:
			s="auto_shotgun"
			break
	}
	return s
	
}

function weapon_parent(_team,_obj) constructor
{
	team=_team
	inst=_obj
	arms=global.arm_pos_walking
	
	switchTime=0
	posX=0
	posY=0
	
	step=function()
	{
		
	}
	
	equip=function()
	{
		cooldown=switchTime
		set_arms()
		ext_equip()
	}
	
	ext_equip=function()
	{
		
	}
	
	set_arms=function()
	{
		inst.lArmPos=arms.l
		inst.rArmPos=arms.r
	}
	
	draw=function()
	{
		debug_draw()
	}
		
	draw_reload_bar=function()
	{
			
	}
	
	debug_draw=function()
	{
		draw_set_color(c_white)
		draw_set_font(fnt_default)
		if global.debugMode 
		{
			draw_text(inst.x,inst.y-32,string(ammoType))
		}
	}
}

function weapon_fist(_team,_obj) : weapon_parent(_team,_obj) constructor
{
	ammoType=ammoTypes.none
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
	
	arms=global.arm_pos_walking
	
	dmg=5
	lifespan=14
	
	maxCooldown=20
	flashDmg=3
	reloading=false
	inMag=infinity
	
	dist=32
	
	create_bullet=function()
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
	
	step=function()
	{
		var shoot=inst.key_shoot
		
		if cooldown>0 cooldown--
		if shoot && cooldown<1
		{
			create_bullet()
		}
	}
}

function weapon_pistol(_team,_obj) : weapon_parent(_team,_obj) constructor
{
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
	bulletSpd=18
	lifespan=60
	
	arms=global.arm_pos_handgun
	
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
	
	reload=function()
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
	
	get_struct=function(_bullet)
	{
		var proj=new projectile(_bullet,target,bullet_sprite,dmg,bulletSpd,lifespan,assistFrames,findDir,flashDmg,hitSound)
		return proj
	}
	
	create_bullet=function()
	{
		var bulletPosX,bulletPosY,bulletArm
		if arms==global.arm_pos_rifle bulletArm=inst.lArmPos else if arms==global.arm_pos_handgun bulletArm=inst.rArmPos
		with inst
		{
			bulletPosX=x+lengthdir_x(ARM_DIST,image_angle+bulletArm)
			bulletPosY=y+lengthdir_y(ARM_DIST,image_angle+bulletArm)
		}
		
		var bullet=instance_create_layer(bulletPosX,bulletPosY,"bullet",obj_projectile)
		bullet.struct=get_struct(bullet)
		audio_play_sound(shootSound,shootPriority,false)
			
		cooldown=maxCooldown
		inMag--
	}
	
	step=function()
	{
		var k_shoot=inst.key_shoot
		var k_reload=inst.key_reload
		
		//check if not reloading
		if cooldown<1 reloading=false
		
		//on shoot
		if k_shoot && cooldown<1 && inMag>0
		{
			create_bullet()
		}
		if cooldown>0 cooldown--
		
		//reload
		if (k_reload || (inMag<1 && k_shoot)) && (inReserve>0 && inMag!=magSize)
		{
			reload()
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
		var offset=0
		if arms=global.arm_pos_rifle offset=15
		draw_sprite_ext(weapon_sprite,1,posX,posY,1,1,inst.image_angle+offset,c_white,1)
		debug_draw()
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
	
	display_name="SPEED HANDGUN"
	
	dmg=10
	bulletSpd=18
	magSize=18
	
	maxCooldown=7
	
	inMag=magSize
	reserveSize=magSize*10
	inReserve=inMag*5
	cooldown=0
}

//function heavy_machine_gun(_team,_obj) : weapon_pistol(_team,_obj) constructor
//{
	
//}

function weapon_assault_rifle(_team,_obj) : weapon_pistol(_team,_obj) constructor
{	
	hitSound=snd_smallDamage
	shootSound=snd_shootPistol
	
	weapon_sprite=spr_assaultRifle
	bullet_sprite=spr_lightBullet
	pickup_sprite=spr_machinePistolPickup
	weaponRange=weaponRanges.medium
	
	display_name="ASSUALT RIFLE"
	
	ammoType=ammoTypes.medium
	dmg=25
	bulletSpd=28
	
	arms=global.arm_pos_rifle
	
	maxCooldown=10
	reloadTime=60
	magSize=24
	switchTime=30
	
	inMag=magSize
	reserveSize=magSize*10
	inReserve=inMag*5
	cooldown=0
}

function weapon_pump_shotgun(_team,_obj) : weapon_pistol(_team,_obj) constructor
{
	hitSound=snd_smallDamage
	shootSound=snd_shootPistol
	
	weapon_sprite=spr_assaultRifle
	bullet_sprite=spr_lightBullet
	pickup_sprite=spr_machinePistolPickup
	weaponRange=weaponRanges.short
	
	display_name="SHELL CANNON"
	
	ammoType=ammoTypes.shell
	dmg=20
	bulletSpd=28
	spread=7
	shots=7
	
	arms=global.arm_pos_rifle
	
	maxCooldown=60
	reloadTime=50
	magSize=4
	switchTime=maxCooldown
	
	inMag=magSize
	reserveSize=magSize*10
	inReserve=inMag*5
	cooldown=0
	
	get_struct=function(_bullet)
	{
		var proj=new fragment(_bullet,target,bullet_sprite,dmg,bulletSpd,lifespan,assistFrames,findDir,flashDmg,hitSound,spread)
		return proj
	}
	
	create_bullet=function()
	{
		var bulletPosX,bulletPosY,bulletArm
		if arms==global.arm_pos_rifle bulletArm=inst.lArmPos else if arms==global.arm_pos_handgun bulletArm=inst.rArmPos
		with inst
		{
			bulletPosX=x+lengthdir_x(ARM_DIST,image_angle+bulletArm)
			bulletPosY=y+lengthdir_y(ARM_DIST,image_angle+bulletArm)
		}
		
		var bullet
		repeat shots
		{
			bullet=instance_create_layer(bulletPosX,bulletPosY,"bullet",obj_projectile)
			bullet.struct=get_struct(bullet)
		}
		
		audio_play_sound(shootSound,shootPriority,false)
		cooldown=maxCooldown
		inMag--
	}
}

function weapon_auto_shotgun(_team,_obj) : weapon_pump_shotgun(_team,_obj) constructor
{
	magSize=12
	maxCooldown=15
	spread=12
	dmg=10
	reloadTime=40
	display_name="SHELL MACHINE GUN"
	inMag=magSize
	reserveSize=magSize*10
	inReserve=inMag*5
	cooldown=0
}

//function weapon_sniper(_team,_obj) : weapon_parent(_team,_obj) constructor
//{
	
//}

//function weapon_auto_sniper(_team,_obj) : weapon_sniper(_team,_obj) constructor
//{
	
//}

//function weapon_railgun(_team,_obj) : weapon_sniper(_team,_obj) constructor
//{
	
//}

//function weapon_charge_rifle(_team,_obj) : weapon_pistol(_team,_obj) constructor
//{
	
//}

//function weapon_battery_rifle(_team,_obj) : weapon_pistol(_team,_obj) constructor
//{
	
//}

//function laser_pistol(_team,_obj) : weapon_pistol(_team,_obj) constructor
//{
	
//}