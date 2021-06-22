image_speed=0
set_tiles=function(on)
{
    //finish this later
    tilemap_set_at_pixel(global.collisionTilemap,data,x,y)
    if on mp_grid_add_rectangle(global.motionGrid,x,y,x+32,y)
    tilemap_set_at_pixel(global.collisionTilemap,data,x+32,y+lengthdir_x(TILE_SIZE,image_angle+90))
    
}

animation_speed=0.5
damageTimer=30
enum doorStates
{
    open,
    closed,
    opening,
    closing
}
state=doorStates.closed