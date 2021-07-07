draw_set_alpha(1)

//cursor

if paused
{
	draw_sprite(spr_cursor,0,mouse_x,mouse_y)
}
else
{
	var subimg=0
	if collision_point(cursor_x,cursor_y,par_enemy,false,true) subimg=1

	if obj_player.lockedOn draw_sprite(spr_cursor,0,cursor_x,cursor_y) else draw_sprite(spr_cursor,subimg,mouse_x,mouse_y)
}