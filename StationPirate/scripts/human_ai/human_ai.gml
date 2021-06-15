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
	rArmPos=global.arm_pos_walking.r
	lArmPos=global.arm_pos_walking.l
	startX=x
	startY=y
	
	//weapon
	weapon=get_weapon_struct(weapon_string,weaponTeams.enemy,id)
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
	if instance_exists(id)
	{
		key_reload=false
	
		//check if out of ammo
		if weapon.inMag==0 
		{
			weapon=get_weapon_struct("melee",weaponTeams.enemy,id)
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
				//check if alive
				if instance_exists(obj_player) weapon.step()
				if !obj_player.alive human_switch_patrol()
				
				//attack
				attack_ai()
				
				//check if switch to patrol
				var checkPath=path_add()
				mp_grid_path(global.motionGrid,checkPath,x,y,obj_player.x,obj_player.y,true)
				var checkLength=path_get_length(checkPath)
				if checkLength>750 human_switch_attack()
				path_delete(checkPath)
				
				break
		}
		
		//kill
		if hp<1 
		{
			instance_destroy()
			part_particles_create(global.partSystem,x,y,global.ptDead,DEAD_PARTICLES_AMMOUNT)
		}
	}
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
	var backColor,barColor
	var healthPercent=(hp/maxHealth)*100
	var barWidth=sprite_get_width(spr_healthbar)
	var barX=x-(barWidth*5)
	var barY=y-40
	
	//cry about it
	if hp<=100
	{
		barColor=c_red
		backColor=c_dkgray
	}
	else if hp<=200
	{
		barColor=c_blue
		backColor=c_red	
	}
	else if hp<=300
	{
		barColor=c_green
		backColor=c_blue
	}
	else if hp<=400
	{
		barColor=c_aqua
		backColor=c_green
	}
	else
	{
		barColor=c_fuchsia
		backColor=c_aqua
	}
	
	//draw back bars
	repeat 10
	{
		draw_sprite_ext(spr_healthbar,1,barX,barY,1,1,0,backColor,1)
		barX+=barWidth
	}
	
	barX=x-(barWidth*5)
	while healthPercent>0
	{
		draw_sprite_ext(spr_healthbar,1,barX,barY,1,1,0,barColor,1)
		barX+=barWidth
		healthPercent-=10
	}

	//debug
	if global.debugMode
	{
		//reset
		draw_set_color(c_white)
		draw_set_font(fnt_default)
		
		//attack state
		if state==humanStates.attacking
		{
			if path_exists(attackPath) draw_path(attackPath,x,y,true)
			draw_text(x,y-60,string(attackState))
		}
		
		//path length
		var checkPath=path_add()
		mp_grid_path(global.motionGrid,checkPath,x,y,obj_player.x,obj_player.y,true)
		var checkLength=path_get_length(checkPath)
		draw_text(x,y-70,checkLength)
		path_delete(checkPath)
	}
}

//destroy
function human_destroy()
{
	if weapon.id!=weaponIds.fist drop_loot(x,y,24,weaponChance,get_weapon_string(weapon),weapon.inReserve)
	path_delete(attackPath)
	audio_play_sound(snd_enemyDead,enemyDeadPriority,false)
}

//PATROL
function human_patrol()
{
	if x!=xprevious || y!=yprevious image_angle=point_direction(xprevious,yprevious,x,y)-180
	if obj_player.alive
	{
		if !collision_line_tile(x,y,obj_player.x,obj_player.y,global.collisionTilemap,8) && obj_player.alive
		{
			human_switch_attack()
		}
	}
	else
	{
		
		path_end()
		if path_exists(patrolPath) && variable_instance_exists(id,"deadSpd")
		{
			var canMove=mp_grid_path(global.motionGrid,patrolPath,x,y,startX,startY,true)
			if canMove path_start(patrolPath,deadSpd,path_action_stop,true)
		}
	}
}

function human_switch_patrol()
{
	deadSpd=3
	state=humanStates.patrolling
	spd=patrolSpd
	if patrolPath!=0 path_start(patrolPath,patrolSpd,path_action_continue,false)
}

//ATTACK
enum attackStates
{
	strafing,
	pushing,
	shooting
}

function human_attack_melee()
{
	if instance_exists(obj_player)
	{
		image_angle=point_direction(x,y,obj_player.x,obj_player.y)-90
		if collision_circle(x,y,48,obj_player,false,true)
		{
			key_shoot=true
		}
		else
		{
			key_shoot=false
			if path_exists(attackPath)
			{
				if mp_grid_path(global.motionGrid,attackPath,x,y,obj_player.x,obj_player.y,true)
				{
					path_start(attackPath,strafeSpd,path_action_stop,true)
				}
			}
		}
	}
}

function human_attack_shortrange()
{
	if instance_exists(obj_player)
	{
		//set angle
		image_angle=point_direction(x,y,obj_player.x,obj_player.y)-90
		
		switch attackState
		{
			//strafing -> shooting -> pushing -> repeat
			//remember to make it so that enemies push if they don't see the player
			case attackStates.strafing:
				key_shoot=false
				
				if strafeTime<1 || collision_line_tile(x,y,obj_player.x,obj_player.y,global.collisionTilemap,8)
				{
					//vars
					key_shoot=false
					attackState=attackStates.shooting
					delayTime=reflex
					shootTime=maxShootSeconds*60
					
					//path
					path_end()
				}
				else strafeTime--
				break
			case attackStates.pushing:
				path_end()
				var path=mp_grid_path(global.motionGrid,attackPath,x,y,obj_player.x,obj_player.y,true)
				if path path_start(attackPath,pushSpd,path_action_stop,true)
				key_shoot=true
				
				if pushTime<1
				{
					//vars
					key_shoot=true
					attackState=attackStates.strafing
					strafeTime=maxStrafeSeconds*60
					
					//path
					path_end()
					var dist=256
					var midpointX=((x+obj_player.x)*0.5)
					var midpointY=((y+obj_player.y)*0.5)
					var mpdir=point_direction(x,y,obj_player.x,obj_player.y)
					var mpdist=point_distance(x,y,obj_player.x,obj_player.y)*0.25
					midpointX+=lengthdir_x(mpdist,mpdir)
					midpointY+=lengthdir_y(mpdist,mpdir)
					var midpointY=((y+obj_player.y)*0.5)
					var dir=point_direction(x,y,obj_player.x,obj_player.y)+(90*choose(-1,1))
					
					while !(mp_grid_path(global.motionGrid,attackPath,x,y,
						midpointX+lengthdir_x(dist,dir),
						midpointY+lengthdir_y(dist,dir),
						true))
					{
						dist-=TILE_SIZE
					}
					
					path_start(attackPath,strafeSpd,path_action_reverse,true)
				}
				else pushTime--
				break
			case attackStates.shooting:
				path_end()
				if delayTime<1 key_shoot=true else delayTime--
				
				if shootTime<1 || collision_line_tile(x,y,obj_player.x,obj_player.y,global.collisionTilemap,8)
				{
					//vars
					key_shoot=false
					attackState=attackStates.pushing
					pushTime=maxPushSeconds*60
					
					//path
					path_end()
					var path=mp_grid_path(global.motionGrid,attackPath,x,y,obj_player.x,obj_player.y,true)
					if path path_start(attackPath,pushSpd,path_action_stop,true)
				}
				else shootTime--
				break
		}
	}
}

function human_attack_medrange()
{
	if instance_exists(obj_player)
	{
		//set angle
		image_angle=point_direction(x,y,obj_player.x,obj_player.y)-90
		
		switch attackState
		{
			//strafing -> shooting -> pushing -> repeat
			case attackStates.strafing:
				key_shoot=false
				
				if strafeTime<1 || collision_line_tile(x,y,obj_player.x,obj_player.y,global.collisionTilemap,8)
				{
					//vars
					key_shoot=false
					attackState=attackStates.shooting
					delayTime=reflex
					shootTime=maxShootSeconds*60
					
					//path
					path_end()
				}
				else strafeTime--
				break
			case attackStates.pushing:
				path_end()
				if path_exists(attackPath)
				{
					var path=mp_grid_path(global.motionGrid,attackPath,x,y,obj_player.x,obj_player.y,true)
					if path path_start(attackPath,pushSpd,path_action_stop,true)
				}
				
				if pushTime<1
				{
					//vars
					key_shoot=true
					attackState=attackStates.strafing
					strafeTime=maxStrafeSeconds*60
					
					//path
					path_end()
					var dist=256
					var midpointX=((x+obj_player.x)*0.5)
					var midpointY=((y+obj_player.y)*0.5)
					var dir=point_direction(x,y,obj_player.x,obj_player.y)+(90*choose(-1,1))
					
					if path_exists(attackPath)
					{
						while !(mp_grid_path(global.motionGrid,attackPath,x,y,
							midpointX+lengthdir_x(dist,dir),
							midpointY+lengthdir_y(dist,dir),
							true))
						{
							dist-=TILE_SIZE
						}
					
						path_start(attackPath,strafeSpd,path_action_reverse,true)
					}
				}
				else pushTime--
				break
			case attackStates.shooting:
				path_end()
				if delayTime<1 key_shoot=true else delayTime--
				
				if shootTime<1 || collision_line_tile(x,y,obj_player.x,obj_player.y,global.collisionTilemap,8)
				{
					//vars
					key_shoot=false
					attackState=attackStates.pushing
					pushTime=maxPushSeconds*60
					
					//path
					path_end()
					var path=mp_grid_path(global.motionGrid,attackPath,x,y,obj_player.x,obj_player.y,true)
					if path path_start(attackPath,pushSpd,path_action_stop,true)
				}
				else shootTime--
				break
		}
	}
}

function human_attack_longrange()
{
	if instance_exists(obj_player)
	{
		//set angle
		image_angle=point_direction(x,y,obj_player.x,obj_player.y)-90
		
		switch attackState
		{
			//strafing -> shooting -> pushing -> repeat
			case attackStates.strafing:
				key_shoot=false
				
				if strafeTime<1
				{
					//vars
					key_shoot=false
					attackState=attackStates.shooting
					delayTime=reflex
					shootTime=maxShootSeconds*60
					
					//path
					path_end()
				}
				else strafeTime--
				break
			case attackStates.pushing:
				path_end()
				var path=mp_grid_path(global.motionGrid,attackPath,x,y,obj_player.x,obj_player.y,true)
				if path path_start(attackPath,pushSpd,path_action_stop,true)
				
				if pushTime<1 || collision_line_tile(x,y,obj_player.x,obj_player.y,global.collisionTilemap,8) //add a collision circle to the player check here
				{
					//vars
					key_shoot=true
					attackState=attackStates.strafing
					strafeTime=maxStrafeSeconds*60
					
					//path
					path_end()
					var dist=256
					var midpointX=((x+obj_player.x)*0.5)
					var mpdir=point_direction(x,y,obj_player.x,obj_player.y)-180
					var mpdist=point_distance(x,y,obj_player.x,obj_player.y)*0.25
					midpointX+=lengthdir_x(mpdist,mpdir)
					midpointY+=lengthdir_y(mpdist,mpdir)
					var midpointY=((y+obj_player.y)*0.5)
					var dir=point_direction(x,y,obj_player.x,obj_player.y)+(90*choose(-1,1))
					
					while !(mp_grid_path(global.motionGrid,attackPath,x,y,
						midpointX+lengthdir_x(dist,dir),
						midpointY+lengthdir_y(dist,dir),
						true))
					{
						dist-=TILE_SIZE
					}
					
					path_start(attackPath,strafeSpd,path_action_reverse,true)
				}
				else pushTime--
				break
			case attackStates.shooting:
				path_end()
				if delayTime<1 key_shoot=true else delayTime--
				
				if shootTime<1 || collision_line_tile(x,y,obj_player.x,obj_player.y,global.collisionTilemap,8)
				{
					//vars
					key_shoot=false
					attackState=attackStates.pushing
					pushTime=maxPushSeconds*60
					
					//path
					path_end()
					var path=mp_grid_path(global.motionGrid,attackPath,x,y,obj_player.x,obj_player.y,true)
					if path path_start(attackPath,pushSpd,path_action_stop,true)
				}
				else shootTime--
				break
		}
	}
}

//switch function
function human_switch_attack()
{
	attackState=attackStates.shooting
	patrolPath=0
	path_end()
	
	//timers
	strafeTime=0
	pushTime=0
	shootTime=maxShootSeconds*60
	delayTime=reflex
	
	strafing=true
	state=humanStates.attacking
}