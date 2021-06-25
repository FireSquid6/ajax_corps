//mark motion grid
mp_grid_add_rectangle(global.motionGrid,bbox_left,bbox_top,bbox_right,bbox_bottom)

//get orientation
if image_angle==0 facingUp=true else facingUp=false

if facingUp
{
	draw_endpoints=function()
	{
		draw_sprite_ext(spr_laserBase,image_index,x,bbox_top,1,-1,image_angle,c_white,1)
		draw_sprite_ext(spr_laserBase,image_index,x,bbox_bottom,1,1,image_angle,c_white,1)
	}
}
else
{
	draw_endpoints=function()
	{
		draw_sprite_ext(spr_laserBase,image_index,bbox_right,y,-1,1,image_angle,c_white,1)
		draw_sprite_ext(spr_laserBase,image_index,bbox_left,y,1,1,image_angle+180,c_white,1)
	}
}