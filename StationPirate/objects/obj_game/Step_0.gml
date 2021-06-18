if keyboard_check(vk_lcontrol) room_speed=2 else room_speed=60

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
	}
}
else
{
	if keyboard_check_pressed(vk_tab) game_end()
	layer_set_visible("collision",false)
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
