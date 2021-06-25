function room_save(_filename)
{
	var save_array=[]
	var struct
	
	//PLAYER
	with obj_player
	{
		struct=new save_constructor(id,x,y,hp,shield,weapon)
		struct.alive=alive
		array_push(save_array,struct)
	}
	
	//ENEMY
	with par_enemy
	{
		
	}
	
	//save the buffer
	var str=json_stringify(save_array)
	var buff=buffer_create(1024,buffer_grow,1)
	buffer_write(buff,buffer_string,str)
	buffer_save(buff,_filename)
}

function room_load(_filename)
{
	
}

function save_constructor(_id,_x,_y,_hp,_shield,_weapon) constructor
{
	id=_id
	x=_x
	y=_y
	hp=_hp
	shield=_shield
	weapon=_weapon
}