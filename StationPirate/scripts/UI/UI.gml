function clickable_box(_x1,_y1,_x2,_y2,_text) constructor
{
	//init structs
	shape=new CleanRectangle(_x1,_y1,_x2,_y2)
	text=new scribble(_text)
	
	//shape
	shape.Rounding(16)
	shape.Border(16,c_white,1)
	
	//text
	text.Blend(c_white,1)
	text.starting_format(arial,c_white)
	
	update=function()
	{
		
	}
	onClick=function()
	{
		
	}
	draw=function()
	{
		shape.Draw()
		text.Draw()
	}
}