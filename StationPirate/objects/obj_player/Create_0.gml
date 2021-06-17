//set vars
dashCooldown=0
dashTime=0
dashBuffered=false
flashTime=0
interactableSelected=noone
mask_index=spr_player
key_interact=false

hsp=0
vsp=0

rArmPos=global.arm_pos_walking.r
lArmPos=global.arm_pos_walking.l

global.godMode=false

alive=true

weapon=new weapon_fist(weaponTeams.player,id)
weapon.equip()

hp=global.player_max_health

#macro ARM_DIST 14

//create game
instance_create_layer(0,0,"meta",obj_game)

//create camera
instance_create_layer(x,y,"meta",obj_camera)