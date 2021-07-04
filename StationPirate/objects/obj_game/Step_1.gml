//cursor
if !paused
{
	if obj_player.lockedOn
	{
		cursor_x=obj_player.locked_target.x
		cursor_y=obj_player.locked_target.y
	}
	else
	{
		cursor_x=mouse_x
		cursor_y=mouse_y
	}
}