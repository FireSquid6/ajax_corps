if instance_exists(target)
{
	//this code does extra stuff that sets linear interpolation to move the camera
	//between the mouse and the player depending on if the left shift key is pressed
	//im not entirely sure how it works
	var key_look=keyboard_check(vk_lshift)
	var lp=0.3+(0.3*key_look)
	
	//move to the target instance
	cameraX=target.x-(cameraWidth*0.5)
	cameraY=target.y-(cameraHeight*0.5)
	
	//linear interpolate by variables set earlier
	//I don't actually know what linear interpolation is, all I know is that it works
	cameraX=lerp(target.x,obj_game.cursor_x,lp)-(cameraWidth*0.5)
	cameraY=lerp(target.y,obj_game.cursor_y,lp)-(cameraHeight*0.5)
	
	//stop the camera from showing stuff outside of the room
	cameraX=clamp(cameraX,0,room_width-cameraWidth)
	cameraY=clamp(cameraY,0,room_height-cameraHeight)
}

//set the cameras position to the new x and y position
camera_set_view_pos(view_camera[0],cameraX,cameraY)