draw_set_alpha(1)

//cursor
var subimg=0
if collision_point(mouse_x,mouse_y,par_enemy,false,true) subimg=1

draw_sprite(spr_cursor,subimg,cursor_x,cursor_y)