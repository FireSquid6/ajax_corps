occluder=new BulbDynamicOccluder(global.renderer)
occluder.AddEdge(bbox_top,bbox_right,bbox_top,bbox_left)
occluder.AddEdge(bbox_bottom,bbox_right,bbox_bottom,bbox_left)
occluder.AddEdge(bbox_top,bbox_left,bbox_bottom,bbox_left)
occluder.AddEdge(bbox_top,bbox_right,bbox_bottom,bbox_right)
occluder.x=x
occluder.y=y
image_blend=c_blue