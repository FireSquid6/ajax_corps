//CLICKABLE SPRITE
//selector
function draw_ui_selector()
{
	if isSelected
	{
		//vars
		#macro SELECTOR_PADDING 8
		var xx,yy,xscale,yscale
		var width=sprite_get_width(sprite_index)
		var height=sprite_get_height(sprite_index)
	
		xx=x-SELECTOR_PADDING
		yy=y-SELECTOR_PADDING
		xscale=image_xscale
		yscale=image_yscale
	
		draw_sprite_ext(spr_ui_selector,1,xx,yy,xscale,yscale,0,c_white,1)
		return true
	}
	return false
}