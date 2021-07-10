//CLICKABLE SPRITE
//selector
function draw_ui_selector()
{
	if isSelected
	{
		//vars
		#macro SELECTOR_PAD_FACTOR 4
		#macro SELF_WIDTH 48
		#macro SELF_HEIGHT 48
		var xx,yy,xscale,yscale
		var width=sprite_get_width(sprite_index)
		var height=sprite_get_height(sprite_index)
		
		xx=x+width*0.5
		yy=y+height*0.5
	
		xscale=(width/SELF_WIDTH)*image_xscale
		yscale=(height/SELF_HEIGHT)*image_yscale
	
		draw_sprite_ext(spr_ui_selector,1,xx,yy,xscale,yscale,0,c_white,1)
		return true
	}
	return false
}

function draw_ui_outline()
{
	draw_sprite_ext(spr_ui_outline,image_index,x,y,image_xscale,image_yscale,image_angle,image_blend,image_alpha)
}