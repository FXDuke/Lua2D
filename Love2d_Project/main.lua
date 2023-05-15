Enumerate = {
    EasingStyle = {
        Linear = 0,
        Sine = 1,
    },
    EasingDirection = {
        In = 0,
        Out = 1,
        InOut = 2,
    },
    PlaybackState = {
        Normal = 0,
        Playing = 1,
        Paused = 2,
        Completed = 3,
    };
};

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

connections = require("Modules/connection");

createConnection = connections.createConnection;
getConnection = connections.getConnection;
waitForConnection = connections.waitForConnection;

Instance = require("Modules/instance");

Tween = require("Modules/tween");
TweenInfo = Tween.TweenInfo;

local Holder = Instance.new("Folder");
Holder.Name = "Object__Holder";

local l__Object = Instance.new("Object");
l__Object.Name = "MyObject";
l__Object.Parent = Holder;
l__Object.Destroying:Connect(function()
    print(tostring(l__Object) .. " DESTROYED!");
end)

l__Object.Position = Vector2.new(math.random(1,10),math.random(1,10));
local startingPos = l__Object.Position;
local goal = Vector2.new(100,100);

Holder.MyObject.Changed:Connect(function(self,Value)
    if Value == "Position" then 
        if Holder.MyObject.Position == goal then 
            print(tostring(Holder.MyObject) .." Goal reached! " .. tostring(Holder.MyObject.Position));
            print("Distance Moved: " .. tostring((goal-startingPos).Unit*(goal-startingPos).Magnitude) .. "\t(START:" .. tostring(startingPos) .. ")");
            self:Disconnect();
        else
            print(tostring(Holder.MyObject) .. " Moving to goal! " .. tostring(Holder.MyObject.Position))
        end
    end
end)

local MyTween = Tween:Create(Holder.MyObject,TweenInfo.new(2,Enumerate.EasingStyle.Sine),{Position=goal});
MyTween:Play();

thread(function(self)
    local Start = os.clock();
    MyTween.Completed:Wait(self);
    print("tween completed in " .. os.clock()-Start);
end):Play();

while #task.Threads>0 do 
    task.Update();
end

--[[
function love.draw()
    love.graphics.print("hello world",100,100)
end

function love.update(DeltaTime)
    task.Update();
end

]]