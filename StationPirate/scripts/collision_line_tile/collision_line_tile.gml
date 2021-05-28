function collision_line_tile(x1,y1,x2,y2,tilemap,grid_size)
{
	#macro TILE_SIZE 32
	var dir=point_direction(x1,y1,x2,y2)
	var cX=x1
	var cY=y1
	var atPixel
	
	while (cX<=x2 && cY<=y2)
	{
		atPixel=tilemap_get_at_pixel(tilemap,cX,cY)
		if atPixel
		{
			return true
			break
		}
		cX+=lengthdir_x(grid_size,dir)
		cY+=lengthdir_y(grid_size,dir)
	}
	
	return false
}