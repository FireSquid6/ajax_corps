#region particles types

//dash particle
var p=part_type_create()
part_type_shape(p,pt_shape_pixel)
part_type_life(p,20,30)
part_type_alpha2(p,0.5,0.1)
part_type_size(p,3,3,0,0)
part_type_direction(p,0,360,0,25)
part_type_speed(p,2,3,0,0)
part_type_color_mix(p,$ffff00,$ff8700)

global.ptDashTrail=p

#endregion