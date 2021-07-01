//reload bar
if weapon.reloading && alive
{
	weapon.draw_reload_bar()
}
//health bar
else if alive
{
	var backColor=c_grey
	var barColor=c_aqua
	var healthPercent=(hp/global.player_max_health)*100
	healthPercent=floor(healthPercent)
	var barWidth=sprite_get_width(spr_healthbar);
	var barX=x-(barWidth*5);
	var barY=y-40;
	var a=1
	
	//get alpha
	if lastHit>HEALTHBAR_FRAMES
	{
		var n=(lastHit-HEALTHBAR_FRAMES)
		a=((n/50)*-1)+1
	}
	
	//draw back bars
	repeat 10
	{
		draw_sprite_ext(spr_healthbar,1,barX,barY,1,1,0,backColor,a);
		barX+=barWidth;
	}
	
	barX=x-(barWidth*5);
	
	//draw full bars
	while healthPercent>0
	{
		draw_sprite_ext(spr_healthbar,1,barX,barY,1,1,0,barColor,a);
		barX+=barWidth;
		healthPercent-=10;
	}
	
	draw_set_alpha(1)
}

//draw ammo
if weapon.id!=weaponIds.none && alive
{
	draw_set_alpha(1)
	draw_set_halign(fa_center)
	draw_set_valign(fa_middle)
	draw_set_font(fnt_hud_ammo)
	if weapon.lastShot>DRAW_AMMO_FRAMES
	{
		draw_set_alpha(ammoAlpha)
	}
	draw_text_outline(mouse_x,mouse_y+24,string(weapon.inMag)+"/"+string(weapon.inReserve),c_gray,c_black,2)
}

draw_set_alpha(1)