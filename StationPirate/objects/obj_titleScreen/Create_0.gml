//game init stuff
instance_create_layer(0,0,"Instances",obj_game)

//set camera
setup_camera()
alarm[0]=1

//create UI boxes
genericBox=new clickable_sprite(200,200,spr_ui_box,0)
genericBox.changeFormat(1,c_red,1)
genericBox.scale(2,4)
genericBox.addSubimgChange(2)
ds_list_add(genericBox.postDrawFunctions,draw_ui_outline)