WINDOW_WIDTH = love.graphics.getWidth();
WINDOW_HEIGHT = love.graphics.getHeight();

Enumerate = require("Modules/enumerate");

Print = print;
Type = type;

table_to_string = require("Functions/table_to_string");
-- Temporary debug tool used to print out tables and their contents 
type = require("Functions/type");
-- returns the custom type or standard type

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
-- Task scheduler that runs with love.update. 
-- Thread passes self as an argument when resumed which can be used to wait, close, or pause the thread
thread = task.new;

TYPES = require("Modules/types");
-- Module for the types that contains factories and behaviors 
Vector2 = TYPES.Vector2;
Color3 = TYPES.Color3;
UDim = TYPES.UDim;
UDim2 = TYPES.UDim2;

connections = require("Modules/connection");
-- Creates reusable events that can be binded to or fired from any position in the program

createConnection = connections.createConnection;
-- Creates a connection. If argument 1 (ID) is not specified it is given a numerical value based on the index of connections created
getConnection = connections.getConnection;
-- Returns the connection with the specified ID or nil
waitForConnection = connections.waitForConnection;
-- Waits for a connection with the specified ID

Instance = require("Modules/instance");
-- Module for containing the Instance factories as well as instance behavior

Tween = require("Modules/tween");
-- Uses a dictionary to cast values to the passed object and smoothly animates them to their goals
TweenInfo = Tween.TweenInfo;

game = Instance.new("Folder");
-- Game will be a hub for services and events
game.Name = "game";
workspace = Instance.new("Folder");
-- workspace is the folder that holds all the objects that will be put into the physical world
workspace.Name = "workspace"
workspace.Parent = game;
ui_service = Instance.new("UI");
-- ui_service is a UI Instance that acts as a folder and hold the objects that will be drawn 
ui_service.ScaleType = Enumerate.ScaleType.Global;
ui_service.Parent = game;
ui_service.BackgroundOpacity = 0;
ui_service.Name = "ui_service"
ui_service.ZIndex = 0;
ui_service.Size = UDim2.new(1,0,1,0);
ui_service.Position = UDim2.new(0,0,0,0);

STUDIO_UI = require("Modules/studio_ui");
-- The framework for what will be the UI for explorer and editor the workspace and ui worlds (Values should be locked and only changed by events / methods)
-- Automatically maintains UI Format for standard UI
workplace_ui = STUDIO_UI.ui_workspace;
-- workplace_ui will manage what is drawn in the workspace / game 

UI_Drawing = require("Modules/ui_drawing");
-- Provides functions to draw types of instances under the UI Class

Mouse = require("Modules/mouse");
-- Mouse provides events for mouse behavior, as well as numerical values for mouse attributes
local l__MouseHeld = {
    [1] = {};
    [2] = {};
};
-- Table for instances with a mouse button event fired to ensure they are released when the button is;

love.graphics.setBackgroundColor(1,1,1);
function love.draw()
    for _,ZIndex in pairs(Instance.getDrawOrder()) do 
        -- Draw Order is a table updated every time an instance under the UI Class's ZIndex changes
        for _,l__Instance in ipairs(ZIndex) do 
            if l__Instance.Class == "UI" then
                if l__Instance.__Attributes.Visible then 
                    UI_Drawing[l__Instance.Type](l__Instance);
                end
            end
        end
    end
end

function love.mousemoved(X,Y)
    Mouse.Position = Vector2.new(X,Y);
    for _,UIObject in pairs(ui_service:GetDescendants()) do 
        if UIObject.Visible and UIObject.Enabled then
            local Position = UIObject.AbsolutePosition;
            local Size = UIObject.AbsoluteSize;
            local Boundary = (X >= Position.X and X <= Position.X+Size.X) and (Y >= Position.Y and Y <= Position.Y+Size.Y);
            -- Boundary is a boolean that checks if the mouse is inside of the UI 
            if Boundary and Mouse.Hit ~= UIObject and UIObject.ZIndex >= Mouse.Hit.ZIndex and Mouse.Hit.Enabled then 
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
    if Mouse.Hit.Type == "Button" and Mouse.Hit.Enabled then 
        Mouse.Hit["Button" .. Button .. "Down"]:Fire()
        table.insert(l__MouseHeld[Button],Mouse.Hit);
    end
    if Button == 1 then 
        Mouse.Button1Down:Fire();
        Mouse.Button1Pressed:Fire();
    elseif Button == 2 then 
        Mouse.Button2Down:Fire();
        Mouse.Button2Pressed:Fire();
    end
end

function love.mousereleased(X,Y,Button)
    for _,ButtonItem in pairs(l__MouseHeld[Button]) do 
        ButtonItem["Button" .. Button .. "Up"]:Fire()
    end 
    l__MouseHeld[Button] = {};
    if Button == 1 then 
        Mouse.Button1Up:Fire();
    elseif Button == 2 then 
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

function love.mousefocus(Focus)
    if Focus then
        Mouse.Hit.MouseEnter:Fire();
    else
        Mouse.Hit.MouseLeave:Fire();
    end
end

function love.update(DeltaTime)
    task.Update();
end
