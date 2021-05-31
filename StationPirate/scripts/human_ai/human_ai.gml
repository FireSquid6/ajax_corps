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
	attackSpd=8
	maxStrafeTime=60
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
	
}

function human_attack_shortrange()
{
	
}

function human_attack_medrange()
{
	if instance_exists(plr)
	{
		//shoot
		key_shoot=true
		
		if strafing
		{
			//strafe
			strafeDir=point_direction(x,y,plr.x,plr.y)+(90*strafeSign)
			x+=lengthdir_x(attackSpd,strafeDir)
			y+=lengthdir_y(attackSpd,strafeDir)
	
			//move to player
			var dist=point_distance(x,y,plr.x,plr.y)
			if !between(dist,192,208)
			{
				backDir=point_direction(x,y,plr.x,plr.y)
				if dist<128 backDir+=180
				x+=lengthdir_x(backSpd,backDir)
				y+=lengthdir_y(backSpd,backDir)
			}
		
	
			//time
			strafeTime--
			if strafeTime<1 
			{
				strafeSign*=-1
				strafeTime=maxStrafeTime
			}
		}
		else
		{
			
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
	strafing=true
	state=humanStates.attacking
	strafeDir=point_direction(x,y,plr.x,plr.y-90)
	strafeTime=maxStrafeTime*0.5
	strafeSign=1
}
