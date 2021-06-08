//get vars
cameraX=0
cameraY=0
target=obj_player

//camera
displayWidth=display_get_width()
displayHeight=display_get_height()

displayScale=2

cameraWidth=displayWidth/displayScale
cameraHeight=displayHeight/displayScale

view_enabled=true
view_visible[0]=true

camera_set_view_size(view_camera[0],cameraWidth,cameraHeight)

//display
if os_type==os_macosx
{
	window_set_fullscreen(true)
}

window_set_size(displayWidth,displayHeight)
surface_resize(application_surface,displayWidth,displayHeight)

display_set_gui_size(displayWidth,displayHeight)

alarm[0]=1