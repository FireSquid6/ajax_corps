x+=lengthdir_x(spd,dir)
y+=lengthdir_y(spd,dir)
image_alpha-=alpha_loss
if image_alpha<=0 instance_destroy()