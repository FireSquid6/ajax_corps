global.naturalLightAmount=1

//create renderer
renderer=new BulbRenderer(make_color_rgb(30,30,40),BULB_MODE.SOFT_BM_ADD,true)

//create natural light
naturalLight=new BulbLight(renderer,spr_pixel,1,obj_camera.cameraX,obj_camera.cameraY)
naturalLight.xscale=camera_get_view_width(view_camera[0])
naturalLight.yscale=camera_get_view_height(view_camera[0])
naturalLight.blend=make_color_rgb(255,255,200)
naturalLight.alpha=global.naturalLightAmount
