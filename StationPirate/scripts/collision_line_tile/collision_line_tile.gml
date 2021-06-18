function collision_line_tile(_x1,_y1,_x2,_y2,tilemap,precision)
{
	//This function checks if a given line collides with any tile on a tilemap
	//x1 - starting x position
	//x2 - starting y position
	//note - it's faster to put x1 and y1 as the position most likely to hit a tile first
	//x2 - ending x position
	//y2 - ending y position
	//tilemap - tilemap id returned from layer_tilemap_get_id()
	//precision - how many pixels the raycast moves per loop
	
	//set the x and y variables that will be manipulated
	var xx=_x1
	var yy=_y1
	
	//get the radius of the circle because im stupid and am using point_in_circle()
	var radius=point_distance(_x1,_y1,_x2,_y2)
	
	//get the direction for lengthdir function
	var dir=point_direction(_x1,_y1,_x2,_y2)
	
	//start the loop
	while point_in_circle(xx,yy,_x1,_y1,radius) //yes there is probably a better way to do this but this is the first idea that came up in my head
	{
		//check if tilemap is at the point
		if tilemap_get_at_pixel(tilemap,xx,yy)==1
		{
			return true
		}
		
		//move xx and yy
		xx+=lengthdir_x(precision,dir)
		yy+=lengthdir_y(precision,dir)
	}
	
	//if nothing was found, return false
	return false
}