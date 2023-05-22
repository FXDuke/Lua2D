local Instances = {};
local Instance__INDEX = 0;

local DrawOrder = {};

local function Update_Draw_Order()
    DrawOrder = {};
    for _,UIObject in pairs(ui_service:GetChildren()) do 
        local ZIndex = UIObject.ZIndex;
        DrawOrder[ZIndex] = DrawOrder[ZIndex] or {};
        table.insert(DrawOrder[ZIndex],UIObject);
    end
end

local function Loop__Ancestory__Event(Object,Event,Value)
    Object[Event]:Fire(Value);
    if Object.Parent then 
        Loop__Ancestory__Event(Object.Parent,Event,Value);
    end
end

local Trees = {
    ["Part"] = "WorldObject",
    ["TextBox"] = "UI",
    ["UI"] = "UI",
    ["Object"] = "Object",
    ["Folder"] = "Object",
    ["Button"] = "UI",
    ["ScrollingBox"] = "UI",
    ["TextButton"] = "UI",
};

function __DebugGetSelf(Object)
    return Instances[Object.ID];
end

local class__Instance = {};
class__Instance.__index = class__Instance;


function class__Instance:FindFirstChild(Name)
    for _,Child in pairs(self.__Children) do 
        if Child.Name == Name then 
            return Child;
        end
    end
    return nil;
end

function class__Instance:WaitForChild(Name)
    local Child = self:FindFirstChild(Name);
    if (Child == nil) then 
        local Yield_Limit = os.clock()+10;
        thread(function(Thread)
            repeat
                self.ChildAdded:Wait(Thread);
                local Child = self:FindFirstChild(Name);
                if Child then 
                    return Child;
                end;
            until os.clock > Yield_Limit;
            error(self.Name,"Possible infinite yield waiting for child " .. Name); 
        end):Play();
    else 
        return Child;
    end
end

function class__Instance:FindFirstAncestor(Name)
    if self.Parent then 
        if self.Parent.Name == Name then
            return self.Parent;
        else
            return self.Parent:FindFirstAncestor(Name);
        end
    else 
        return nil; 
    end
end

function class__Instance:GetChildren()
    return self.__Children;
end

function class__Instance:GetDescendants()
    local Descendants = {};

    local function Loop_Children(Object)
        for _,Child in pairs(Object:GetChildren()) do
            table.insert(Descendants,Child);
            Loop_Children(Child);
        end
    end

    Loop_Children(self);
    return Descendants;
end

function class__Instance:Destroy()
    Tween:Create(self,TweenInfo.new(0,Enumerate.EasingStyle.Sine),{}):Play();
    self.Destroying:Fire();
    for _,Child in pairs(self.__Children) do 
        Child:Destroy();
    end
    if self.Parent then 
        if self.Class == "UI" and Mouse.Hit == self then 
            Mouse.Hit = ui_service;
        end 
        self.Parent.ChildRemoved:Fire(self);
        Loop__Ancestory__Event(self.Parent,"DescendantRemoved",self);
        rawset(self.Parent.__Children,self.__Proxy.ProxyID,nil);
    end 
    rawset(Instances, self.ID, nil);
    self = nil;
    Update_Draw_Order()
end

function class__Instance:FindFirstChildOfType(Type)
    for _,Object in pairs(self:GetChildren()) do 
        if Object.Type == Type then 
            return Object;
        end 
    end
    return nil;
end

function class__Instance:FindFirstAncestorOfType(Type)
    if self.Parent then 
        if self.Parent.Type == Type then 
            return self.Parent;
        else
            return self.Parent:FindFirstAncestorOfType(Type);
        end 
    end
    return nil;
end

function class__Instance:FindFirstDescendantOfType(Type)
    for _,Object in pairs(self:GetDescendants()) do 
        if Object.Type == Type then 
            return Object;
        end
    end 
    return nil;
end

function class__Instance:Clone()
    local main__Object = Instance.new(self.Type);
    for _,Attribute in pairs(Instances[self.ID].__Attributes) do
        main__Object[_] = Attribute; 
    end 
    
    local function Loop_Through_Children(Child,Parent)
        local Children = Child:GetChildren();
        if Children then 
            for _,loop__Child in pairs(Children) do 
                local cloned__Object = loop__Child:Clone();
                cloned__Object.Parent = Parent;
                Loop_Through_Children(loop__Child,cloned__Object);
            end
        end
    end
    Loop_Through_Children(Instances[self.ID],main__Object)

    return main__Object;
end

function class__Instance:ClearChildren()
    for _,Child in pairs(self:GetChildren()) do 
        Child:Destroy();
    end
end

local Instance = {
    Update_Draw_Order = Update_Draw_Order,
    getInstances = function()
        return Instances;
    end,
    getDrawOrder = function()
        return DrawOrder;
    end,
    new = function(Type)

        Instance__INDEX = Instance__INDEX + 1;

        -- Applying Root Class

        Type = Type or "Folder";
        local Branch = Trees[Type];

        local ID = Instance__INDEX;
        Instances[ID] = setmetatable({
            Type = Type,
            Class = Branch,
            ID = ID,
            Parent = nil,
            __Children = {},
            __Attributes = {
            },
            __Events = {
                ChildAdded = createConnection(),
                ChildRemoved = createConnection(),
                DescendantAdded = createConnection(),
                DescendantRemoved = createConnection(),
                Destroying = createConnection(),
                Changed = createConnection(),
            },
        },class__Instance);
        Instances[ID].__index = Instances[ID];

        -- Applying Class
        local local__object = Instances[ID];
        local object__Attr = Instances[ID].__Attributes;
        local object__Evnt = Instances[ID].__Events;
        local object__Chil = Instances[ID].__Children;
        object__Attr.Class = Branch;
        object__Attr.Name = Type;

        if Branch == "WorldObject" then 

            -- Attributes 

            object__Attr.Position = Vector2.new(0,0);
            object__Attr.Size = Vector2.new(50,20);
            object__Attr.Color3 = Color3.new(255,255,255);
            object__Attr.Opacity = 1;

        elseif Branch == "UI" then

            -- Attributes

            object__Attr.Position = UDim2.new(0,0,0,0); 
            object__Attr.Size = UDim2.new(0,50,0,50);
            object__Attr.AbsolutePosition = Vector2.new(0,0);
            object__Attr.AbsoluteSize = Vector2.new(50,50); 
            object__Attr.ZIndexBehavior = Enumerate.ZIndexBehavior.Sibling;
            object__Attr.Enabled = true;
            object__Attr.Visible = true;
            object__Attr.ClipsDescendants = false;
            object__Attr.BackgroundColor3 = Color3.new(255,255,255);
            object__Attr.BackgroundOpacity = 1;
            object__Attr.ZIndex = 1;
            object__Attr.ScaleType = Enumerate.ScaleType.Sibling;

            -- Events

            object__Evnt.MouseEnter = createConnection();
            object__Evnt.MouseLeave = createConnection();
            object__Evnt.Changed:Connect(function(self, Index)
                if (Index == "Position") and local__object.Parent then
                    local Position = object__Attr.Position;
                    local X = (object__Attr.ScaleType == Enumerate.ScaleType.Global) and WINDOW_WIDTH*Position.X.Scale or local__object.Parent.AbsolutePosition.X+local__object.Parent.AbsoluteSize.X*Position.X.Scale;
                    local Y = (object__Attr.ScaleType == Enumerate.ScaleType.Global) and WINDOW_HEIGHT*Position.Y.Scale or local__object.Parent.AbsolutePosition.Y+local__object.Parent.AbsoluteSize.Y*Position.Y.Scale;
                    object__Attr.AbsolutePosition = Vector2.new(Position.X.Offset+X, Position.Y.Offset+Y);
                    for _,Child in pairs(object__Chil) do 
                        Child.Changed:Fire("Position");
                    end
                elseif (Index == "Size") and local__object.Parent then 
                    local Size = object__Attr.Size;
                    local X = (object__Attr.ScaleType == Enumerate.ScaleType.Global) and WINDOW_WIDTH or local__object.Parent.AbsoluteSize.X;
                    local Y = (object__Attr.ScaleType == Enumerate.ScaleType.Global) and WINDOW_HEIGHT or local__object.Parent.AbsoluteSize.Y;
                    object__Attr.AbsoluteSize = Vector2.new(Size.X.Offset+X*Size.X.Scale,Size.Y.Offset+Y*Size.Y.Scale);
                    for _,Child in pairs(object__Chil) do 
                        Child.Changed:Fire("Size");
                    end
                elseif (Index == "CanvasSize") then 
                    local Size = object__Attr.CanvasSize;
                    local X = (object__Attr.ScaleType == Enumerate.ScaleType.Global) and WINDOW_WIDTH or local__object.Parent.AbsoluteSize.X;
                    local Y = (object__Attr.ScaleType == Enumerate.ScaleType.Global) and WINDOW_HEIGHT or local__object.Parent.AbsoluteSize.Y;
                    object__Attr.AbsoluteCanvasSize = Vector2.new(Size.X.Offset+X*Size.X.Scale,Size.Y.Offset+Y*Size.Y.Scale);
                    for _,Child in pairs(object__Chil) do 
                        Child.Changed:Fire("Size");
                    end
                elseif (Index == "ZIndex") then
                    Update_Draw_Order()
                end
            end)

            -- Branch Attributes / Events 

            if Type == "TextBox" or Type == "TextButton" then 
                object__Attr.Text = "Textbox";
                object__Attr.TextOpacity = 1;
                object__Attr.TextScaled = true; -- need to add behavior for false
                object__Attr.TextColor3 = Color3.new(0,0,0);
                object__Attr.FontSize = 14; -- Need to add font size to ui_drawing
            end
            if Type == "Button" or Type == "TextButton" then 
                object__Evnt.Button1Down = createConnection();
                object__Evnt.Button2Down = createConnection();
                object__Evnt.Button1Up = createConnection();
                object__Evnt.Button2Up = createConnection();
            end
            if Type == "ScrollingBox" then 
                object__Attr.CanvasSize = UDim2.new(0,500,0,300);
                object__Attr.CanvasPosition = Vector2.new(0,0);
                object__Attr.AbsoluteCanvasSize = Vector2.new(500,300);
                object__Attr.ClipsDescendants = true;
            end

        end 

        -- Creating Proxy

        Instances[ID].__Proxy = setmetatable({
            ProxyID = tostring(Instances[ID]);
        },{
            __index = function(self,Index)
                if Instances[ID] then
                    if object__Attr[Index] then -- returns the attribute with the index passed
                        return object__Attr[Index];
                    elseif object__Evnt[Index] then -- returns the event with the index passed
                        return object__Evnt[Index];
                    elseif Instances[ID]:FindFirstChild(Index) then -- returns the child with the index passed (if a child is found)
                        return Instances[ID]:FindFirstChild(Index);
                    else
                        return Instances[ID].__index[Index];
                    end
                else
                    return nil;
                end 
            end,
            __newindex = function(self,Index,Value)
                if Index == "Parent" then 
                    if object__Attr.Parent then 
                        local Proxy = setmetatable({ID=self.ID,ProxyID=self.ProxyID},self);
                        -- Creates a clone of the proxy so the current one's memory can be cleared
                        local__object.ChildRemoved:Fire(Proxy);
                        Loop__Ancestory__Event(Value,"DescendantRemoved",Proxy);

                        rawset(local__object.Parent.__Children,self.ProxyID,nil);
                        -- Rawset allocates the memory directly
                        self = Proxy;
                    end
                    if Value.Class then 
                        local__object.Parent = Value;
                        Value.__Children[self.ProxyID] = self;
                        Value.ChildAdded:Fire(self);
                        Loop__Ancestory__Event(Value,"DescendantAdded",self);
                        object__Evnt.Changed:Fire("Position");
                        object__Evnt.Changed:Fire("Size");
                        -- Updates the Object's Size and Position to become relative to the new parent
                    else
                        error("Parent must be an instance");
                    end
                elseif Index == "__Children" then 
                    if Value.Class then 
                        local__object.__Children[Index] = Value;
                    else
                        error("Unable to add " .. type(Value) .. " to children")
                    end
                elseif object__Attr[Index] ~= nil then 
                    -- If the attribute exists, it changes the value.
                    -- This prevents new values from being added to the main object 
                    -- but allows already present values to be changed.
                    object__Attr[Index] = Value;
                    self.Changed:Fire(Index);
                elseif object__Evnt[Index] then
                    error("Cannot set value of event");
                end
                rawset(self,Index,nil);
                -- directly clears the index from the proxy table
            end,
            __tostring = function(self)
                return self.Name;
            end;
            __call = function(self,...)
                return Instances[self.ID];
            end
        });

        return Instances[ID].__Proxy;
    end,
};

return Instance;