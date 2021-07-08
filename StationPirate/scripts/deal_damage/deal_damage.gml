function deal_damage(_dmg,_id) 
{
	//check if object is dashing
	if variable_instance_exists(_id,"dashTime")
	{
		if _id.dashTime>0 exit
	}
	
	//check if object is alive
	if variable_instance_exists(_id,"alive")
	{
		if _id.alive==false exit
	}
	
    //get defense
    var def=0
    if variable_instance_exists(_id,"defense")
    {
        def=_id.defense
    }
    
    if variable_instance_exists(_id,"hp")
    {
		
        //check shields
        if variable_instance_exists(_id,"shields")
        {
            //deal damage to shields
            if _id.shields>0
            {
                _id.shields-=dmg_equation(_dmg,1,def)
            }
        }
        else
        {
            //deal damage to health
            _id.hp-=dmg_equation(_dmg,1,def)
        }
        
		//flash time
		if variable_instance_exists(_id,"flashTime")
		{
			_id.flashTime=3
		}
		
        //play sound
        audio_play_sound(snd_smallDamage,hitPriority,false)
        
		var clr=c_white
		if _id==obj_player.id clr=c_red
        //create popup
        create_popup(_id.x,_id.y,string(_dmg),fnt_popup_damage,clr,0.01,0.5,270)
        
        //set last hit
        _id.lastHit=0
        
        //return damage done        
        return true
    }
    else
    {
        show_error("Tried to deal damage to an entity that doesn't want it",true)
    }
}

function dmg_equation(__dmg,_modifier,_def)
{
    return (__dmg*_modifier)-(_def*0.25)
}