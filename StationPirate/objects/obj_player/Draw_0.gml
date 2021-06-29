if alive
{
	//energy field
	if key_shield && energy>0 && energyCooldown<1
	{
		var radius=ENERGY_FIELD_SIZE
		draw_set_alpha(0.3)
		draw_circle_color(x,y,radius,c_yellow,c_yellow,false)
		draw_set_alpha(1)
	}
	
	//quick debug
	//draw_text(x,y-50,"energy "+string(energy))
	//draw_text(x,y-65,"cooldown "+string(energyCooldown))
	
	//dash circles
	draw_set_color(c_aqua)
	if dashTime>0
	{
		var circle=0
		repeat DASH_DRAW_CIRCLES*4
		{
			draw_circle(x,y,DASH_SHIELD_RADIUS-circle,true)
			circle+=0.25
		}
	}
	
	//pain
	draw_set_color(c_white)
	if !instance_exists(obj_game) draw_text(x,y-32,"SOMETHING IS BROKEN AAAAAA")
	
	//shaders
	if flashTime>0 
	{
		shader_set(shd_white)
		flashTime--
	}

	//weapon sprite
	weapon.draw()
	
	//right arm
	draw_sprite_ext(spr_playerArm,1,
	x+lengthdir_x(ARM_DIST,image_angle+rArmPos),
	y+lengthdir_y(ARM_DIST,image_angle+rArmPos),
	1,1,image_angle,c_white,1)

	//left arm
	draw_sprite_ext(spr_playerArm,1,
	x+lengthdir_x(ARM_DIST,image_angle+lArmPos),
	y+lengthdir_y(ARM_DIST,image_angle+lArmPos),
	1,1,image_angle,c_white,1)
	
	//debug
	if global.debugMode
	{
		draw_set_font(fnt_default)
		draw_set_color(c_white)
		draw_text(x,y-50,"COUNT: "+string(global.enemyCount))
		draw_text(x,y-60,"ALIVE: "+string(global.enemiesAlive))
		var percent=(global.player_max_health*0.5)
		draw_text(x,y-70,"LAST HIT: "+string(lastHit))
		draw_text(x,y-80,"HP"+string(hp))
		
		//stupid collision line thing
		if collision_line_tile(x,y,mouse_x,mouse_y,global.collisionTilemap) draw_set_color(c_red)
		draw_line(x,y,mouse_x,mouse_y)
	}
}

//self
draw_self()

//reset
shader_reset()