global.naturalLightAmount=0.5

//create renderer
renderer=new BulbRenderer(c_black,BULB_MODE.HARD_BM_MAX,true)

//create natural light
naturalLight=new BulbLight(renderer,spr_pixel,1,obj_camera.cameraX,obj_camera.cameraY)
naturalLight.xscale=camera_get_view_width(view_camera[0])
naturalLight.yscale=camera_get_view_height(view_camera[0])
naturalLight.alpha=global.naturalLightAmount
