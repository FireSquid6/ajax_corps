//METADATA
enum humanStates
{
	patrolling,
	attacking
}

//CONTROLLER
function human_init()
{
	hp=100
	flashTime=0
}

function human_step()
{
	if hp<1 instance_destroy()
	if flashTime>0 flashTime--
}

//PATROL
function human_patrol_path()
{
	
}

function human_patrol_standby()
{
	
}

function human_switch_patrol()
{
	
}

//ATTACK
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
	
}
