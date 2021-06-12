if place_meeting(x,y,obj_player) && variable_struct_exists(obj_player.weapon,"inReserve")
{
	obj_player.weapon.inReserve+=obj_player.weapon.magSize
	instance_destroy()
}