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
	hp=100
	flashTime=0
	state=humanStates.patrolling
	patrolSpd=5
	maxStrafeTime=maxStrafeSeconds*60
	maxDelayTime=maxDelaySeconds*60
	key_shoot=false
	rArmPos=0
	weapon=get_weapon(weapon_string,weaponTeams.enemy,id)
	
	//get functions
	if has_path patrol_ai=human_patrol_path else patrol_ai=human_patrol_standby
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

function human_step()
{
	if hp<1 instance_destroy()
	if flashTime>0 flashTime--
	key_reload=false
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

//PATROL
function human_patrol_path()
{
	
}

function human_patrol_standby()
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
}

//ATTACK
function human_attack_melee()
{
	move_towards_point(plr.x,plr.y,attackSpd)
	
}

function human_attack_shortrange()
{
	
}

function human_attack_medrange()
{
	if instance_exists(plr)
	{
		//shoot
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
			else
			{
				var d=point_direction(x,y,plr.x,plr.y)
				x+=lengthdir_x(strafeSpd,d)
				y+=lengthdir_y(strafeSpd,d)
			}
	
			//move to player
			var dist=point_distance(x,y,plr.x,plr.y)
			if !between(dist,192,208)
			{
				backDir=point_direction(x,y,plr.x,plr.y)
				if dist<128 backDir+=180
				
				if !(tile_meeting(x+lengthdir_x(backSpd,backDir),y,global.collisionTilemap) 
				|| tile_meeting(x,y+lengthdir_y(backSpd,backDir),global.collisionTilemap))
				{
					x+=lengthdir_x(backSpd,backDir)
					y+=lengthdir_y(backSpd,backDir)
				}
			}
		}
		else
		{
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
	backDir=0
	delayTime=0
	strafeTime=0
	shootDelay=0
	strafing=true
	state=humanStates.attacking
	strafeDir=point_direction(x,y,plr.x,plr.y-90)
	strafeTime=maxStrafeTime*0.5
	strafeSign=choose(1,-1)
}