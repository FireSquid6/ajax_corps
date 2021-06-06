//METADATA
enum humanStates
{
	patrolling,
	attacking
}

function human_get_attack_range(_range)
{
	switch _range
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

//CONTROLLER
function human_init()
{
	//init vars
	flashTime=0
	state=humanStates.patrolling
	hp=maxHealth
	patrolSpd=5
	key_shoot=false
	rArmPos=0
	
	//weapon
	weapon=get_weapon(weapon_string,weaponTeams.enemy,id)
	weapon.equip()
	range=weapon.weaponRange
	
	//path
	attackPath=path_add()
	
	//get functions
	patrol_ai=human_patrol
	human_get_attack_range(range)
}

//step
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
		human_get_attack_range(range)
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

//draw
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

//destroy
function human_destroy()
{
	path_delete(path)
	if weapon.ammoType!=ammoTypes.none create_ammo(x,y,weapon.ammoType,weapon.inReserve)
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
	if has_path path_start(patrolPath,patrolSpd,path_action_continue,false)
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
			if mp_grid_path(global.motionGrid,attackPath,x,y,plr.x,plr.y,true)
			{
				path_start(attackPath,strafeSpd,path_action_stop,true)
			}
		}
	}
}

function human_attack_shortrange()
{
	
}

enum midrangeAttackStates
{
	strafing,
	pushing,
	shooting
}

function human_attack_medrange()
{
	if instance_exists(plr)
	{
		//set angle
		image_angle=point_direction(x,y,plr.x,plr.y)-90
		
		//check if not seeing player anymore
		if !collision_circle(x,y,512,obj_player,false,true) human_switch_patrol()
		
		switch attackState
		{
			//strafing -> shooting -> pushing -> repeat
			case midrangeAttackStates.strafing:
				
				if strafeTime<1
				{
					attackState=midrangeAttackStates.shooting
				}
				break
			case midrangeAttackStates.pushing:
				
				if pushTime<1
				{
					attackState=midrangeAttackStates.strafing
				}
				break
			case midrangeAttackStates.shooting:
				
				if shootTime<1
				{
					attackState=midrangeAttackStates.pushing
					
				}
				break
		}
	}
}

function human_attack_longrange()
{
	
}

function human_switch_attack()
{
	attackState=midrangeAttackStates.strafing
	
	//timers
	strafeTime=0
	pushTime=0
	shootTime=0
	delayTime=0
	
	strafing=true
	state=humanStates.attacking
}