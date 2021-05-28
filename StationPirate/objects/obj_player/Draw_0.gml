draw_self()
draw_text(x,y-50,string(dashTime))
draw_text(x,y-60,string(dashCooldown))

var color
var line=collision_line_tile(x,y,mouse_x,mouse_y,global.collisionTilemap,TILE_SIZE)
if line color=c_red else color=c_white

draw_line_width_color(x,y,mouse_x,mouse_y,3,color,color)