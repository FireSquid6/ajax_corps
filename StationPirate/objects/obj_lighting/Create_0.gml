<<<<<<< Updated upstream
global.naturalLightAmount=0.8
=======
global.naturalLightAmount=1
>>>>>>> Stashed changes

//create renderer
global.renderer=new BulbRenderer(make_color_rgb(0,0,0),BULB_MODE.SOFT_BM_ADD,true)

//create natural light
naturalLight=new BulbLight(global.renderer,spr_pixel,1,obj_camera.cameraX,obj_camera.cameraY)
naturalLight.xscale=camera_get_view_width(view_camera[0])
naturalLight.yscale=camera_get_view_height(view_camera[0])
naturalLight.blend=make_color_rgb(255,255,255)
naturalLight.alpha=global.naturalLightAmount
naturalLight.penumbraSize=1
