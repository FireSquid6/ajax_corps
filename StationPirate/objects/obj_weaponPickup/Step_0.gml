//this object makes me want to die
if plr.interactableSelected==id && plr.key_interact 
{
	if plr.weaponSelected==0
	{
		plr.primary=weapon
		plr.primary.equip()
	}
	else
	{
		plr.secondary=weapon
		plr.secondary.equip()
	}
	instance_destroy()
}

//remember to make the weapon run it's equip function later!!!!