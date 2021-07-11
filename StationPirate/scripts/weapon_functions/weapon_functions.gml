enum weaponTeams
{
	player,
	enemy
}

enum weaponRanges
{
	melee,
	short,
	medium,
	long
}
enum ammoTypes
{
	none=0,
	light=1,
	medium=2,
	heavy=3,
	shell=4,
	battery=5,
	superBattery=6
}
enum weaponIds
{
	none,
	fist,
	pistol,
	machinePistol,
	pumpShotgun,
	autoShotgun,
	assaultRifle,
	sniper
}

function get_weapon_struct(str,team,obj)
{
	var w=0
	switch str
	{
		case "none":
			w=new weapon_none(team,obj)
			break
		case "melee":
			w=new weapon_none(team,obj)
			break
		case "fist":
			w=new weapon_none(team,obj)
			break
		case "pistol":
			w=new weapon_pistol(team,obj)
			break
		case "handgun":
			w=new weapon_pistol(team,obj)
			break
		case "machinePistol":
			w=new weapon_machinePistol(team,obj)
			break
		case "machine_pistol":
			w=new weapon_machinePistol(team,obj)
			break
		case "pump shotgun":
			w=new weapon_pump_shotgun(team,obj)
			break
		case "auto shotgun":
			w=new weapon_pump_shotgun(team,obj)
			break
		case "pump_shotgun":
			w=new weapon_pump_shotgun(team,obj)
			break
		case "auto_shotgun":
			w=new weapon_pump_shotgun(team,obj)
			break
		case "assault_rifle":
		    w=new weapon_assault_rifle(team,obj)
		    break
		case "sniper":
			w=new weapon_sniper(team,obj)
			break
	}
	if w!=0 return w else return -1
}

function get_weapon_string(_struct)
{
	var s="null"
	var weaponId=_struct.id
	switch weaponId
	{
		case weaponIds.none:
			s="none"
			break
		case weaponIds.pistol:
			s="pistol"
			break
		case weaponIds.machinePistol:
			s="machine_pistol"
			break
		case weaponIds.pumpShotgun:
			s="pump_shotgun"
			break
		case weaponIds.autoShotgun:
			s="auto_shotgun"
			break
		case weaponIds.assaultRifle:
		    s="assault_rifle"
		    break
		case weaponIds.sniper:
			s="sniper"
			break
	}
	if s!="null" return s else return -1
}
