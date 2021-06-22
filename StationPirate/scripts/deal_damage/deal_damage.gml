function deal_damage(_dmg,_id,_team) 
{
    //get modifier
    var modifier
    if _team==weaponTeams.player modifier=global.player_damage_modifier else modifier=global.enemy_damage_modifier
    
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
                _id.shields-=dmg_equation(_dmg,modifier,def)
            }
        }
        else
        {
            //deal damage to health
            _id.hp-=dmg_equation(_dmg,modifier,def)
        }
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