var gui_height=display_get_gui_height()
var gui_width=display_get_gui_width()

if alive
{
	var percent=(global.player_max_health*0.5)
	if hp<=percent
	{
		//set colors
		draw_set_color(c_red)
		var a=((hp/percent)*-1)+1
		var aloss=0.05
		var pos=0
		
		//draw rectangle
		draw_set_alpha(a-0.2)
		draw_rectangle_color(0,0,gui_width,gui_height,c_red,c_red,c_red,c_red,false)
		
		//draw border
		while a>0
		{
			draw_set_alpha(a)
			repeat 10
			{
				draw_rectangle(pos,pos,gui_width-pos,gui_height-pos,true)
			}
			
			a-=aloss
			pos++
		}
		//reset
		draw_set_color(c_white)
		draw_set_alpha(1)
	}
}
else
{
	//draw rectangle
	draw_set_color(c_red)
	draw_set_alpha(0.65)
	draw_rectangle(0,0,gui_width,gui_height,false)
	
	//draw hit reload
	draw_set_color(c_black)
	draw_set_font(fnt_dead)
	draw_set_alpha(1)
	draw_set_valign(fa_top)
	draw_set_halign(fa_left)
	draw_text_outline(0+10,0,"HIT RELOAD TO RESET LEVEL",c_black,c_white,2)
}