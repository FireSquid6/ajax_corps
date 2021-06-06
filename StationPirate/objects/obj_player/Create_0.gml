//set vars
dashCooldown=0
dashTime=0
dashBuffered=false
flashTime=0
mask_index=spr_player

global.godMode=false

alive=true

weaponSelcted=0
primary=new weapon_machinePistol(weaponTeams.player,id)
primary.equip()
secondary=new weapon_fist(weaponTeams.player,id)
secondary.equip()

#macro MAX_HP 100
hp=MAX_HP

#macro ARM_DIST 14