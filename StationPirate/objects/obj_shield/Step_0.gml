//grow radius
if radius<MAX_SHIELD_RADIUS
{
	radius+=SHIELD_RADIUS_GROWTH
}
else radius=MAX_SHIELD_RADIUS //set radius to max if it went over

//check all bullets in radius
var targ
var list=ds_list_create()
collision_circle_list(x,y,radius,par_bullet,false,true,list,false) //get list of colliding bullets
while ds_list_size(list)>0 //loop through every instance in the list
{
	targ=ds_list_find_value(list,0) //get id of instance
	targ.inShield=true //stop the target instance
	ds_list_delete(list,0) //get rid of id from list
}

//check if should be losing alpha
if alphaLossTimer<1 losingAlpha=true else alphaLossTimer--

//subtract alpha
if radius=MAX_SHIELD_RADIUS && losingAlpha alpha-=SHIELD_ALPHA_LOSS

//check if player destroyed me
if obj_player.key_shield && !frameOne instance_destroy()

//check if alive
if alpha<=0 instance_destroy()

//reset frameOne
frameOne=false