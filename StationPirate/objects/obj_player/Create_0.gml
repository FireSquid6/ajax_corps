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

weaponSelected=0
primary=new weapon_auto_shotgun(weaponTeams.player,id)
primary.equip()
secondary=new weapon_pump_shotgun(weaponTeams.player,id)

#macro MAX_HP 100
hp=MAX_HP

#macro ARM_DIST 14