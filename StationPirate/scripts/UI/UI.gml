function clickable_box(_x1,_y1,_x2,_y2,_text) constructor
{
	shape=new CleanRectangle(_x1,_y1,_x2,_y2)
	text=new scribble(_text)
	shape.Rounding(16)
	shape.Border(16,c_white,1)
	
	
	update=function()
	{
		
	}
	onClick=function()
	{
		
	}
	draw=function()
	{
		shape.Draw()
	}
}