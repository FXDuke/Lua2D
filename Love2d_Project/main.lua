
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

local MyText = Instance.new("TextBox");
MyText.Text = "Hello world!";
MyText.Position = UDim2.new(0.5,0,0.5,0);
MyText.Size = UDim2.new(0.2,0,0.2,0);

thread(function(self)
    local BecomeTransparent = Tween:Create(MyText,TweenInfo.new(1,Enumerate.EasingStyle.Sine,Enumerate.EasingDirection.InOut),{Position = UDim2.new(0,0,0,0),BackgroundOpacity=0});
    MyText.Text = "Fading out...";
    BecomeTransparent:Play();
    BecomeTransparent.Completed:Wait(self);
    MyText.Text = "Fading in...";
    local BecomeNonTransparent = Tween:Create(MyText,TweenInfo.new(1,Enumerate.EasingStyle.Sine,Enumerate.EasingDirection.InOut),{Position = UDim2.new(0.5,0,0.5,0),BackgroundOpacity=1});
    BecomeNonTransparent:Play();
    BecomeNonTransparent.Completed:Wait(self);
end):Loop();

love.graphics.setBackgroundColor(0,0,0);
function love.draw()
    for _,l__Instance in pairs(Instance.getInstances()) do 
        if l__Instance.Class == "UI" then
            UI_Drawing[l__Instance.Type](l__Instance);
        end
    end
end

function love.update(DeltaTime)
    task.Update();
end
