var gui_height=display_get_gui_height()
var gui_width=display_get_gui_width()

if alive
{
	if hp<=(global.player_max_health*0.333)
	{
		draw_set_color(c_red)
		var a=1
		var aloss=0.05
		var pos=0
		while a>0
		{
			draw_set_alpha(a)
			repeat 3
			{
				draw_rectangle(pos,pos,gui_width-pos,gui_height-pos,true)
			}
			
			a-=aloss
			pos++
		}
		draw_set_color(c_white)
		draw_set_alpha(1)
	}
}
else
{
	draw_set_font(fnt_profile_name)
	draw_set_color(c_red)
	draw_text(0+10,0,"HIT RELOAD TO RESET LEVEL")
}