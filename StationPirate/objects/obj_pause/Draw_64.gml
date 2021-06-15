var gui_height=display_get_gui_height()
var gui_width=display_get_gui_width()
//draw box
draw_sprite_ext(spr_pixel,1,0,0,gui_width,gui_height,0,c_black,1)

//draw pause text
draw_text(gui_width*0.5,25,"GAME PAUSED")