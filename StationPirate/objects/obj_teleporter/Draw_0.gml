if plr.interactableSelected==id 
{
	shader_set(shd_white)
	image_blend=c_yellow
}
draw_self()
shader_reset()
image_blend=c_white