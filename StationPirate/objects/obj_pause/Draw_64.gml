//ask gabrielle to do a pause screen background of the lab
if state==pauseStates.home
{
    var gui_height=display_get_gui_height();
    var gui_width=display_get_gui_width();
    
    //draw box
    draw_sprite_ext(spr_pixel,1,0,0,gui_width,gui_height,0,c_black,1);
    
    //draw pause text
    draw_set_color(c_white);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_font(fnt_pause_title);
    
    draw_text(gui_width*0.5,25,"GAME PAUSED");
    
    //vars
    var roundrect_radius=16
    var padding=16
    var num_options=6
    
    //draw box
    var xx=gui_width*0.1
    var yy=gui_height*0.1
    var boxWidth=gui_width*0.2
    var boxHeight=gui_height*0.8
    draw_set_color(c_dkgray)
    draw_set_alpha(1)
    draw_roundrect_ext(xx,yy,xx+boxWidth,yy+boxHeight,roundrect_radius,roundrect_radius,false)
    
    //draw option boxes
    xx+=padding
    yy+=padding
    boxWidth-=padding
    boxHeight=boxHeight/(num_options+(padding*num_options))
    
    draw_set_color(c_white)
    
    repeat num_options
    {
        
        draw_roundrect_ext(xx,yy,xx+boxWidth,yy+boxHeight,roundrect_radius,roundrect_radius,true)
        yy+=boxHeight+padding
    }
    
}