var gui_height=display_get_gui_height()
var gui_width=display_get_gui_width()

if alive
{
	//draw health
	draw_set_halign(fa_left)
	draw_set_valign(fa_bottom)
	draw_set_font(fnt_pause_title)
	draw_set_color(c_red)
	draw_text(0,gui_height,"HEALTH: "+string(hp)+" / "+string(global.player_max_health))
	
	//reset
	draw_set_color(c_white)
	draw_set_alpha(1)
}
else
{
	//draw hit reload
	draw_set_color(c_black)
	draw_set_font(fnt_dead)
	draw_set_alpha(1)
	draw_set_valign(fa_top)
	draw_set_halign(fa_left)
	draw_text_outline(0+10,0,"MISSION FAILED - PRESS TO R RESTART",c_black,c_white,2)
}