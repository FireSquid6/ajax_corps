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