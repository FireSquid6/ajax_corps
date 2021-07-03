if keyboard_check(vk_lcontrol) room_speed=2 else room_speed=60

//debug mode
if keyboard_check_pressed(vk_enter) 
{
	global.debugMode=(!global.debugMode)
}
if global.debugMode
{
	if keyboard_check_pressed(vk_tab) game_restart()
	if keyboard_check(ord("G")) global.godMode=true
	layer_set_visible("collision",true)
	
	switch keyboard_key
	{
		case ord("1"):
			room=rm_level_1_1
			break
		case ord("2"):
			room=rm_level_1_2
			break
		case vk_home:
			room=rm_testRoom
			break
	}
}
else
{
	if keyboard_check_pressed(vk_tab) game_end()
	layer_set_visible("collision",false)
}

//cursor
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

//pause
key_pause=keyboard_check_pressed(vk_escape)

if key_pause
{
	paused=!paused
	if paused
	{
		instance_deactivate_all(true)
		instance_create_layer(x,y,"meta",obj_pause)
	}
	else
	{
		instance_activate_all()
		instance_destroy(obj_pause)
	}
}
