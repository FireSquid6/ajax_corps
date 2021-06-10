if instance_exists(target)
{
	var key_look=keyboard_check(vk_lshift)
	var lp=0.3+(0.3*key_look)
	
	cameraX=target.x-(cameraWidth*0.5)
	cameraY=target.y-(cameraHeight*0.5)
	
	cameraX=lerp(target.x,mouse_x,lp)-(cameraWidth*0.5)
	cameraY=lerp(target.y,mouse_y,lp)-(cameraHeight*0.5)
	
	cameraX=clamp(cameraX,0,room_width-cameraWidth)
	cameraY=clamp(cameraY,0,room_height-cameraHeight)
}

camera_set_view_pos(view_camera[0],cameraX,cameraY)