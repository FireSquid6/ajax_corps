//room mapping
room_structure_init()

//scribble
scribble_font_add("arial")
scribble_font_add("eightbit")
scribble_font_add("pixeled")

//PARTICLES
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
part_type_alpha2(p,1,0.5)
part_type_size(p,3,3,-0.2,0)
part_type_direction(p,0,360,0,0)
part_type_speed(p,4,5,0,0)
part_type_color_mix(p,$00007c,$1a1aff)

global.ptBlood=p

//execute particles
#macro EXECUTE_PARTICLES_AMOUNT 6
p=part_type_create()
part_type_shape(p,pt_shape_pixel)
part_type_life(p,12,15)
part_type_size(p,3,4,-0.2,0)
part_type_speed(p,4,5,0,0)
part_type_color_mix(p,$00007c,$1a1aff)

global.ptExecute=p

//kill particles
#macro DEAD_PARTICLES_AMMOUNT 50
p=part_type_create()
part_type_shape(p,pt_shape_pixel)
part_type_life(p,300,500)
part_type_alpha2(p,1,1)
part_type_size(p,8,10,-0.3,0)
part_type_direction(p,0,360,0,5)
part_type_speed(p,5,6,0,0)
part_type_color_mix(p,$00007c,$1a1aff)

global.ptDead=p

//poison particle
#macro POISON_PARTICLES_AMOUNT 2
p=part_type_create()
part_type_shape(p,pt_shape_pixel)
part_type_life(p,60,80)
part_type_size(p,4,6,-0.1,0)
part_type_direction(p,0,360,0,5)
part_type_speed(p,0.1,0.4,-0.01,0)
part_type_color_mix(p,$1bff3f,$008f17)

global.ptPoison=p

//ARM POSITIONS
global.arm_pos_walking=
{
	l: 130,
	r: 50
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

#macro shootPriority 10
#macro reloadPriority 8
#macro hitPriority 20
#macro dashPriority 15
#macro pickupPriority 0
#macro playerDeadPriority 100
#macro enemyDeadPriority 50

#macro EXECUTE_RANGE 96
#macro EXECUTE_DIST 40

#macro pickupRange 64
#macro WALK_SPD 6
#macro MAX_DASH_COOLDOWN 20
#macro DASH_FRAMES 20
#macro DASH_SPD 12
#macro TILE_SIZE 32
#macro TRANSITION_SPD 15 //lower = faster, higher = slower

#macro DASH_SHIELD_RADIUS 32
#macro DASH_DRAW_CIRCLES 5

#macro MAX_LAST_HIT 140
#macro HEALTHBAR_FRAMES 90

#macro MAX_LAST_SHOOT 110
#macro DRAW_AMMO_FRAMES 60

#macro SHIELD_ALIVE_FRAMES 60
#macro MAX_SHIELD_COOLDOWN 15
#macro MAX_SHIELD_RADIUS 48
#macro SHIELD_RADIUS_GROWTH 8
#macro SHIELD_ALPHA_LOSS 1/60
#macro SHIELD_LIFESPAN 120

#macro MAX_ENERGY 120
#macro MAX_ENERGY_COOLDOWN 30
#macro ENERGY_GAIN 2
#macro ENERGY_LOSS 1
#macro ENERGY_FIELD_SIZE 128

//tips
global.tips=ds_list_create()
ds_list_add(global.tips,"Not enough firepower? Try executing an enemy to steal their weapon.")
ds_list_add(global.tips,"You can manually reload by pressing R")
ds_list_add(global.tips,"Sometimes locking on to enemies can be a crutch. Manual aiming puts you fully in control.")

//debug mode
global.debugMode=false

enum gameModes
{
	accessible,
	challenging,
	expert
}
game_set_mode(gameModes.challenging)