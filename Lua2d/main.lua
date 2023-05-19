
WINDOW_WIDTH = love.graphics.getWidth();
WINDOW_HEIGHT = love.graphics.getHeight();

Enumerate = require("Modules/enumerate");

Print = print;
Type = type;

table_to_string = require("Functions/table_to_string");
type = require("Functions/type");

print = function(...)
    for _,Data in pairs({...}) do 
        if type(Data) == "table" then 
            Print(table_to_string(Data));
        else 
            Print(Data);
        end
    end
end;

task = require("Modules/task");
thread = task.new;

TYPES = require("Modules/types");
Vector2 = TYPES.Vector2;
Color3 = TYPES.Color3;
UDim = TYPES.UDim;
UDim2 = TYPES.UDim2;

connections = require("Modules/connection");

createConnection = connections.createConnection;
getConnection = connections.getConnection;
waitForConnection = connections.waitForConnection;

Instance = require("Modules/instance");

Tween = require("Modules/tween");
TweenInfo = Tween.TweenInfo;

game = Instance.new("Folder");
game.Name = "game";
workspace = Instance.new("Folder");
workspace.Name = "workspace"
ui_service = Instance.new("UI");
ui_service.Parent = game;
ui_service.Name = "ui_service"
ui_service.ScaleType = Enumerate.ScaleType.Global;
ui_service.ZIndex = 0;
ui_service.Size = UDim2.new(1,0,1,0);
ui_service.Position = UDim2.new(0,0,0,0);

workspace.Parent = game;

STUDIO_UI = require("Modules/studio_ui");

UI_Drawing = require("Modules/ui_drawing");

Mouse = require("Modules/mouse");

love.graphics.setBackgroundColor(1,1,1);

function love.draw()
    for _,ZIndex in pairs(Instance.getDrawOrder()) do 
        for _,l__Instance in ipairs(ZIndex) do 
            if l__Instance.Class == "UI" then -- need to add zindex 
                if l__Instance.__Attributes.Enabled and l__Instance.__Attributes.Visible then 
                    UI_Drawing[l__Instance.Type](l__Instance);
                end
            end
        end
    end
end

function love.mousemoved(X,Y)
    Mouse.Position = Vector2.new(X,Y);
    for _,UIObject in pairs(ui_service:GetChildren()) do 
        if UIObject.Visible and UIObject.Enabled then
            local Position = UIObject.AbsolutePosition;
            local Size = UIObject.AbsoluteSize;
            local Boundary = (X >= Position.X and X <= Position.X+Size.X) and (Y >= Position.Y and Y <= Position.Y+Size.Y);
            if Boundary and Mouse.Hit ~= UIObject and UIObject.ZIndex >= Mouse.Hit.ZIndex then 
                Mouse.Hit.MouseLeave:Fire();
                Mouse.Hit = UIObject;
                UIObject.MouseEnter:Fire();
                break;
            elseif Mouse.Hit == UIObject and not Boundary then 
                Mouse.Hit = ui_service;
                UIObject.MouseLeave:Fire();
            end
        end
    end
    Mouse.Moved:Fire();
end

function love.mousepressed(X,Y,Button)
    if Button == 1 then 
        if Mouse.Hit.Type == "Button" then 
            Mouse.Hit.Button1Down:Fire();
        end
        Mouse.Button1Down:Fire();
        Mouse.Button1Pressed:Fire();
    elseif Button == 2 then 
        if Mouse.Hit.Type == "Button" then 
            Mouse.Hit.Button2Down:Fire();
        end
        Mouse.Button2Down:Fire();
        Mouse.Button2Pressed:Fire();
    end
end

function love.mousereleased(X,Y,Button)
    if Button == 1 then 
        if Mouse.Hit.Type == "Button" then 
            Mouse.Hit.Button1Up:Fire();
        end
        Mouse.Button1Up:Fire();
    elseif Button == 2 then 
        if Mouse.Hit.Type == "Button" then 
            Mouse.Hit.Button2Up:Fire();
        end
        Mouse.Button2Up:Fire();
    end
end

function love.wheelmoved(x, y)
    if y > 0 then
        Mouse.ScrollPosition = math.max(Mouse.ScrollPosition-1,0);
        Mouse.ScrollForward:Fire();
    elseif y < 0 then
        Mouse.ScrollPosition = math.min(Mouse.ScrollPosition+1,15); -- Mouse max scroll out is 15
        Mouse.ScrollBackward:Fire();
    end
end

function love.resize(Width, Height)
   WINDOW_WIDTH = Width;
   WINDOW_HEIGHT = Height;
   ui_service.AbsoluteSize = Vector2.new(WINDOW_WIDTH,WINDOW_HEIGHT);
   for _,UIObject in pairs(ui_service:GetChildren()) do
        UIObject.Changed:Fire("Position");
        UIObject.Changed:Fire("Size");
   end
end

function love.update(DeltaTime)
    task.Update();
end
