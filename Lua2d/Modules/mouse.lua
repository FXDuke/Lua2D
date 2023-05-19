

local Mouse = {
    Hit = ui_service;
    WorldPosition = Vector2.new(0,0);
    Position = Vector2.new(0,0);
    ScrollPosition = 5;
    Button1Pressed = createConnection();
    Button2Pressed = createConnection();
    Button1Up = createConnection();
    Button2Up = createConnection();
    Button1Down = createConnection();
    Button2Down = createConnection();
    ScrollForward = createConnection();
    ScrollBackward = createConnection();
    Moved = createConnection();
};

return Mouse;