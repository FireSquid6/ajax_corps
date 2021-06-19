switch state
{
	case transitionStates.waiting:
		if place_meeting(x,y,obj_player)
		{	if global.enemiesAlive<1
			{	
				instance_deactivate_all(true)
				state=transitionStates.transitioning
				transition_x=display_get_gui_width()
				transitionSpd=display_get_gui_width() div TRANSITION_SPD
			}
			else if do_popup==true
			{
				create_popup(x,y,"KILL ALL ENEMIES",fnt_popup_damage,c_white,0.02,1,270)
				do_popup=false
			}
		}
		else
		{
			do_popup=true
		}
		break
	case transitionStates.transitioning:
		if transition_x<0 room=next_room
		transition_x-=transitionSpd
		
		break
}