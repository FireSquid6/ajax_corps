if alive
{
	//reload bar
	if weapon.reloading
	{
		weapon.draw_reload_bar()
	}
	//health bar
	else 
	{
		var backColor=c_grey
		var barColor=c_aqua
		var healthPercent=(hp/global.player_max_health)*100
		healthPercent=floor(healthPercent)
		var barWidth=sprite_get_width(spr_healthbar);
		var barX=x-(barWidth*5);
		var barY=y-40;
		var a=1
		
		//get alpha
		if lastHit>HEALTHBAR_FRAMES
		{
			var n=(lastHit-HEALTHBAR_FRAMES)
			a=((n/50)*-1)+1
		}
		
		//draw back bars
		repeat 10
		{
			draw_sprite_ext(spr_healthbar,1,barX,barY,1,1,0,backColor,a);
			barX+=barWidth;
		}
		
		barX=x-(barWidth*5);
		
		//draw full bars
		while healthPercent>0
		{
			draw_sprite_ext(spr_healthbar,1,barX,barY,1,1,0,barColor,a);
			barX+=barWidth;
			healthPercent-=10;
		}
		
		draw_set_alpha(1)
	}

	//shaders
	if flashTime>0 
	{
		shader_set(shd_white)
		flashTime--
	}

	//weapon sprite
	weapon.draw()
	
	//right arm
	draw_sprite_ext(spr_playerArm,1,
	x+lengthdir_x(ARM_DIST,image_angle+rArmPos),
	y+lengthdir_y(ARM_DIST,image_angle+rArmPos),
	1,1,image_angle,c_white,1)

	//left arm
	draw_sprite_ext(spr_playerArm,1,
	x+lengthdir_x(ARM_DIST,image_angle+lArmPos),
	y+lengthdir_y(ARM_DIST,image_angle+lArmPos),
	1,1,image_angle,c_white,1)
	
	//line
	if global.debugMode
	{
		draw_set_font(fnt_default)
		draw_set_color(c_white)
		draw_text(x,y-50,"COUNT: "+string(global.enemyCount))
		draw_text(x,y-60,"ALIVE: "+string(global.enemiesAlive))
		var percent=(global.player_max_health*0.5)
		draw_text(x,y-70,"LAST HIT: "+string(lastHit))
		draw_text(x,y-80,"HP"+string(hp))
	}
}

//self
draw_self()

//reset
shader_reset()