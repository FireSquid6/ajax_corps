//make collision layer invisible
layer_set_visible("collision",global.debugMode)

//get tilemap
global.collisionTilemap=layer_tilemap_get_id("collision")

//create particle system
global.partSystem=part_system_create_layer("particles",false)

//create motion grid
global.motionGrid=mp_grid_create(0,0,(room_width div TILE_SIZE),(room_height div TILE_SIZE),TILE_SIZE,TILE_SIZE)
tilemap_to_mp_grid(global.collisionTilemap,global.motionGrid,room_width,room_height,TILE_SIZE)

//set mode
game_set_mode(gameModes.challenging)

//create transition
instance_create_layer(0,0,"meta",obj_transition)

//get enemy count
var count=0
with par_enemy
{
	count++
}
global.enemyCount=count
global.enemiesAlive=global.enemyCount

//vars
paused=false