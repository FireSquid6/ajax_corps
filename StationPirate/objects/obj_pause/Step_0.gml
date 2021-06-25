if state==pauseStates.home
{
    var key_up=keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("W"))
    var key_down=keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S"))
    var key_select=keyboard_check_pressed(vk_space) || mouse_check_button_pressed(mb_left) || keyboard_check_pressed(vk_enter)
}