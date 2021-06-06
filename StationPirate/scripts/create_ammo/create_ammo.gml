function create_ammo(_x,_y,_type,_ammount)
{
	var ammo=instance_create_layer(_x,_y,"pickups",obj_ammoPickup)
	ammo.ammoType=_type
	ammo.ammount=floor(_ammount)
	ammo.image_index=_type-1
}