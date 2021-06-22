switch state
{
    case doorStates.open:
        //switch to closing
        if interacted 
        {
            state=doorStates.closing
            set_tiles(0)
        }
        
        break 
    case doorStates.closed:
        set_tiles(1)
        
        //switch to opening
        if interacted 
        {
            state=doorStates.opening
            set_tiles(0)
        }
            
        break 
    case doorStates.opening:
        //animate
        image_index-=animation_speed
        
        //switch to closed
        if image_index==0
        {
            state=doorStates.closed
            set_tiles(1)
        }
        
        break 
    case doorStates.closing: 
        //animate
        image_index+=animation_speed
        
        //switch to open
        if image_index==image_number
        {
            state=doorStates.open
            set_tiles(0)
        }
        
        break
}