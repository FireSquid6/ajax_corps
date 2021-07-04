function weapon_parent(_team,_obj) constructor
{
	team=_team
	inst=_obj
	arms=global.arm_pos_walking
	
	switchTime=0
	posX=0
	posY=0
	lastShot=0
	inReserve=0
	
	step=function()
	{
		
	}
	
	equip=function()
	{
		lastShot=0
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
	}
	
	get_struct=function(_bullet,_targ)
	{
		var proj = new projectile(_bullet,_targ)
		
		//set vars
		proj.spd=bulletSpd
		proj.lifespan=60
		proj.assistFrames=3
		proj.dmg=dmg
		proj.inst.sprite_index=bullet_sprite
		
		//extra
		ext_get_struct(proj)
		
		return proj
	}
	
	ext_get_struct=function(_proj)
	{
		
	}
}

function weapon_none(_team,_obj) : weapon_parent(_team,_obj) constructor
{
	id=weaponIds.none
	arms=global.arm_pos_walking
	reloading=false
	inReserve=0
	inMag=0
}

function weapon_pistol(_team,_obj) : weapon_parent(_team,_obj) constructor
{
	id=weaponIds.pistol
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
	shootSound=snd_shootPistol
	
	weapon_sprite=spr_pistol
	bullet_sprite=spr_lightBullet
	pickup_sprite=spr_pistolPickup
	weaponRange=weaponRanges.medium
	
	display_name="HANDGUN"
	dmg=15
	bulletSpd=12
	lifespan=60
	
	arms=global.arm_pos_handgun
	
	maxCooldown=15
	reloadTime=45
	magSize=8
	switchTime=10
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
	
	create_bullet=function()
	{
		lastShot=0
		var bulletPosX,bulletPosY,bulletArm
		if arms==global.arm_pos_rifle bulletArm=inst.lArmPos else if arms==global.arm_pos_handgun bulletArm=inst.rArmPos
		with inst
		{
			bulletPosX=x+lengthdir_x(ARM_DIST,image_angle+bulletArm)
			bulletPosY=y+lengthdir_y(ARM_DIST,image_angle+bulletArm)
		}
		
		var bullet=instance_create_layer(bulletPosX,bulletPosY,"bullet",obj_projectile)
		bullet.struct=get_struct(bullet,target)
		audio_play_sound(shootSound,shootPriority,false)
			
		cooldown=maxCooldown
		inMag--
	}
	
	step=function()
	{
		if lastShot<80 lastShot++
		
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
		if arms==global.arm_pos_rifle offset=15
		draw_sprite_ext(weapon_sprite,1,posX,posY,1,1,inst.image_angle+offset,c_white,1)
		debug_draw()
	}
	
	draw_reload_bar=function()
	{
		if reloading
		{
			draw_healthbar(mouse_x-15,mouse_y-18,mouse_x+15,mouse_y-26,(cooldown/reloadTime)*100,c_white,c_white,c_white,0,false,true)
		}
	}
}

function weapon_machinePistol(_team,_obj) : weapon_pistol(_team,_obj) constructor
{
	id=weaponIds.machinePistol
	weapon_sprite=spr_machinePistol
	bullet_sprite=spr_lightBullet
	pickup_sprite=spr_machinePistolPickup
	weaponRange=weaponRanges.medium
	
	display_name="SPEED HANDGUN"
	
	dmg=12
	bulletSpd=12
	magSize=18
	spread=5
	
	maxCooldown=7
	
	inMag=magSize
	reserveSize=magSize*10
	inReserve=inMag*5
	cooldown=0
	
	ext_get_struct=function(_proj)
	{
		_proj.dir+=irandom_range((spread*-1),(spread))
	}
}

function weapon_assault_rifle(_team,_obj) : weapon_pistol(_team,_obj) constructor
{	
	id=weaponIds.assaultRifle
	hitSound=snd_smallDamage
	shootSound=snd_shootRifle
	
	weapon_sprite=spr_assaultRifle
	bullet_sprite=spr_mediumBullet
	pickup_sprite=spr_assaultRiflePickup
	weaponRange=weaponRanges.medium
	
	display_name="PLAZMARIFLE 007"
	
	dmg=20
	bulletSpd=15
	
	arms=global.arm_pos_rifle
	
	maxCooldown=10
	reloadTime=80
	magSize=24
	switchTime=30
	
	inMag=magSize
	reserveSize=magSize*10
	inReserve=inMag*5
	cooldown=0
	
	equip=function()
	{
		cooldown=switchTime
		set_arms()
		ext_equip()
	}
	
}

function weapon_pump_shotgun(_team,_obj) : weapon_pistol(_team,_obj) constructor
{
	id=weaponIds.pumpShotgun
	hitSound=snd_smallDamage
	shootSound=snd_shootPistol
	
	weapon_sprite=spr_shotgun
	bullet_sprite=spr_shell
	pickup_sprite=spr_shotgunPickup
	weaponRange=weaponRanges.short
	
	display_name="FRAG CANNON"
	
	dmg=35
	bulletSpd=28
	decay=1
	
	arms=global.arm_pos_rifle
	
	maxCooldown=60
	reloadTime=50
	magSize=4
	switchTime=maxCooldown
	
	inMag=magSize
	reserveSize=magSize*10
	inReserve=inMag*5
	cooldown=0
	
	ext_get_struct=function(_proj)
	{
		_proj.decay=decay
		var func=function()
		{
			if variable_struct_exists(self,"id") show_error("I want to die",true)
			spd-=decay
			if spd<0 instance_destroy(inst)
		
			var moveSpd=findSpd()
			inst.x+=lengthdir_x(moveSpd,dir)
			inst.y+=lengthdir_y(moveSpd,dir)
		}
		method(_proj,func) //kill me
		
		return _proj
	}
}

//function weapon_sniper(_team,_obj) : weapon_parent(_team,_obj) constructor
//{
	
//}

//function weapon_charge_rifle(_team,_obj) : weapon_pistol(_team,_obj) constructor
//{
	
//}

//function laser_pistol(_team,_obj) : weapon_pistol(_team,_obj) constructor
//{
	
//}