if alive
{
	//reload bar
	switch weaponSelected
	{
		case 0:
			primary.draw_reload_bar()
			break
		case 1:
			secondary.draw_reload_bar()
			break
	}

	//shaders
	if flashTime>0 
	{
		shader_set(shd_white)
		flashTime--
	}

	//weapon sprite
	switch weaponSelected
		{
			case 0:
				primary.draw()
				break
			case 1:
				secondary.draw()
				break
		}

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
}

//self
draw_self()

//reset
shader_reset()