//cursor
cursor_x=mouse_x
cursor_y=mouse_y
if !paused && instance_exists(obj_player)
{
	if obj_player.lockedOn
	{
		cursor_x=obj_player.locked_target.x
		cursor_y=obj_player.locked_target.y
	}
}