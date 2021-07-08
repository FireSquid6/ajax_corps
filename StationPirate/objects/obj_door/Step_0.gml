switch state
{
    case doorStates.open:
        set_tiles(0)
        image_index=image_number-1
        
        //switch to closing
        if interacted 
        {
            state=doorStates.closed
            set_tiles(0)
        }
        
        break 
    case doorStates.closed:
        set_tiles(1)
        image_index=0
        
        //deal damamge to the player if he gets in the door
        if place_meeting(x,y,obj_player)
        {
            if damageTimer<1
            {
                deal_damage(10,obj_player)
                damageTimer=30
            }
            damageTimer--
        }
        
        //switch to opening
        if interacted 
        {
            state=doorStates.open
            set_tiles(0)
        }
            
        break 
    case doorStates.opening:
        set_tiles(0)
        
        //animate
        image_index-=animation_speed
        
        //switch to closed
        if image_index==1
        {
            state=doorStates.open
            set_tiles(1)
        }
        
        break 
    case doorStates.closing: 
        set_tiles(0)
        
        //animate
        image_index+=animation_speed
        
        //switch to open
        if image_index==image_number-1
        {
            state=doorStates.closed
            set_tiles(0)
        }
        
        break
}