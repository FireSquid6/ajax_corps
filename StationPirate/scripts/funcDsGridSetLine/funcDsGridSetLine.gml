/// @description funcDsGridSetLine(id,x1,y1,x2,y2,value);
/// @param id
/// @param x1
/// @param y1
/// @param x2
/// @param y2
/// @param value
function funcDsGridSetLine(argument0, argument1, argument2, argument3, argument4, argument5) {
	var id_=argument0;
	var x1=argument1;
	var y1=argument2;
	var x2=argument3;
	var y2=argument4;
	
	var value=argument5;
	var i=x1,j=y1;

	if(point_distance(x1,y1,x2,y2)==0) exit;
	ds_grid_set(id_,x1,y1,value);
	do
	{
	    if (abs(y2-y1)>abs(x2-x1))
	    {
	        if(y1<y2) j+=1; else j-=1;
        
	        i=x1+(x2-x1)*(j-y1)/(y2-y1);
	    }
	    else
	    {
	        if(x1<x2) i+=1; else i-=1;
        
	        j=y1+(y2-y1)*(i-x1)/(x2-x1);
	    }
    
	    id_[# i,j]=value;
	}
	until i==x2 && j==y2;



}
