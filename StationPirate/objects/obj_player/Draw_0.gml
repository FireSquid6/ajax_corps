if alive
{
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
	
	//line
	if global.debugMode
	{
		draw_set_font(fnt_default)
		draw_set_color(c_white)
		draw_text(x,y-50,"COUNT: "+string(global.enemyCount))
		draw_text(x,y-60,"ALIVE: "+string(global.enemiesAlive))
		var percent=(global.player_max_health*0.5)
		draw_text(x,y-70,"LAST HIT: "+string(lastHit))
		draw_text(x,y-80,"HP"+string(hp))
	}
}

//self
draw_self()

//reset
shader_reset()