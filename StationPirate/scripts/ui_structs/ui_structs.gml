function __ui_check_hover()
{
	if point_in_rectangle(mouse_x,mouse_y,shape.__left,shape.__top,shape.__right,shape.__bottom) return true
	return false
}

function __ui_check_clicked(_hover)
{
	if _hover && mouse_check_button_pressed(mb_left) return true
	return false
}

function clickable_box(_x1,_y1,_x2,_y2,_text) constructor
{
	//init structs
	shape=new CleanRectangle(_x1,_y1,_x2,_y2)
	text=new scribble(_text)
	
	#region MODIFYING FUNCTIONS
	//SHAPE BLEND
	addBlend=function(_blend,_hoverblend)
	{
		ChangeBlend=true
		doBlend=true
		OriginalBlendColor=_blend
		ChangeBlendColor=_hoverblend
	}
	removeBlend=function()
	{
		doBlend=false
		ChangeBlend=false
	}
	
	//BORDER BLEND
	addBorder=function(_thickness,_hover_thickness,_blend,_hover_blend)
	{
		ChangeBorder=true
		doBorder=true
		OriginalBorderThickness=_thickness
		ChangeBorderThickness=_hover_thickness
		OriginalBorderColor=_blend
		ChangeBorderColor=_hover_blend
	}
	removeBorder=function()
	{
		ChangeBorder=false
		doBorder=false
	}
	
	//TEXT
	formatText=function(_font,_color,_scale,_padding)
	{
		text.starting_format(_font,_color)
		text.transform(_scale,_scale,0)
		text.padding=_padding
	}
	
	#endregion
	
	#region DEFAULT VARIABLES
	//////////////////////////////
	//shape
	//format
	doBlend=true
	doBorder=true
	shape.Rounding(16)
	
	//border
	shape.ChangeBorder=false
	shape.ChangeBorderColor=c_white
	shape.ChangeBorderThickness=16
	shape.OriginalBorderColor=c_white
	shape.OriginalBorderThickness=16
	
	shape.Border(shape.OriginalBorderThickness,shape.OriginalBorderColor,1)
	
	//blend
	shape.ChangeBlend=false
	shape.OriginalBlendColor=c_white
	shape.ChangeBlendColor=c_white
	
	text.Blend(OriginalBlendColor,1)
	
	//////////////////////////////
	//text
	//format	
	text.starting_format(arial,c_white)
	text.transform(1,1,0)
	
	//positioning
	text.padding=8
	text.origin((_x1+((_x1-_x2)*0.5)),(_y1+((_y1-_y2)*0.5)))
	text.wrap((_x1-_x2)-text.padding*2,(_y1-_y2)-text.padding*2,false)
	text.align(fa_center,fa_middle)
	#endregion
	
	#region STEP FUNCTIONS
	update=function()
	{
		var hover=__ui_check_hover()
		
		shape.Border(shape.OriginalBorderThickness,shape.OriginalBorderColor,1)
		shape.Blend(shape.OriginalBlendColor,1)
		
		if hover
		{
			//border
			if shape.ChangeBorder shape.Border(shape.ChangeBorderThickness,shape.ChangeBorderColor,1)
			
			//blend
			if shape.ChangeBlend shape.Blend(shape.ChangeBlendColor,1)
		}
		
		//click
		if __ui_check_clicked(hover) onClick()
		
		//if don't do blend or border
		if !doBlend shape.Blend(c_white,0)
		if !doBorder shape.Border(1,c_white,0)
	}
	onClick=function()
	{
		
	}
	draw=function()
	{
		shape.Draw()
		text.Draw()
	}
	#endregion
}