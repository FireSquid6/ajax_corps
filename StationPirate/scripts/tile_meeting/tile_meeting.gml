function tile_meeting(_x,_y,_layer)
{
	var tm=layer_tilemap_get_id(_layer)
	var x1,y1,x2,y2
	x1=tilemap_get_cell_x_at_pixel(tm,bbox_left+(_x-x),y)
	y1=tilemap_get_cell_x_at_pixel(tm,x,bbox_top+(_y-y))
	x2=tilemap_get_cell_x_at_pixel(tm,bbox_right+(_x-x),y)
	y2=tilemap_get_cell_x_at_pixel(tm,x,bbox_bottom+(_y-y))
	
	for (var xx=x1; xx<=x2; xx++)
	{
		for (var yy=y1; yy<=y2; yy++)
		{
			if tile_get_index(tilemap_get(tm,xx,yy))
			{
				return true
			}
		}
	}
}

return false