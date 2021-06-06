//this object makes me want to die
if place_meeting(x,y,plr)
{
	var plrweap
	if plr.weaponSelected==0 plrweap=plr.primary else plrweap=plr.secondary
	if weapon.display_name==plrweap.display_name
	{
		if plr.weaponSelected==0 plr.primary.inReserve+=weapon.inReserve else plr.secondary.inReserve+=weapon.inReserve
	}
}

if plr.interactableSelected=id && plr.key_interact 
{
	if plr.weaponSelected==0
	{
		plr.primary=weapon
	}
	else
	{
		plr.secondary=weapon
	}
	instance_destroy()
}