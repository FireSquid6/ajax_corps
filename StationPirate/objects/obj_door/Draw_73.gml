if global.debugMode
{
    var str
    switch state
    {
        case doorStates.closed:
            str="closed"
            break
        case doorStates.open:
            str="open"
            break
        case doorStates.closing:
            str="closing"
            break
        case doorStates.opening:
            str="opening"
            break
    }
    draw_text(x,y-32,string(str))
}