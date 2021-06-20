if alive
{
	//reload bar
	if weapon.reloading
	{
		weapon.draw_reload_bar()
	}

	//shaders
	if flashTime>0 
	{
		shader_set(shd_white)
		flashTime--
	}

	//weapon sprite
	weapon.draw()
	
	//draw ammo
	if weapon.id!=weaponIds.fist
	{
		draw_set_alpha(1)
		draw_set_halign(fa_center)
		draw_set_valign(fa_middle)
		draw_set_font(fnt_hud_ammo)
		draw_set_color(c_gray)
		if weapon.lastShot>60
		{
			draw_set_alpha((weapon.lastShot-60)*0.05)
		}
		draw_text(x,y-38,string(weapon.inMag)+"/"+string(weapon.inReserve))
	}
	
	draw_set_alpha(1)
	
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
		draw_text(x,y-50,"COUNT: "+string(global.enemyCount))
		draw_text(x,y-60,"ALIVE: "+string(global.enemiesAlive))
	}
}

//self
draw_self()

//reset
shader_reset()