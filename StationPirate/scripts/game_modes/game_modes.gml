function game_set_mode(_mode)
{
	//VARIABLE GLOSSARY
		//healthpack_drop_percent - the percentage of your health you need to be at for a healthpack to drop from an enemy
		//enemy_skill_modifier - a variable that is added to the amount of time enemies spend in the shooting state, and
		//						 subtracted from the amount of time enemies spend in the strafing state
		//enemy_health_modifier - a factor multiplied into every enemy's starting health
		//enemies_lead_shots - whether or not enemies will lead their shots more accurately to kill the player
		//enemy_follow_range - the range an enemy will follow the player before switching back to an idle state
		//player_max_health - the player's default max health
	switch _mode
	{
		case gameModes.accessible:
			global.healthpack_drop_percent=0.5
			global.enemy_skill_modifier=0 
			global.enemy_health_modifier=1
			global.enemies_lead_shots=false 
			global.enemy_follow_range=600 
			global.enemy_damage_modifier=1
			global.player_max_health=200
			global.player_damage_modifier=1
			global.execute_factor=0.5
			global.allow_lock_on=true
			global.bullet_curve=true
			break
		case gameModes.challenging:
			global.healthpack_drop_percent=0.5
			global.enemy_skill_modifier=0 
			global.enemy_health_modifier=1
			global.enemy_damage_modifier=1
			global.enemies_lead_shots=false 
			global.enemy_follow_range=800 
			global.player_max_health=200 
			global.player_damage_modifier=1
			global.execute_factor=0.45
			global.allow_lock_on=true
			global.bullet_curve=false
			break
		case gameModes.expert:
			global.healthpack_drop_percent=0.25
			global.enemy_skill_modifier=0 
			global.enemy_health_modifier=1
			global.enemies_lead_shots=true
			global.enemy_follow_range=1000 
			global.enemy_damage_modifier=1.2
			global.player_max_health=100 
			global.player_damage_modifier=0.8
			global.execute_factor=0.30
			global.allow_lock_on=false
			global.bullet_curve=false
			
			if global.bloodbathMode=true
			{
				global.player_max_health=1
			}
			break
	}
}