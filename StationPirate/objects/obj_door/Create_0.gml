image_speed=0
set_tiles=function(on)
{
    if on mp_grid_add_rectangle(global.motionGrid,bbox_left,bbox_top,bbox_right,bbox_bottom)
    //finish this later
    tilemap_set_at_pixel(global.collisionTilemap,on,bbox_left,bbox_top)
    tilemap_set_at_pixel(global.collisionTilemap,on,bbox_right,bbox_bottom)
    
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