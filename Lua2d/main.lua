
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

STUDIO_UI = require("Modules/studio_ui");

UI_Drawing = require("Modules/ui_drawing");

local MyObject = Instance.new("Part");
local a = MyObject.Position;
local b = MyObject.Size;
local c = Vector2.new(100,100);
Tween:Create(MyObject,TweenInfo.new(5,Enumerate.EasingStyle.Sine),{Position=c}):Play();
Tween:Create(MyObject,TweenInfo.new(5,Enumerate.EasingStyle.Sine),{Size=c}):Play();


love.graphics.setBackgroundColor(0,0,0);
function love.draw()
    for _,l__Instance in pairs(Instance.getInstances()) do 
        if l__Instance.Class == "UI" then -- need to add zindex 
            if l__Instance.Enabled and l__Instance.Visible then 
                UI_Drawing[l__Instance.Type](l__Instance);
            end
        end
    end
    love.graphics.print("Position: " .. tostring(MyObject.Position) .. "\nOrigin:    " .. tostring(a),10,10);
    love.graphics.print("Size:       " .. tostring(MyObject.Size) .. "\nOrigin:    " .. tostring(b),10,50);
end

function love.update(DeltaTime)
    task.Update();
end
