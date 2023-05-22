
local Position_Offset = 0;
local Navigation = {};

local Explorer__Content = game.UIService.Explorer.Content;
local Properties__Content = game.UIService.Properties.Content;
local Explorer__Object = Instance.new("UI");
Explorer__Object.Name = "Explorer__Object";
Explorer__Object.Size = UDim2.new(1,0,0,20);
Explorer__Object.Enabled = false;
Explorer__Object.ZIndex = 2;
Explorer__Object.BackgroundOpacity = 0;

local Explorer__Label = Instance.new("TextButton");
Explorer__Label.Parent = Explorer__Object;
Explorer__Label.Name = "Label";
Explorer__Label.Size = UDim2.new(1,-25,0,20);
Explorer__Label.Position = UDim2.new(0,25,0,0);
Explorer__Label.Text = "Label";
Explorer__Label.BackgroundOpacity = 0.5;
Explorer__Label.ZIndex = 3;

local Explorer__Expand = Instance.new("TextButton");
Explorer__Expand.Parent = Explorer__Object;
Explorer__Expand.Name = "Expand";
Explorer__Expand.Size = UDim2.new(0,20,0,20);
Explorer__Expand.Position = UDim2.new(0,5,0,0);
Explorer__Expand.Text = "+";
Explorer__Expand.BackgroundOpacity = 0.5;
Explorer__Expand.ZIndex = 3;

local Properties__Object = Instance.new("UI");
Properties__Object.Name = "Properties__Object";
Properties__Object.Size = UDim2.new(1,0,0,30);
Properties__Object.Enabled = true;
Properties__Object.BackgroundOpacity = 0.5;
Properties__Object.ZIndex = 4;

local Properties__Label = Instance.new("TextBox");
Properties__Label.Parent = Properties__Object;
Properties__Label.Name = "Property_Name";
Properties__Label.Size = UDim2.new(0.4,0,0,30);
Properties__Label.Position = UDim2.new(0,0,0,0);
Properties__Label.Text = "Property_Name";
Properties__Label.BackgroundOpacity = 0;
Properties__Label.ZIndex = 5;

local Properties__Value = Instance.new("TextBox");
Properties__Value.Parent = Properties__Object;
Properties__Value.Name = "Property_Value";
Properties__Value.Size = UDim2.new(0.6,-5,0,30);
Properties__Value.Position = UDim2.new(0.4,5,0,0);
Properties__Value.Text = "Property_Value";
Properties__Value.BackgroundOpacity = 0;
Properties__Value.ZIndex = 5;



local function RemoveObject(_,Object)
    for _,Obj in ipairs(Navigation) do 
        if Obj.Instance == Object then 
            if Obj.Expanded then 
                local Index = 0;
                while Index < Obj.End do
                    Index = Index + 1;
                    if Navigation[_+1] then 
                        RemoveObject({},Navigation[_+1].Instance);
                    else 
                        break;
                    end
                end
                for Index=_+1,#Navigation do
                    Navigation[Index].Label.Position = Navigation[Index].Label.Position - Obj.ExpandOffset;
                end
            end
            Properties__Content.CanvasSize = Properties__Content.CanvasSize - Vector2.new(0,32);
            Obj.Label:Destroy();
            table.remove(Navigation,_);
        end
    end 
end

local LastPressed = nil;
local function AddObject(_,Object,Object_Offset,Indent)
    local text = Explorer__Object:Clone();
    text.Name = Object.Name;
    text.Parent = Explorer__Content;
    text.ZIndex = 6;
    text.Position = UDim2.new(0,Indent,0,Object_Offset*22);
    text.Label.Text = Object.Name;

    local add__Child__Event = Object.ChildAdded:Connect(function(self,Child)
        local local__Object;
        local local__Object__Index = 0;
        for _,Obj in pairs(Navigation) do 
            if Obj.Instance == Object then 
                local__Object = Obj;
                local__Object__Index = _;
            end
        end 
        if not local__Object then self:Disconnect() return end;
        if not local__Object.Expanded then return end;
        AddObject({},Child,local__Object__Index+1,Indent+2.5);
        local__Object.End = local__Object.End + 1;
        local__Object.ExpandOffset = local__Object.ExpandOffset + Vector2.new(0,22);
        for Index=local__Object__Index+2,#Navigation do
            Navigation[Index].Label.Position = Navigation[Index].Label.Position + Vector2.new(0,22);
        end
    end)

    local remove__Child__Event = Object.ChildRemoved:Connect(function(self,Child)
        local local__Object;
        local local__Object__Index = 0;
        for _,Obj in pairs(Navigation) do 
            if Obj.Instance == Child then 
                local__Object__Index = _;
            elseif Obj.Instance == Object then 
                local__Object = Obj;
            end
        end   
        if not local__Object then self:Disconnect() return end;
        local__Object.ExpandOffset = local__Object.ExpandOffset - Vector2.new(0,22);
        local__Object.End = local__Object.End - 1;
        if local__Object.Expanded then
            for Index=local__Object__Index+1,#Navigation do
                Navigation[Index].Label.Position = Navigation[Index].Label.Position - Vector2.new(0,22);
            end
        end
        RemoveObject({},Child);
    end)

    local LastPressed__Thread;

    text.Destroying:Once(function()
        remove__Child__Event:Disconnect();
        if LastPressed == text.Label then 
            LastPressed__Thread:Close();
            Properties__Content:ClearChildren();
            LastPressed = nil;
        end 
        add__Child__Event:Disconnect();
        
    end)

    Object.Destroying:Once(function()
        if LastPressed == text.Label then 
            LastPressed__Thread:Close();
            Properties__Content:ClearChildren();
            LastPressed = nil;
        end 
    end)

    local function local__update__properties()
        if LastPressed then 
            Tween:Create(LastPressed,TweenInfo.new(0.2,Enumerate.EasingStyle.Sine),{TextColor3=Color3.new(0,0,0)}):Play();
            if LastPressed == text.Label then 
                Properties__Content:ClearChildren();
                LastPressed = nil;
                return;
            end 
        end 
        Tween:Create(text.Label,TweenInfo.new(0.2,Enumerate.EasingStyle.Sine),{TextColor3=Color3.new(0,1,0)}):Play();
        LastPressed = text.Label

        LastPressed__Thread = thread(function(Thread)
            while LastPressed == text.Label do 
                Object.Changed:Wait(Thread);
                for _,Property in pairs(Properties__Content:GetChildren()) do 
                    if Property:FindFirstChild("Property_Name") then 
                        Property.Property_Value.Text = tostring(Object[Property.Property_Name.Text]);
                    end
                end 
            end 
            Thread:Close();
        end);
        LastPressed__Thread:Play();

        Properties__Content:ClearChildren();
        Properties__Content.CanvasSize = UDim2.new(1,0,0,0);

        local Position_Index = 0;
        for _,Property in pairs(Object.__Attributes) do 
            local Property__UI = Properties__Object:Clone();
            Property__UI.Parent = Properties__Content;
            Property__UI.Position = UDim2.new(0,5,0,Position_Index*32);
            Property__UI.Property_Name.Text = _;
            Property__UI.Property_Value.Text = tostring(Property);
            Position_Index = Position_Index + 1;
        end 
        Properties__Content.CanvasSize = Properties__Content.CanvasSize + Vector2.new(0,(Position_Index+1)*32);
    end

    text.Label.Button1Up:Connect(local__update__properties);
    text.Expand.Button1Up:Connect(function(self)
        local local__Object;
        local local__Object__Index = 0;
        for _,Obj in pairs(Navigation) do 
            if Obj.Instance == Object then 
                local__Object = Obj;
                local__Object__Index = _;
            end
        end 
        if local__Object.Expanded then 
            local Index = 0;
            while Index < local__Object.End do
                Index = Index + 1;
                if Navigation[local__Object__Index+1] then 
                    RemoveObject({},Navigation[local__Object__Index+1].Instance);
                else 
                    break;
                end
            end
            for Index=local__Object__Index+1,#Navigation do
                Navigation[Index].Label.Position = Navigation[Index].Label.Position - local__Object.ExpandOffset;
            end
            text.Expand.Text = "+";
        else
            local local__Position__Offset = local__Object__Index;
            local Start = #Navigation;
            for _,Child in pairs(Object:GetChildren()) do 
                local__Position__Offset = local__Position__Offset + 1;
                AddObject({},Child,local__Position__Offset,Indent+2.5);
            end
            if #Navigation <= Start then return end;
            local Difference = (local__Position__Offset-local__Object__Index);
            text.Expand.Text = "-";
            local__Object.End = Difference;
            local__Object.ExpandOffset = Vector2.new(0,Difference*22)
            for Index=local__Position__Offset+1,#Navigation do
                Navigation[Index].Label.Position = Navigation[Index].Label.Position + local__Object.ExpandOffset;
            end
        end
        local__Object.Expanded = not local__Object.Expanded;
    end)

    Explorer__Content.CanvasSize = Explorer__Content.CanvasSize + Vector2.new(0,22);

    table.insert(Navigation,Object_Offset,{Instance=Object,Expanded = false,ExpandOffset = Vector2.new(0,0),Label = text,Children={},End=0});
    return Navigation[#Navigation];
end

for _,Child in pairs(game:GetChildren()) do 
    AddObject({},Child,Position_Offset,0);
    Position_Offset = Position_Offset + 1;
end

game.ChildAdded:Connect(AddObject)
game.ChildRemoved:Connect(RemoveObject)

return Navigation;