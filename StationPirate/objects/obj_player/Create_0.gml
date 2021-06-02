//set vars
dashCooldown=0
dashTime=0
dashBuffered=false

global.godMode=false

weapon=new weapon_pistol(weaponTeams.player,id)
weapon.equip()

#macro MAX_HP 100
hp=MAX_HP

#macro ARM_DIST 14