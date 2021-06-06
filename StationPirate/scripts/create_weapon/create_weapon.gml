function create_weapon(_x,_y,_string,_struct,_inReserve)
{
	var pick=instance_create_layer(_x,_y,"pickups",obj_weaponPickup)
	pick.weapon=_struct
	pick.weapon.inReserve=_inReserve
}