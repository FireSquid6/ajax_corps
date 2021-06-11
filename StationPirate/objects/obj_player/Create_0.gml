//set vars
dashCooldown=0
dashTime=0
dashBuffered=false
flashTime=0
interactableSelected=noone
mask_index=spr_player

hsp=0
vsp=0

rArmPos=global.arm_pos_walking.r
lArmPos=global.arm_pos_walking.l

global.godMode=false

alive=true

weapon=new weapon_fist(weaponTeams.player,id)
weapon.equip()

#macro MAX_HP 100
hp=MAX_HP

#macro ARM_DIST 14