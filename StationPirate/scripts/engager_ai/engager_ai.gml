//METADATA
enum engagerStates
{
	patrolling,
	attacking,
	searching
}

//CONTROLLER
function engager_init()
{
	//init vars
	pathStarted=false;
	flashTime=0;
	state=engagerStates.patrolling;
	hp=maxHealth;
	key_shoot=false;
	rArmPos=global.arm_pos_walking.r;
	lArmPos=global.arm_pos_walking.l;
	startX=x;
	startY=y;
	
	//weapon
	weapon=get_weapon_struct(weapon_string,weaponTeams.enemy,id);
	weapon.equip();
	range=weapon.weaponRange;
	
	//path
	attackPath=path_add();
	patrolPath=path_add();
	searchPath=path_add();
	
	//switch to patrol
	engager_switch_patrol();
}

//step
function engager_step()
{
	if instance_exists(id)
	{
		key_reload=false;
	
		//check if out of ammo
		if weapon.inMag==0 
		{
			weapon=get_weapon_struct("melee",weaponTeams.enemy,id);
			weapon.equip();
		}
	
		switch state
		{
			case engagerStates.patrolling:
				engager_patrol()
				break;
			case engagerStates.attacking:
				//check if alive
				if instance_exists(obj_player) weapon.step();
				if !obj_player.alive engager_switch_patrol();
				
				//attack
				engager_attack();
				break;
			case engagerStates.searching:
				engager_search();
				break;
		}
		
		//kill
		if hp<1 
		{
			instance_destroy();
			part_particles_create(global.partSystem,x,y,global.ptDead,DEAD_PARTICLES_AMMOUNT);
		}
		
		//floor pos
		x=floor(x)
		y=floor(y)
	}
}

//draw
function engager_draw()
{
	if flashTime>0 
	{
		shader_set(shd_white);
		flashTime--;
	}

	weapon.draw();
	draw_self();

	//right arm
	draw_sprite_ext(spr_enemyArm,1,
	x+lengthdir_x(ARM_DIST,image_angle+rArmPos),
	y+lengthdir_y(ARM_DIST,image_angle+rArmPos),
	1,1,image_angle,c_white,1);

	//left arm
	draw_sprite_ext(spr_enemyArm,1,
	x+lengthdir_x(ARM_DIST,image_angle+lArmPos),
	y+lengthdir_y(ARM_DIST,image_angle+lArmPos),
	1,1,image_angle,c_white,1);

	shader_reset();

	//draw healthbar
	var backColor,barColor;
	var healthPercent=(hp/maxHealth)*100;
	healthPercent=floor(healthPercent);
	var barWidth=sprite_get_width(spr_healthbar);
	var barX=x-(barWidth*5);
	var barY=y-40;
	
	//draw back bars
	repeat 10
	{
		draw_sprite_ext(spr_healthbar,1,barX,barY,1,1,0,c_gray,1);
		barX+=barWidth;
	}
	
	barX=x-(barWidth*5);
	while healthPercent>0
	{
		draw_sprite_ext(spr_healthbar,1,barX,barY,1,1,0,c_red,1);
		barX+=barWidth;
		healthPercent-=10;
	}
	
	//reset
	draw_set_color(c_white);
	draw_set_font(fnt_default);
	
	//debug
	if global.debugMode
	{
		//attack state
		if state==engagerStates.attacking
		{
			if path_exists(attackPath) draw_path(attackPath,x,y,true);
			draw_text(x,y-90,"attackState"+string(attackState));
		}
		draw_text(x,y-105,"state"+string(state))
		
		if engager_line_of_sight(x,y) draw_line_color(x,y,obj_player.x,obj_player.y,c_white,c_white) else draw_line_color(x,y,obj_player.x,obj_player.y,c_red,c_red)
	}
}

//destroy
function engager_destroy()
{
	if weapon.id!=weaponIds.fist drop_loot(x,y,24,weaponChance,get_weapon_string(weapon),weapon.inReserve);
	path_delete(attackPath);
	audio_play_sound(snd_enemyDead,enemyDeadPriority,false);
}

//PATROL
enum patrolTypes
{
	still,
	circle,
	seek
}

function engager_patrol()
{
	if obj_player.alive
	{
		if !engager_line_of_sight(x,y)
		{
			engager_switch_attack(attackStates.shooting);
		}
		switch patrolType
		{
			case patrolTypes.circle:
				if !(tile_meeting(x+lengthdir_x(patrolSpd,patrolDir),y,global.collisionTilemap)
				&& tile_meeting(x,y+lengthdir_y(patrolSpd,patrolDir),global.collisionTilemap))
				{
					x+=lengthdir_x(patrolSpd,patrolDir);
					y+=lengthdir_y(patrolSpd,patrolDir);
				}
				else 
				{
					x-=lengthdir_x(patrolSpd,patrolDir);
					y-=lengthdir_y(patrolSpd,patrolDir);
					patrolDir-=90;
					image_angle-=90;
				}
				break;
			case patrolTypes.seek:
				//i don't wanna do this right now
				break;
		}
	}
	else
	{
		path_end();
		if path_exists(patrolPath) && variable_instance_exists(id,"deadSpd")
		{
			var canMove=mp_grid_path(global.motionGrid,patrolPath,x,y,startX,startY,true);
			if canMove path_start(patrolPath,deadSpd,path_action_stop,true);
		}
	}
}

function engager_switch_patrol()
{
	deadSpd=3;
	pathStarted=false;
	state=engagerStates.patrolling;
	spd=patrolSpd;
	if patrolPath!=0 path_start(patrolPath,patrolSpd,path_action_continue,false);
	
	switch patrolType
	{
		case patrolTypes.still:
			
			break;
		case patrolTypes.circle:
			patrolDir=image_angle+90;
			break;
		case patrolTypes.seek:
			
			break;
	}
}

//ATTACK
enum attackStates
{
	strafing,
	pushing,
	shooting
}

//attack function
function engager_attack()
{
	if instance_exists(obj_player)
	{
		//set angle
		image_angle=point_direction(x,y,obj_player.x,obj_player.y)-90;
		
		//execute code
		switch attackState
		{
			case attackStates.strafing:
				engager_attack_strafe()
				break;
			case attackStates.pushing:
				engager_attack_push()
				break;
			case attackStates.shooting:
				engager_attack_shoot()
				break;
		}
		
		//check if seeing player
		if engager_line_of_sight(x,y) engager_switch_search()
	}
}

//switch attack
function engager_switch_attack(_substate)
{
	patrolPath=0;
	path_end();
	
	//substate
	switch _substate
	{
		case attackStates.pushing: engager_attack_switch_push(); break;
		case attackStates.strafing: engager_attack_switch_strafe(); break;
		case attackStates.shooting: engager_attack_switch_shoot(); break;
	}
	delayTime=reflex;
	
	state=engagerStates.attacking;
}

//shooting
function engager_attack_shoot()
{
	path_end();
	if delayTime<1 key_shoot=true else delayTime--;
				
	if shootTime<1
	{
		engager_attack_switch_push()
	}
	else shootTime--;
}

function engager_attack_switch_shoot()
{
	//vars
	key_shoot=false;
	attackState=attackStates.shooting;
	delayTime=reflex;
	shootTime=maxShootSeconds*60;
					
	//path
	path_end();
}

//strafe
function engager_attack_strafe()
{
	key_shoot=false;
				
	if strafeTime<1
	{
		engager_attack_switch_shoot()
	}
	else strafeTime--;
}

function engager_attack_switch_strafe()
{
	//vars
	key_shoot=true;
	attackState=attackStates.strafing;
	strafeTime=maxStrafeSeconds*60;
					
	//path
	path_end();
	var dist=256;
	var midpointX=((x+obj_player.x)*0.5);
	var midpointY=((y+obj_player.y)*0.5);
	var dir=point_direction(x,y,obj_player.x,obj_player.y)+(90*choose(-1,1));
					
	if path_exists(attackPath)
	{
		while !(mp_grid_path(global.motionGrid,attackPath,x,y,
			midpointX+lengthdir_x(dist,dir),
			midpointY+lengthdir_y(dist,dir),
			true))
		{
			dist-=TILE_SIZE;
			if dist<0 
			{
				//vars
				key_shoot=false;
				attackState=attackStates.pushing;
				pushTime=maxPushSeconds*60;
					
				//path
				path_end();
				var path=mp_grid_path(global.motionGrid,attackPath,x,y,obj_player.x,obj_player.y,true);
				if path path_start(attackPath,pushSpd,path_action_stop,true);
				break
			}
		}
		path_start(attackPath,strafeSpd,path_action_reverse,true);
	}
}

//push
function engager_attack_push()
{
	path_end();
	if path_exists(attackPath)
	{
		var path=mp_grid_path(global.motionGrid,attackPath,x,y,obj_player.x,obj_player.y,true);
		if path path_start(attackPath,pushSpd,path_action_stop,true);
	}
	
	pushTime--
	if pushTime<1
	{
		engager_attack_switch_strafe()
	}
	else pushTime--;
}

function engager_attack_switch_push()
{
	//vars
	key_shoot=false;
	attackState=attackStates.pushing;
	pushTime=maxPushSeconds*60;
					
	//path
	path_end();
	var path=mp_grid_path(global.motionGrid,attackPath,x,y,obj_player.x,obj_player.y,true);
	if path path_start(attackPath,pushSpd,path_action_continue,true);
}


//search
function engager_search()
{
	//check if there is a path
	if path_exists(searchhPath)
	
	//check if path ended
	if path_position==1
	{
		engager_switch_patrol()
		path_end()
	}
	
	if !engager_line_of_sight(x,y) engager_switch_attack(attackStates.pushing)
}

function engager_switch_search()
{
	state=engagerStates.searching
	path_end()
	
	mp_grid_path(global.motionGrid,searchPath,x,y,obj_player.x,obj_player.y,true)
	path_start(searchPath,searchSpd,path_action_stop,true)
}

//line of sight
function engager_line_of_sight(_x,_y)
{
	var ret=collision_line_tile(_x,_y,obj_player.x,obj_player.y,global.collisionTilemap)
	return ret
}

//alerted
function engager_alerted()
{
	if collision_circle(x,y,64,par_bullet,false,true) return true else return false
}