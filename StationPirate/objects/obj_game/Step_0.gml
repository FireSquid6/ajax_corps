if keyboard_check_pressed(vk_enter) 
{
	global.debugMode=(!global.debugMode)
}
if global.debugMode
{
	if keyboard_check_pressed(vk_escape) game_restart()
	if keyboard_check(vk_lcontrol) room_speed=2 else room_speed=60
	if keyboard_check(ord("G")) global.godMode=true
}
else
{
	if keyboard_check_pressed(vk_escape) game_end()
}