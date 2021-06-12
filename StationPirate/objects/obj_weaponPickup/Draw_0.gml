draw_set_color(c_white)
draw_set_font(fnt_default)
if global.debugMode
{
	draw_text(x,y-32,weapon.display_name)
}

if obj_player.interactableSelected==id 
{
	shader_set(shd_white)
	image_blend=c_yellow
}
draw_self()
shader_reset()
image_blend=c_white