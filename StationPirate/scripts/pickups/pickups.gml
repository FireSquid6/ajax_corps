function create_pickup_weapon(_x,_y,_weaponstring,_inReserve)
{
	var pickup=instance_create_layer(_x,_y,"pickups",obj_pickup)
	pickup.struct=new pickup_weapon(pickup,_weaponstring,_inReserve)
	pickup.struct.create()
}

function create_pickup_healthpack(_x,_y,_amount)
{
	var pickup=instance_create_layer(_x,_y,"pickups",obj_pickup)
	pickup.struct=new pickup_healthpack(pickup,_amount)
	pickup.struct.create()
}

function create_pickup_ammo(_x,_y)
{
	var pickup=instance_create_layer(_x,_y,"pickups",obj_pickup)
	pickup.struct=new pickup_ammo(pickup)
	pickup.struct.create()
}

function pickup_check_interacted(_id)
{
	var interacted=((obj_player.key_interact) && (obj_player.interactableSelected==_id))
	return interacted
}

function pickup_parent(_obj) constructor
{
	inst=_obj
	create=function()
	{
		
	}
	check=function()
	{
		var used=(pickup_check_interacted(inst))
		return used
	}
	action=function()
	{
		
	}
	step=function()
	{
		if check()
		{
			action()
			instance_destroy(inst)
		}
	}
	draw=function()
	{
		with inst
		{
			draw_set_color(c_white)
			draw_set_font(fnt_default)

			if obj_player.interactableSelected==id 
			{
				shader_set(shd_white)
				image_blend=c_yellow
			}
			draw_self()
			shader_reset()
			image_blend=c_white
		}
	}
}

function pickup_weapon(_obj,_weapon_string,_inReserve) : pickup_parent(_obj) constructor
{
	weapon=get_weapon_struct(_weapon_string,weaponTeams.player,obj_player)
	if weapon==-1 show_error("get_weapon_struct() returned -1",true)
	weapon.inReserve=_inReserve
	
	create=function()
	{
		inst.sprite_index=weapon.pickup_sprite
	}
	
	action=function()
	{
		obj_player.weapon=weapon
		obj_player.weapon.equip()
	}
}

function pickup_ammo(_obj) : pickup_parent(_obj) constructor
{
	create=function()
	{
		inst.sprite_index=spr_ammo
	}
	check=function()
	{
		var used=(pickup_check_interacted(inst) && obj_player.key_interact && variable_struct_exists(obj_player.weapon,"inReserve"))
		return used
	}
	action=function()
	{
		obj_player.weapon.inReserve+=obj_player.weapon.magSize
	}
}

function pickup_healthpack(_obj,_amount) : pickup_parent(_obj) constructor
{
	amount=_amount
	create=function()
	{
		inst.sprite_index=spr_healthpack
		inst.image_speed=0
		if amount>=100
		{
			inst.image_index=0
		}
		else if amount>=50
		{
			inst.image_index=1
		}
		else
		{
			inst.image_index=2
		}
	}
	action=function()
	{
		obj_player.hp+=amount
		obj_player.hp=clamp(obj_player.hp,0,MAX_HP)
	}
}