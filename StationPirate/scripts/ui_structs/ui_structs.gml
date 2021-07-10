//NOTE: THIS SCRIPT REQUIRES BOTH SCRIBBLE AND CLEAN SHAPES
//https://github.com/JujuAdams/scribble
//https://github.com/JujuAdams/Clean-Shapes

//SYSTEM FUNCTIONS - EDIT THESE TO CHANGE HOW THE SYSTEM PERCIEVES HOVERING AND CLICKING

//Checks if this UI element is "selected"
function __ui_check_hover(_x1,_y1,_x2,_y2)
{
	if point_in_rectangle(mouse_x,mouse_y,_x1,_y1,_x2,_y2) return true
	return false
}

//Checks if this UI element has been "clicked" on
function __ui_check_clicked(_hover)
{
	if _hover && mouse_check_button_pressed(mb_left) return true
	return false
}

//CLICKABLE RECTANGLE

//CLICKABLE SPRITE
function clickable_sprite(_x,_y,_sprite,_subimg) constructor
{
	#region MODIFYING FUNCTIONS
	//change format
	changeFormat=function(_defaultsubimg,_defaultblend,_defaultalpha)
	{
		blend=_defaultblend
		subimg=_defaultsubimg
		alpha=_defaultalpha
	}
	
	//transform
	scale=function(_scale)
	{
		image_xscale=_scale
		image_yscale=_scale
	}
	
	//overlay
	addOverlayChange=function(_color,_alpha) //ONLY WORKS IF ORIGIN IS IN THE CENTER OF THE SPRITE
	{
		doOverlayChange=true
		overlayChangeColor=_color
		overlayChangeAlpha=_alpha
	}
	removeOverlayChange=function()
	{
		doOverlayChange=false
	}
	
	//subimg
	addSubimgChange=function(_othersubimg)
	{
		doSubimgChange=true
		subimgChangeSubimg=_othersubimg
	}
	removeSubimgChange=function()
	{
		doSubimgChange=false
	}
	
	//blend
	addBlendChange=function(_color,_alpha)
	{
		doBlendChange=true
		blendChangeColor=_color
		blendChangeAlpha=_alpha
	}
	removeBlendChange=function()
	{
		doBlendChange=false
	}
	
	#endregion
	
	#region DEFAULT VARS
	//sprite format
	x=_x
	y=_y
	sprite_index=_sprite
	
	image_index=_subimg
	image_xscale=1
	image_yscale=1
	image_blend=c_white
	image_angle=0
	image_alpha=1
	subimg=_subimg
	blend=c_white
	alpha=1
	width=sprite_get_width(sprite_index)*image_xscale
	height=sprite_get_height(sprite_index)*image_yscale
	
	isSelected=false
	
	//subimage change
	doSubimgChange=false
	subimgChangeSubimg=1
	
	//overlay change
	doOverlayChange=false
	overlayChangeColor=c_white
	overlayChangeAlpha=1
	
	//blend change
	doBlendChange=false
	blendChangeColor=c_white
	blendChangeAlpha=1
	#endregion
	
	#region STEP FUNCTIONS
	//lists
	updateFunctions=ds_list_create()
	postDrawFunctions=ds_list_create()
	preDrawFunctions=ds_list_create()
	
	//functions
	update=function()
	{
		//get width and height
		width=sprite_get_width(sprite_index)*image_xscale
		height=sprite_get_height(sprite_index)*image_yscale
		
		//get hover
		isSelected=__ui_check_hover(x,y,x+width,y+height)
		if __ui_check_clicked(isSelected) onClick()
		
		image_index=subimg
		image_blend=blend
		image_alpha=alpha
		
		//added functions
		loop_through_function_list(updateFunctions)
		
		//apply changes
		if isSelected
		{
			//change based on hover
			if doSubimgChange
			{
				image_index=subimgChangeSubimg
			}
			if doBlendChange
			{
				image_blend=blendChangeColor
				image_alpha=blendChangeAlpha
			}
		}
		
	}
	
	onClick=function()
	{
		//set this method to something useful post-create
	}
	
	draw=function()
	{
		//pre draw
		loop_through_function_list(preDrawFunctions)
		
		draw_sprite_ext(sprite_index,image_index,x,y,image_xscale,image_yscale,image_angle,image_blend,image_alpha)
		
		//post draw
		loop_through_function_list(postDrawFunctions)
		
		//overlay
		if doOverlayChange && isSelected
		{
			draw_set_alpha(overlayChangeAlpha)
			draw_set_color(overlayChangeColor)
			
			draw_rectangle(x,y,x+width,y+height,false)
			
			draw_set_alpha(1)
			draw_set_color(1)
		}
	}
	
	#endregion
}

//OPTIONS BOX

//UI BAR

//CHECKBOX