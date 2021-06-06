//this object makes me want to die
if plr.interactableSelected==id && plr.key_interact 
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