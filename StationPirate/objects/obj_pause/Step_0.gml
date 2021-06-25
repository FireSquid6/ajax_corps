if state==pauseStates.home
{
    //get keys
    var key_up=keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("W"));
    var key_down=keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S"));
    var key_select=keyboard_check_pressed(vk_space) || mouse_check_button_pressed(mb_left) || keyboard_check_pressed(vk_enter);
    
    selected+=(key_up-key_down);
    selected=clamp(selected,pauseSelected.resume,pauseSelected.title);

    //change state
    if key_select
    {
        switch selected
        {
            case pauseSelected.resume:
                obj_game.paused=false;
                break ;
            case pauseSelected.restartRoom:
                room_restart();
                break;
            case pauseSelected.restartLevel:
                //go to start of level
                break;
            case pauseSelected.settings:
                state=pauseStates.settings;
                break;
            case pauseSelected.accesibilitySettings:
                state=pauseStates.accessibilitySettings;
                break;
            case pauseSelected.title:
                room_goto(room_first);
                break;
        }
    }
}