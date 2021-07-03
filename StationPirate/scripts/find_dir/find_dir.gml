function player_find_dir()
{
	var dir=obj_player.dir
	return dir
}

function enemy_find_dir()
{
	var dir=point_direction(inst.x,inst.y,obj_player.x,obj_player.y)
	return dir
}