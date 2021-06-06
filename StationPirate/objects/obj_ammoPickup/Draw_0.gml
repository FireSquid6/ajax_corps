draw_set_color(c_white)
draw_set_font(fnt_default)
if global.debugMode
{
	draw_text(x,y-32,string(ammoType))
}
draw_self()