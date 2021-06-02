if flashTime>0 
{
	gpu_set_fog(true,c_white,0,0)
	weapon.draw()
	draw_self()
	gpu_set_fog(false,c_white,0,0)
	flashTime--
}
else
{
	weapon.draw()
	draw_self()
}