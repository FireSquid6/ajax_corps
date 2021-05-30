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

//self
draw_self()

//debug
draw_text(x,y-50,string(weapon.cooldown))
draw_text(x,y-60,string(weapon.inMag))
draw_text(x,y-70,string(weapon.inReserve))