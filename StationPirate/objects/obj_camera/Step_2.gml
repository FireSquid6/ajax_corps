if instance_exists(target)
{
	cameraX=target.x-(cameraWidth*0.5)
	cameraY=target.y-(cameraHeight*0.5)
	
	cameraX=lerp(target.x,mouse_x,0.3)-(cameraWidth*0.5)
	cameraY=lerp(target.y,mouse_y,0.3)-(cameraHeight*0.5)
	
	cameraX=clamp(cameraX,0,room_width-cameraWidth)
	cameraY=clamp(cameraY,0,room_height-cameraHeight)
}

camera_set_view_pos(view_camera[0],cameraX,cameraY)