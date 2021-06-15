if alive
{
	//reload bar
	weapon.draw_reload_bar()

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
		if keyboard_check(ord("Y"))
		{
			imposter="sus"
		}
		var lineColor
		var line=collision_line_tile(x,y,mouse_x,mouse_y,global.collisionTilemap,8)
		if line==true lineColor=c_red else lineColor=c_white
		draw_line_color(x,y,mouse_x,mouse_y,lineColor,lineColor)
	
		draw_text(x,y-20,string(point_distance(x,y,mouse_x,mouse_y)))
	}
}

//self
draw_self()

//reset
shader_reset()