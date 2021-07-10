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
	if instance_exists(obj_player) layer_set_visible("collision",true)
	
	if room==rm_testRoom
	{
		with obj_player.weapon
		{
			inReserve=infinity
		}
	}
	
	switch keyboard_key
	{
		case ord("1"):
			room=rm_level_1_1
			break
		case ord("2"):
			room=rm_level_1_2
			break
		case ord("3"):
			room=rm_level_1_3
			break
		case ord("0"):
			room=rm_testRoom
			break
	}
}
else
{
	if keyboard_check_pressed(vk_tab) game_end()
	if instance_exists(obj_player) layer_set_visible("collision",false)
}

//pause
if room!=rm_titleScreen
{
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
}
