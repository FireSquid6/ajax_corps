draw_set_alpha(1)
var subimg=0
if collision_point(mouse_x,mouse_y,par_enemy,false,true) subimg=1
draw_sprite(spr_cursor,subimg,mouse_x,mouse_y)

draw_set_alpha(0.3)
mp_grid_draw(global.motionGrid)