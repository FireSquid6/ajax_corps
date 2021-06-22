image_speed=0
set_tiles=function(data)
{
    tilemap_set_at_pixel(global.collisionTilemap,data,x,y)
    tilemap_set_at_pixel(global.collisionTilemap,data,x+lengthdir_x(TILE_SIZE,image_angle+90),y+lengthdir_x(TILE_SIZE,image_angle+90))
}

animation_speed=0.5
enum doorStates
{
    open,
    closed,
    opening,
    closing
}
state=doorStates.closed