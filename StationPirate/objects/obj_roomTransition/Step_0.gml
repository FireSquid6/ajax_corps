switch state
{
	case transitionStates.waiting:
		if place_meeting(x,y,obj_player)
		{
			instance_deactivate_all(true)
			state=transitionStates.transitioning
			transition_x=display_get_gui_width()
			transitionSpd=display_get_gui_width()/15
		}
		break
	case transitionStates.transitioning:
		transition_x+=transitionSpd
		
		
		break
}