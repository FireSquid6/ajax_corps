if place_meeting(x,y,plr)
{
	if variable_struct_exists(plr.primary,"inReserve")
	{
		if plr.primary.ammoType==ammoType
		{
			plr.primary.inReserve+=ammount
			audio_play_sound(snd_ammoPickup,pickupPriority,false)
			instance_destroy()
		}
	}
	if variable_struct_exists(plr.secondary,"inReserve")
	{
		if plr.secondary.ammoType==ammoType
		{
			plr.secondary.inReserve+=ammount
			audio_play_sound(snd_ammoPickup,pickupPriority,false)
			instance_destroy()
		}
	}
}