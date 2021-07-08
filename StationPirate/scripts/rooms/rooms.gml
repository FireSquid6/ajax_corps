function room_structure_init()
{
	#macro ROOM_GRID_WIDTH 20
	#macro ROOM_GRID_HEIGHT 20
	
	global.roomGrid=ds_grid_create(ROOM_GRID_WIDTH,ROOM_GRID_HEIGHT)
	
	var i=room_first
	var name,level,section,doMapping
	while room_exists(i)
	{
		name=room_get_name(i)
		level=string_char_at(name,10)
		section=string_char_at(name,12)
		
		if string_char_at(name,4)=="l" && string_char_at(name,5)=="e" doMapping=true else doMapping=false
		if doMapping
		{
			level=real(level)
			section=real(section)
			ds_grid_add(global.roomGrid,level,section,i)
		}
		
		//goto next room
		i=room_next(i)
	}
}

function room_get_index(_level,_section)
{
	
}