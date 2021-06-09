function collision_line_tile(x1,y1,x2,y2,tile_size)
{
	var cx=x1
	var cy=y1
	tile_size*=0.5
	
	if point_distance(x1,y1,x2,y2)==0 exit
	do
	{
		if (abs(y2-y1)>abs(x2-x1))
	    {
			
		}
		else
		{
			
		}
	}
	until cx>=x2 && cy>=y2
}