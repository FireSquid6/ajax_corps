//set vars
dashCooldown=0
dashTime=0
dashBuffered=false
flashTime=0
interactableSelected=noone
mask_index=spr_player
key_interact=false

shieldCooldown=MAX_SHIELD_COOLDOWN

hsp=0
vsp=0
ammoAlpha=0

lastHit=MAX_LAST_HIT

rArmPos=global.arm_pos_walking.r
lArmPos=global.arm_pos_walking.l

global.godMode=false

alive=true
executing=false
ani_index=0

lockedOn=false
dir=point_direction(x,y,mouse_x,mouse_y)
locked_target=noone

energy=MAX_ENERGY;
energyCooldown=MAX_ENERGY_COOLDOWN;
canStop=false
slowFieldEnabled=false

weapon=get_weapon_struct(starting_weapon,weaponTeams.player,id)
if starting_ammo>0 && weapon.id!=weaponIds.none weapon.inReserve=starting_ammo else weapon.inReserve=weapon.inMag*abs(starting_ammo)

weapon.equip()

hp=global.player_max_health

#macro ARM_DIST 14

//create game
instance_create_layer(0,0,"meta",obj_game)

//create camera
instance_create_layer(x,y,"meta",obj_camera)