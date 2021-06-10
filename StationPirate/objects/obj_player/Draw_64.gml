var gui_height=display_get_gui_height()
#macro PROF_SCALE 4

//this is the worst gui code ever, but it works
//draw profile sprite

if alive
{
	var prof_x=0
	var prof_y=gui_height-(sprite_get_height(spr_profile)*PROF_SCALE)
	draw_sprite_ext(spr_profile,1,prof_x,prof_y,PROF_SCALE,PROF_SCALE,0,c_white,1)

	//macro
	//ignore the stupidity
	//weeeeeeeeeeee magic numbers
	#macro PROF_LEFT_PADDING 110
	#macro PROF_TOP_PADDING 175
	#macro PROF_BOTTOM_PADDING 110
	#macro PROF_RIGHT_PADDING 290

	//draw name
	var weapon
	switch weaponSelected
		{
			case 0:
				weapon=primary
				break
			case 1:
				weapon=secondary
				break
		}
	draw_set_font(fnt_profile_name)
	draw_set_color(c_black)
	draw_text(prof_x+PROF_LEFT_PADDING,gui_height-PROF_TOP_PADDING,weapon.display_name)

	//draw ammo
	draw_set_color(c_dkgray)
	if variable_struct_exists(weapon,"inMag") && variable_struct_exists(weapon,"inReserve")
	{
		var mag=weapon.inMag
		var res=weapon.inReserve
		var resStr,magStr
	
		if mag<100 && mag<10 magStr="00"+string(mag) else if mag>10 magStr="0"+string(mag) else magStr=string(mag)
		if res<100 && res<10 resStr="00"+string(res) else if res>10 resStr="0"+string(res) else resStr=string(res)
	
		draw_text(prof_x+PROF_LEFT_PADDING,gui_height-PROF_BOTTOM_PADDING,"MAG:"+magStr)
		draw_text(prof_x+PROF_LEFT_PADDING,gui_height-(PROF_BOTTOM_PADDING-28),"RES:"+resStr)
	}
	else
	{
		draw_text(prof_x+PROF_LEFT_PADDING,gui_height-PROF_BOTTOM_PADDING,"NULL")
		draw_text(prof_x+PROF_LEFT_PADDING,gui_height-(PROF_BOTTOM_PADDING-28),"NULL")
	}

	//I am mentally ill
	//draw health
	draw_set_font(fnt_profile_health)
	draw_set_color(c_red)
	var hpStr
	if hp<100 && hp<10 hpStr="00"+string(hp) else if hp<100 hpStr="0"+string(hp) else hpStr=string(hp)
	draw_text(PROF_RIGHT_PADDING,gui_height-(PROF_BOTTOM_PADDING-10),hpStr)
}
else
{
	draw_set_font(fnt_profile_name)
	draw_set_color(c_red)
	draw_text(0+10,0,"HIT RELOAD TO RESET LEVEL")
}