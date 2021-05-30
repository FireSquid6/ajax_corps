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
	switch state
	{
		case humanStates.patrolling:
			patrol_ai()
			break
		case humanStates.attacking:
			attack_ai()
			break
	}
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
	
}

function human_attack_longrange()
{
	
}

function human_switch_attack()
{
	backSpd=4
	strafeSpd=attackSpd
	state=humanStates.attacking
}
