//declare variables
cameraX=0
cameraY=0
target=obj_player

setup_camera()

//alarm 0 centers the window. This has to be done a frame after for some reason
alarm[0]=1

//move to the target instance
cameraX=target.x-(cameraWidth*0.5)
cameraY=target.y-(cameraHeight*0.5)