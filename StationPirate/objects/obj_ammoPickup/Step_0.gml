if place_meeting(x,y,plr)
{
	if plr.primary.ammoType==ammoType
	{
		plr.primary.inReserve+=ammount
	}
	else if plr.secondary.ammoType==ammoType
	{
		plr.secondary.inReserve+=ammount
	}
}