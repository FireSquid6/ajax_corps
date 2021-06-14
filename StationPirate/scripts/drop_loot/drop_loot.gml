function drop_loot(_startx,_starty,_dist,_gunChance,_weaponstring,_reserve)
{
	var dir,xx,yy
	//drop gun
	if irandom(100)<=_gunChance
	{
		if _weaponstring!="melee"
		{
			dir=random(360)
			xx=_startx+lengthdir_x(_dist,dir)
			yy=_starty+lengthdir_y(_dist,dir)
			create_pickup_weapon(xx,yy,_weaponstring,_reserve)
		}
	}
	
	//drop healthpack
	if obj_player.hp<ceil(MAX_HP*0.4)
	{
		dir=random(360)
		xx=_startx+lengthdir_x(_dist,dir)
		yy=_starty+lengthdir_y(_dist,dir)
		create_pickup_healthpack(xx,yy,MAX_HP*global.healthpack_drop_percent)
	}
	
	//drop ammo
	{
		var mag=obj_player.weapon.magSize
		var res=obj_player.weapon.inReserve
		if mag*2.5>=res
		{
			dir=random(360)
			xx=_startx+lengthdir_x(_dist,dir)
			yy=_starty+lengthdir_y(_dist,dir)
			create_pickup_ammo(xx,yy)
		}
	}
}