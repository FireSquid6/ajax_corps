//update natural light
naturalLight.x=obj_camera.cameraX
naturalLight.y=obj_camera.cameraY

//update the renderer
renderer.UpdateFromCamera(view_camera[0])
gpu_set_blendmode(bm_normal)