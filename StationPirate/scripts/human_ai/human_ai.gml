//METADATA
enum humanStates
{
	patrolling,
	attacking
}

//CONTROLLER
function human_init()
{
	//init vars
	flashTime=0
	state=humanStates.patrolling
	hp=maxHealth
	patrolSpd=5
	maxStrafeTime=maxStrafeSeconds*60
	maxDelayTime=maxDelaySeconds*60
	key_shoot=false
	rArmPos=0
	weapon=get_weapon(weapon_string,weaponTeams.enemy,id)
	weapon.equip()
	range=weapon.weaponRange
	path=path_add()
	
	//get functions
	patrol_ai=human_patrol
	switch range
	{
		case 0:
			attack_ai=human_attack_melee
			break
		case 1:
			attack_ai=human_attack_shortrange
			break
		case 2:
			attack_ai=human_attack_medrange
			break
		case 3:
			attack_ai=human_attack_longrange
			break
	}
}

//DEFAULT
function human_step()
{
	if hp<1 instance_destroy()
	key_reload=false
	
	//check if out of ammo
	if weapon.inMag==0 
	{
		weapon=get_weapon("melee",weaponTeams.enemy,id)
		weapon.equip()
		range=weapon.weaponRange
		switch range
		{
			case 0:
				attack_ai=human_attack_melee
				break
			case 1:
				attack_ai=human_attack_shortrange
				break
			case 2:
				attack_ai=human_attack_medrange
				break
			case 3:
				attack_ai=human_attack_longrange
				break
		}
	}
	
	switch state
	{
		case humanStates.patrolling:
			patrol_ai()
			break
		case humanStates.attacking:
			attack_ai()
			break
	}
	
	if instance_exists(plr) weapon.step()
}

function human_draw()
{
	if flashTime>0 
	{
		shader_set(shd_white)
		flashTime--
	}

	weapon.draw()
	draw_self()

	//right arm
	draw_sprite_ext(spr_enemyArm,1,
	x+lengthdir_x(ARM_DIST,image_angle+rArmPos),
	y+lengthdir_y(ARM_DIST,image_angle+rArmPos),
	1,1,image_angle,c_white,1)

	//left arm
	draw_sprite_ext(spr_enemyArm,1,
	x+lengthdir_x(ARM_DIST,image_angle+lArmPos),
	y+lengthdir_y(ARM_DIST,image_angle+lArmPos),
	1,1,image_angle,c_white,1)

	shader_reset()

	//draw healthbar
	var healthPercent=(hp/maxHealth)*100
	var barWidth=sprite_get_width(spr_healthbar)
	var barX=x-(barWidth*5)
	var barY=y-40
	repeat 10
	{
		draw_sprite_ext(spr_healthbar,1,barX,barY,1,1,0,c_dkgray,1)
		barX+=barWidth
	}
	
	barX=x-(barWidth*5)
	while healthPercent>0
	{
		draw_sprite_ext(spr_healthbar,1,barX,barY,1,1,0,c_red,1)
		barX+=barWidth
		healthPercent-=10
	}

	//debug
	if path_exists(path) && global.debugMode draw_path(path,x,y,true)
}

//PATROL
function human_patrol()
{
	if collision_circle(x,y,512,obj_player,false,true)
	{
		human_switch_attack()
	}
}

function human_switch_patrol()
{
	state=humanStates.patrolling
	spd=patrolSpd
	if has_path path_start(path,patrolSpd,path_action_continue,false)
	image_angle=point_direction(xprevious,yprevious,x,y)
}

//ATTACK
function human_attack_melee()
{
	if instance_exists(plr)
	{
		image_angle=point_direction(x,y,plr.x,plr.y)-90
		if collision_circle(x,y,48,plr,false,true)
		{
			key_shoot=true
		}
		else
		{
			key_shoot=false
			if mp_grid_path(global.motionGrid,path,x,y,plr.x,plr.y,true)
			{
				path_start(path,strafeSpd,path_action_stop,true)
			}
		}
	}
}

function human_attack_shortrange()
{
	
}

function human_attack_medrange()
{
	if instance_exists(plr)
	{
		image_angle=point_direction(x,y,plr.x,plr.y)-90
		//check if not seeing player anymore
		if !collision_circle(x,y,512,obj_player,false,true) human_switch_patrol()
		
		//strafe
		if strafing
		{
			//check if strafing
			if weapon.reloading || weapon.inMag<1 strafing=false
			if strafeTime<1
			{
				strafing=false
				shootDelay=reflex
				delayTime=maxDelayTime
			}
			else strafeTime--
			
			//set shoot
			key_shoot=false
			
			//strafe
			strafeDir=point_direction(x,y,plr.x,plr.y)+(90*strafeSign)
			if !(tile_meeting(x+lengthdir_x(strafeSpd,strafeDir),y,global.collisionTilemap) 
			|| tile_meeting(x,y+lengthdir_y(strafeSpd,strafeDir),global.collisionTilemap))
			{
				x+=lengthdir_x(strafeSpd,strafeDir)
				y+=lengthdir_y(strafeSpd,strafeDir)
			}
	
			//move to player
			var dist=point_distance(x,y,plr.x,plr.y)
			if !between(dist,192,208) && canStart<1
			{
				if mp_grid_path(global.motionGrid,path,x,y,plr.x,plr.y,true)
				{
					path_start(path,backSpd,path_action_stop,true)
				}
				canStart=30
			}
			if canStart>0 canStart--
		}
		else
		{
			path_end()
			if shootDelay>0 shootDelay--
			if shootDelay<1 key_shoot=true
			
			if delayTime>0 delayTime--
			if delayTime<1 
			{
				strafing=true
				strafeTime=maxStrafeTime
				strafeSign*=-1
			}
		}
	}
}

function human_attack_longrange()
{
	
}

function human_switch_attack()
{
	backSpd=2
	canStart=0
	delayTime=0
	strafeTime=0
	shootDelay=0
	strafing=true
	state=humanStates.attacking
	strafeDir=point_direction(x,y,plr.x,plr.y-90)
	strafeTime=maxStrafeTime*0.5
	strafeSign=choose(1,-1)
}