function drop_loot(_startx,_starty,_dist,_weaponstring,_reserve)
{
	var dir,xx,yy
	
	if obj_player.weapon.id==weaponIds.fist
	{
		//drop gun
		if _weaponstring!="melee"
		{
			dir=random(360)
			xx=_startx+lengthdir_x(_dist,dir)
			yy=_starty+lengthdir_y(_dist,dir)
			create_pickup_weapon(xx,yy,_weaponstring,_reserve)
		}
	}
	else
	{
		//drop healthpack
		if obj_player.hp<ceil(global.player_max_health*global.healthpack_drop_percent)
		{
			dir=random(360)
			xx=_startx+lengthdir_x(_dist,dir)
			yy=_starty+lengthdir_y(_dist,dir)
			create_pickup_healthpack(xx,yy,(global.player_max_health-obj_player.hp)*0.75)
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
}