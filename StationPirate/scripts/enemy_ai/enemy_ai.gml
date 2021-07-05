//METADATA
enum patrolTypes
{
	still,
	circle,
	seek
}
enum engagerStates
{
	patrolling,
	attacking,
	searching
}
enum turretStates
{
	patrolling,
	sniping,
	repositioning
}
enum attackStates
{
	strafing,
	pushing,
	shooting
}

#region PARENT PROPERTIES

//line of sight
function enemy_line_of_sight(_x,_y)
{
	var ret=collision_line_tile(_x,_y,obj_player.x,obj_player.y,global.collisionTilemap)
	return ret
}

//alerted
function enemy_alerted()
{
	if collision_circle(x,y,150,par_bullet,false,true) return true else return false
}

//init
function enemy_init()
{
	//init vars
	flashTime=0;
	
	hp=maxHealth;
	key_shoot=false;
	rArmPos=global.arm_pos_walking.r;
	lArmPos=global.arm_pos_walking.l;
	startX=x;
	startY=y;
	
	//weapon
	weapon=get_weapon_struct(weapon_string,weaponTeams.enemy,id);
	weapon.equip();
	
	//path
	patrolPath=path_add();
	
	//switch to patrol
	enemy_switch_patrol();
	patrolType=patrolPresetType
	patrolDir=image_angle+90;
}

//step
function enemy_step()
{
	if instance_exists(id)
	{
		key_reload=false;
		
		//check if can execute
		if hp<=(maxHealth*global.execute_factor) canExecute=true else canExecute=false
	
		//check if out of ammo
		if weapon.inMag==0 
		{
			weapon=get_weapon_struct("melee",weaponTeams.enemy,id);
			weapon.equip();
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
function enemy_draw()
{
	draw_set_color(c_white)
	draw_set_alpha(1)
	if !executing
	{	
		//execute marker
		if canExecute
		{
			var color=c_white
			if point_distance(x,y,obj_player.x,obj_player.y)<=EXECUTE_RANGE color=c_red
			draw_sprite_ext(spr_executeMarker,1,x,y,1,1,0,color,1)
			draw_set_color(c_white)
		}
		
		//flash
		if flashTime>0 
		{
			shader_set(shd_white);
			flashTime--;
		}
		
		//self
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
	}
	else draw_self();
	
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
	}
}

//DESTROY
function enemy_destroy()
{
	global.enemiesAlive-=1
	if obj_player.locked_target==id obj_player.lockedOn=false
	
	path_delete(patrolPath);
	
	audio_play_sound(snd_enemyDead,enemyDeadPriority,false);
	
	if executing && weapon.id!=weaponIds.none create_pickup_weapon(x,y,get_weapon_string(weapon),weapon.inReserve)
}

//PATROL
function enemy_patrol()
{
	if obj_player.alive
	{
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

function enemy_switch_patrol()
{
	deadSpd=3;
	patrolType=patrolTypes.still
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

#endregion

////////////////////////////////////////////////////////////
#region ENGAGER AI

//INIT
function engager_init()
{
	pathStarted=false;
	state=engagerStates.patrolling;
	attackPath=path_add();
	searchPath=path_add();
}

//STEP
function engager_step()
{
	switch state
	{
		case engagerStates.patrolling:
			if !enemy_line_of_sight(x,y)
			{
				engager_switch_attack(attackStates.shooting);
			}
			enemy_patrol()
			break;
		case engagerStates.attacking:
			//check if alive
			if instance_exists(obj_player) weapon.step();
			if !obj_player.alive enemy_switch_patrol();
				
			//attack
			engager_attack();
			break;
		case engagerStates.searching:
			engager_search();
			break;
	}
}

//DESTROY
function engager_destroy()
{
	path_delete(attackPath);
	path_delete(searchPath);
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
		if enemy_line_of_sight(x,y) || enemy_alerted() engager_switch_search()
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
	key_shoot=false;
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
	key_shoot=true
	
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
	if path_exists(searchPath)
	
	//check if path ended
	if path_position==1
	{
		enemy_switch_patrol()
		path_end()
	}
	
	if !enemy_line_of_sight(x,y) engager_switch_attack(attackStates.pushing)
}

function engager_switch_search()
{
	state=engagerStates.searching
	path_end()
	
	path_start(searchPath,searchSpd,path_action_stop,true)
}

#endregion

////////////////////////////////////////////////////////////
#region TURRET AI

function turret_init()
{
	
}

function turret_step()
{
	switch state
	{
		case turretStates.patrolling:
			if !enemy_line_of_sight(x,y)
			{
				turret_switch_snipe();
			}
			enemy_patrol()
			break
		case turretStates.sniping:
			turret_snipe()
			break
		case turretStates.repositioning:
			turret_reposition()
			break
	}
}

function turret_snipe()
{
	//check if ended
	snipeTime--
	if snipeTime<=1 engager_switch_reposition()
	
	//shoot
	key_shoot=true
	
	//image angle
	image_angle=point_direction(x,y,obj_player.x,obj_player.y)
}

function turret_switch_snipe()
{
	state=turretStates.sniping
	snipeTime=120
}

function turret_reposition()
{
	var xx,yy
	repeat 12
	{
		
	}
}

function turret_switch_reposition()
{
	
}

#endregion