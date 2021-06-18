switch state
{
	case transitionStates.waiting:
		var xx=x+(sprite_width*image_xscale)
		var yy=y+(sprite_width*image_yscale)

		tilemap_set_at_rectangle(x,y,xx,yy,global.collisionTilemap,1,TILE_SIZE)
		
		if place_meeting(x,y,obj_player)
		{	
			instance_deactivate_all(true)
			state=transitionStates.transitioning
			transition_x=display_get_gui_width()
			transitionSpd=display_get_gui_width() div TRANSITION_SPD
		}
		break
	case transitionStates.transitioning:
		if transition_x<0 room=next_room
		transition_x-=transitionSpd
		
		break
}