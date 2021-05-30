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

//blood particle
p=part_type_create()
part_type_shape(p,pt_shape_pixel)
part_type_life(p,7,12)
part_type_alpha2(0,1,0.5)
part_type_size(p,3,3,-0.2,0)
part_type_direction(p,0,360,0,0)
part_type_speed(p,4,5,0,0)
part_type_color_mix(p,$00007c,$1a1aff)

global.ptBlood=p

#endregion

#region arm positions

global.arm_pos_walking=
{
	l: 140,
	r: 40
}

global.arm_pos_handgun=
{
	l: 100,
	r: 85
}

global.arm_pos_rifle=
{
	l: 65,
	r: 345
}

#endregion