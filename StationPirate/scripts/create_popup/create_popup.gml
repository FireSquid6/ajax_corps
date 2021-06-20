function create_popup(_x,_y,_text,_font,_color,_alpha_loss,_speed,_direction)
{
    var inst=instance_create_layer(_x,_y,"popups",obj_popup)
    inst.text=_text
    inst.fnt=_font
    inst.clr=_color
    inst.alpha_loss=_alpha_loss
    inst.spd=_speed
    inst.dir=_direction
}

function get_popup_color(dmg)
{
    var color
    if dmg<=10
    {
        color=c_white
    }
    else if dmg<=25
    {
        color=c_aqua
    }
    else if dmg<=50
    {
        color=c_red
    }
    else if dmg<=70
    {
        color=c_green
    }
    else if dmg<=90
    {
        color=c_fuchsia
    }
    else
    {
        color=c_yellow
    }
    
    return color
}