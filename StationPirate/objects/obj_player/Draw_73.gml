//draw ammo
if weapon.id!=weaponIds.fist && alive
{
	draw_set_alpha(1)
	draw_set_halign(fa_center)
	draw_set_valign(fa_middle)
	draw_set_font(fnt_hud_ammo)
	if weapon.lastShot>DRAW_AMMO_FRAMES
	{
		draw_set_alpha(ammoAlpha)
	}
	draw_text_outline(x,y+38,string(weapon.inMag)+"/"+string(weapon.inReserve),c_gray,c_black,2)
}

draw_set_alpha(1)