function create_ammo(_x,_y,_type,_amount)
{
	var ammo=instance_create_layer(_x,_y,"pickups",obj_ammoPickup)
	ammo.ammoType=_type
	ammo.amount=floor(_amount)
	ammo.image_index=_type-1
}