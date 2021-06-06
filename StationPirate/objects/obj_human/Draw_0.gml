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
if path_exists(path) && global.debugMode draw_path(path,x,y,true)