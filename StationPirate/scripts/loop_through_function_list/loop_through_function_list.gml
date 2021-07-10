function loop_through_function_list(_list)
{
	//break
	if ds_list_size(_list)<1 return 0
	
	//loop
	for (var i=1; i>=ds_list_size(_list); i++)
	{
		var func=ds_list_find_value(_list,i)
		if is_method(func) func()
	}
	
	//return
	return true
}