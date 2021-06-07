//set vars
dashCooldown=0
dashTime=0
dashBuffered=false
flashTime=0
interactableSelected=noone
mask_index=spr_player

global.godMode=false

alive=true

weaponSelected=0
primary=new weapon_fist(weaponTeams.player,id)
primary.equip()
secondary=new weapon_fist(weaponTeams.player,id)

#macro MAX_HP 100
hp=MAX_HP

#macro ARM_DIST 14