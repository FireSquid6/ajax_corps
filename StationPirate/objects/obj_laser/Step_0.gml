//get list of collided objects
var colList=ds_list_create()
var targ
collision_rectangle_list(bbox_left,bbox_top,bbox_right,bbox_bottom,par_entity,false,true,colList,false)
while ds_list_size(colList)>0
{
	targ=ds_list_find_value(colList,0)
	deal_damage(9999,targ) //kill collided object
	ds_list_delete(colList,0)
}