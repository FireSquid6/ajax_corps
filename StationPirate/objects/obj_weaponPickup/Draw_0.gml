draw_set_color(c_white)
draw_set_font(fnt_default)
if global.debugMode
{
	draw_text(x,y-32,weapon.display_name)
}


draw_self()
shader_reset()