global.collisionTilemap=layer_tilemap_get_id("collision")
global.partSystem=part_system_create_layer("particles",false)

//create motion grid
global.motionGrid=mp_grid_create(0,0,room_width/TILE_SIZE,room_height/TILE_SIZE,TILE_SIZE,TILE_SIZE)
var row=0
for (var i=0;row==(room_height div TILE_SIZE); i++)
{
	//figure out which cell to check
	if i==(room_width div TILE_SIZE)
	{
		
	}
	
	//mark cells as forbidden
	
	
}