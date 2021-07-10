//CLICKABLE SPRITE
//selector
function draw_ui_selector()
{
	var xx,yy,xscale,yscale
	
	draw_sprite_ext(spr_ui_selector,1,xx,yy,xscale,yscale,0,c_white,1)
}

function generic_loop_function()
{
	var foo=26
	foo+=rand(125)
	return foo
}