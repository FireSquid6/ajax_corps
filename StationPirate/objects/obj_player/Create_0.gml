//set vars
dashCooldown=0
dashTime=0
dashBuffered=false
flashTime=0
mask_index=spr_player

global.godMode=false

alive=true

weapon=new weapon_machinePistol(weaponTeams.player,id)
weapon.equip()

#macro MAX_HP 100
hp=MAX_HP

#macro ARM_DIST 14