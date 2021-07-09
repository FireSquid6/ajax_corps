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
function line_of_sight_is_blocked(_x,_y)
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
	
	if inReserve>=0 weapon.inReserve=inReserve else weapon.inReserve=(weapon.magSize*(abs(inReserve)))
	
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
	
		//check if weapon empty
		if weapon.inReserve==0 && weapon.inMag==0
		{
			weapon=new weapon_none(weaponTeams.enemy,id)
			weapon.equip()
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
		draw_sprite_ext(armSprite,1,
		x+lengthdir_x(ARM_DIST,image_angle+rArmPos),
		y+lengthdir_y(ARM_DIST,image_angle+rArmPos),
		1,1,image_angle,c_white,1);

		//left arm
		draw_sprite_ext(armSprite,1,
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
		var ammo="null"
		if variable_struct_exists(weapon,"inMag") ammo=weapon.inMag
		draw_text(x,y-105,"state "+string(state))
		draw_text(x,y-115,"ammo "+string(ammo))
		draw_text(x,y-125,"shoot "+string(key_shoot))
	}
}

//DESTROY
function enemy_destroy()
{
	//alive
	global.enemiesAlive-=1
	if obj_player.locked_target==id obj_player.lockedOn=false

	//path
	if path_exists(patrolPath) path_delete(patrolPath);
	
	//effect
	audio_play_sound(snd_enemyDead,enemyDeadPriority,false);
	part_particles_create(global.partSystem,x,y,global.ptDead,50)
	
	//drop
	if executing && weapon.id!=weaponIds.none create_pickup_weapon(x,y,get_weapon_string(weapon),weapon.inReserve)
}

//PATROL
function enemy_patrol()
{
	if obj_player.alive
	{
		key_shoot=false
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
	armSprite=spr_enemyArm
}

//STEP
function engager_step()
{
	switch state
	{
		case engagerStates.patrolling:
			if !line_of_sight_is_blocked(x,y)
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
		if line_of_sight_is_blocked(x,y) || enemy_alerted() engager_switch_search()
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
	if !path_exists(attackPath) attackPath=path_add()
	var path=mp_grid_path(global.motionGrid,attackPath,x,y,obj_player.x,obj_player.y,true);
	if path path_start(attackPath,pushSpd,path_action_continue,true);
}


//search
function engager_search()
{	
	//check if path ended
	if path_position==1
	{
		enemy_switch_patrol()
		path_end()
	}
	
	if !line_of_sight_is_blocked(x,y) engager_switch_attack(attackStates.pushing)
}

function engager_switch_search()
{
	state=engagerStates.searching
	path_end()
	
	if !path_exists(searchPath) searchPath=path_add()
	mp_grid_path(global.motionGrid,searchPath,x,y,obj_player.x,obj_player.y,true)
	path_start(searchPath,searchSpd,path_action_stop,true)
}

#endregion

////////////////////////////////////////////////////////////
#region TURRET AI

function turret_init()
{
	//make these room variables later
	repositionSpd=4
	
	//path
	repositionPath=path_add()
	
	//vars
	armSprite=spr_sniperEnemyArm
}

function turret_destroy()
{
	path_delete(repositionPath)
}

function turret_step()
{
	switch state
	{
		case turretStates.patrolling:
			if !line_of_sight_is_blocked(x,y)
			{
				turret_switch_snipe();
			}
			enemy_patrol()
			break
		case turretStates.sniping:
			if instance_exists(obj_player) weapon.step() else enemy_switch_patrol()
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
	if weapon.reloading turret_switch_reposition()
	
	//shoot
	key_shoot=true
	
	//image angle
	image_angle=point_direction(x,y,obj_player.x,obj_player.y)-90
}

function turret_switch_snipe()
{
	state=turretStates.sniping
	path_end()
}

function turret_reposition()
{
	key_shoot=false
	if path_position==0 path_start(repositionPath,repositionSpd,path_action_stop,true)
	
	if path_position==1
	{
		path_end()
		turret_switch_snipe()
	}
	
	image_angle=point_direction(xprevious,yprevious,x,y)-90
}

function turret_switch_reposition()
{
	state=turretStates.repositioning
	var xx,yy
	#macro REPOSITION_MIN 160
	#macro REPOSITION_MAX 256
	#macro REPOSITION_DIR_VARIABLE 60
	#macro REPOSITION_REPS 48
	var pdir=point_direction(x,y,obj_player.x,obj_player.y)-180
	var dirMin=pdir-REPOSITION_DIR_VARIABLE
	var dirMax=pdir+REPOSITION_DIR_VARIABLE //i love u || I love you too
	var reposition_range,reposition_dir,canPath,xx,yy
	var reps=0
	repeat REPOSITION_REPS
	{
		reposition_range=irandom_range(REPOSITION_MIN,REPOSITION_MAX)
		reposition_dir=irandom_range(dirMin,dirMax)
		if reps>REPOSITION_REPS*0.5 reposition_dir+=180
		xx=x+lengthdir_x(reposition_range,reposition_dir)
		yy=y+lengthdir_y(reposition_range,reposition_dir)
		canPath=mp_grid_path(global.motionGrid,repositionPath,x,y,xx,yy,true)
		if canPath && !line_of_sight_is_blocked(xx,yy)
		{
			path_start(repositionPath,repositionSpd,path_action_stop,true)
			break
		}
		reps++
	}
	
	if reps==REPOSITION_REPS
	{
		show_debug_message("Turret instance ("+string(id)+") unable to find reposition path.")
	}
}

#endregion