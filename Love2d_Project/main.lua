
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

UI_Drawing = require("Modules/ui_drawing");

local myObject = Instance.new("Part")
local myFolder = Instance.new("Folder")
myFolder.Parent = myObject;
myFolder.Name = "Totally_Not_A_Bomb..."

love.graphics.setBackgroundColor(0,0,0);
function love.draw()
    for _,l__Instance in pairs(Instance.getInstances()) do 
        if l__Instance.Class == "UI" then
            UI_Drawing[l__Instance.Type](l__Instance);
        end
    end
    love.graphics.print(table_to_string(myObject.__index),10,10)
    love.graphics.print(table_to_string(myObject["Totally_Not_A_Bomb..."].__index),10,300)
end

function love.update(DeltaTime)
    task.Update();
end
