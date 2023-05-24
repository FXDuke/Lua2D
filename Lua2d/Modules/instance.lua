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

local function cast__object__attributes(Target,Object)
    for Index, Value in pairs(Object.__Attributes) do 
        Target.__Attributes[Index] = Value;
    end 
    for Index, Value in pairs(Object.__Events) do 
        Target.__Events[Index] = createConnection();
    end 
    return setmetatable(Target,Object.__index);
end

local class__Instance = {
    Class = "Object",
    __Attributes = {},
    __Events = {
        ChildAdded = createConnection(),
        ChildRemoved = createConnection(),
        DescendantAdded = createConnection(),
        DescendantRemoved = createConnection(),
        Destroying = createConnection(),
        Changed = createConnection(),
    },
};
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
                self:Wait();
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

    Tween:Close(self);
    -- Closes any active tweens that are open for the object 

    self.Destroying:Fire();
    for _,Child in pairs(self.__Children) do 
        Child:Destroy();
    end

    if self.Parent then 
        if Mouse.Hit == self then 
            Mouse.Hit = ui_service;
        end 
        -- Prevents Mouse.Hit being equal to nil.

        self.Parent.ChildRemoved:Fire(self);
        Loop__Ancestory__Event(self.Parent,"DescendantRemoved",self);
        rawset(self.Parent.__Children,self.__Proxy.ProxyID,nil);

    end 

    rawset(Instances, self.ID, nil);
    self = nil;

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
    -- Creates an empty Object then casts the Object's attributes to it
    
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
    -- Loops through all descendants of Object and creates clones of them

    return main__Object;
end

function class__Instance:ClearChildren()
    for _,Child in pairs(self:GetChildren()) do 
        Child:Destroy();
    end
end

-- WORLD PART 

local class__WorldObject = cast__object__attributes({
    Class = "Object",
    __Attributes = {
        Position = Vector2.new(0,0);
        Size = Vector2.new(50,20);
        Color3 = Color3.new(255,255,255);
        Opacity = 1;
    },
    __Events = {},
},
class__Instance);

-- PART

local class__Part = cast__object__attributes({
    Class = "WorldObject",
    __Attributes = {},
    __Events = {},
},
class__WorldObject);

-- UI

local class__UI = cast__object__attributes({
    Class = "UI",
    __Attributes = {
        Position = UDim2.new(0,0,0,0); 
        Size = UDim2.new(0,50,0,50);
        AbsolutePosition = Vector2.new(0,0);
        AbsoluteSize = Vector2.new(50,50); 
        ZIndexBehavior = Enumerate.ZIndexBehavior.Sibling;
        Enabled = true;
        Visible = true;
        ClipsDescendants = false;
        BackgroundColor3 = Color3.new(255,255,255);
        BackgroundOpacity = 1;
        ZIndex = 1;
        ScaleType = Enumerate.ScaleType.Sibling;
    },
    __Events = {
        MouseEnter = createConnection();
        MouseLeave = createConnection();
    },
},
class__Instance);
class__UI.__index = class__UI;

function class__UI:__Update(Index)
    local local__Parent = self.Parent;
    local object__Attr = self.__Attributes;
    local object__Chil = self.__Children;
    if local__Parent == nil then return end;

    if (Index == "Position") then

        local Position = object__Attr.Position;
        local X = (object__Attr.ScaleType == Enumerate.ScaleType.Global) and WINDOW_WIDTH*Position.X.Scale or local__Parent.AbsolutePosition.X+local__Parent.AbsoluteSize.X*Position.X.Scale;
        local Y = (object__Attr.ScaleType == Enumerate.ScaleType.Global) and WINDOW_HEIGHT*Position.Y.Scale or local__Parent.AbsolutePosition.Y+local__Parent.AbsoluteSize.Y*Position.Y.Scale;

        object__Attr.AbsolutePosition = Vector2.new(Position.X.Offset+X, Position.Y.Offset+Y);

        for _,local__Child in pairs(object__Chil) do 
            local__Child:__Update("Position");
        end

        return;
    elseif (Index == "Size") then 

        local Size = object__Attr.Size;
        local X = (object__Attr.ScaleType == Enumerate.ScaleType.Global) and WINDOW_WIDTH or local__Parent.AbsoluteSize.X;
        local Y = (object__Attr.ScaleType == Enumerate.ScaleType.Global) and WINDOW_HEIGHT or local__Parent.AbsoluteSize.Y;

        object__Attr.AbsoluteSize = Vector2.new(Size.X.Offset+X*Size.X.Scale,Size.Y.Offset+Y*Size.Y.Scale);
        for _,local__Child in pairs(object__Chil) do 
            local__Child:__Update("Size");
        end

        return;
    elseif (Index == "CanvasSize") then 

        local Size = object__Attr.CanvasSize;
        local X = (object__Attr.ScaleType == Enumerate.ScaleType.Global) and WINDOW_WIDTH or local__Parent.AbsoluteSize.X;
        local Y = (object__Attr.ScaleType == Enumerate.ScaleType.Global) and WINDOW_HEIGHT or local__Parent.AbsoluteSize.Y;

        object__Attr.AbsoluteCanvasSize = Vector2.new(Size.X.Offset+X*Size.X.Scale,Size.Y.Offset+Y*Size.Y.Scale);
        for _,local__Child in pairs(object__Chil) do 
            local__Child:__Update("Size");
        end

        return;
    elseif (Index == "ZIndex") then

        Update_Draw_Order();

        return;
    end
end

-- BUTTON

local class__Button = cast__object__attributes({
    Class = "UI",
    __Attributes = {},
    __Events = {
        Button1Down = createConnection();
        Button2Down = createConnection();
        Button1Up = createConnection();
        Button2Up = createConnection();
    },
},
class__UI);

-- TEXT BOX

local class__TextBox = cast__object__attributes({
    Class = "UI",
    __Attributes = {
        Text = "Textbox";
        TextOpacity = 1;
        TextScaled = true; -- need to add behavior for false
        TextColor3 = Color3.new(0,0,0);
        FontSize = 14; -- Need to add font size to ui_drawing
    },
    __Events = {},
},
class__UI);

-- TEXT BUTTON

local class__TextButton = cast__object__attributes({
    Class = "UI", 
    __Attributes = {
        Text = "TextButton";
        TextOpacity = 1;
        TextScaled = true; -- need to add behavior for false
        TextColor3 = Color3.new(0,0,0);
        FontSize = 14; -- Need to add font size to ui_drawing
    },
    __Events = {},
},
class__Button);

-- SCROLLING BOX 

local class__ScrollingBox = cast__object__attributes({
    Class = "UI", 
    __Attributes = {
        CanvasSize = UDim2.new(0,500,0,300);
        CanvasPosition = Vector2.new(0,0);
        AbsoluteCanvasSize = Vector2.new(500,300);
        ClipsDescendants = true;
    },
    __Events = {},
},
class__UI)

local Trees = {
    -- To add a type, add an index: [type_name: String] = [class_name: String]
    -- Then to give it special attributes / properties, go into instance.new and add an if statement
    -- (that is a temporary solution, will probably be improved later ^)
    ["Part"] = class__Part,
    ["TextBox"] = class__TextBox,
    ["UI"] = class__UI,
    ["WorldObject"] = class__WorldObject,
    ["Object"] = class__Instance,
    ["Folder"] = class__Instance,
    ["Button"] = class__Button,
    ["ScrollingBox"] = class__ScrollingBox,
    ["TextButton"] = class__TextButton,
};


local Instance = {
    Update_Draw_Order = Update_Draw_Order,
    getInstances = function()
        return Instances;
    end,
    getDrawOrder = function()
        return DrawOrder;
    end,
    new = function(Type)
        
        if not Trees[Type] then return error(Type .. " is not a valid Instance class.") end;
        Instance__INDEX = Instance__INDEX + 1;
        
        local class = Trees[Type];
        local ID = Instance__INDEX;

        Instances[ID] = cast__object__attributes({ -- Applying Root Class
            Type = Type,
            Class = class.Class,
            Parent = nil,
            ID = ID,
            __Attributes = {
                Name = Type,
            },
            __Events = {},
            __Children = {},
        },class);
        Instances[ID].__index = Instances[ID];

        -- Applying Class
        local local__object = Instances[ID];
        local object__Attr = local__object.__Attributes;
        local object__Evnt = local__object.__Events;
        local object__Chil = local__object.__Children;
    
        -- Creating Proxy

        local__object.__Proxy = setmetatable({
            ProxyID = tostring(local__object);
        },{
            __index = function(self,Index)
                if local__object then
                    if object__Attr[Index] then -- returns the attribute with the index passed
                        return object__Attr[Index];
                    elseif object__Evnt[Index] then -- returns the event with the index passed
                        return object__Evnt[Index];
                    elseif local__object:FindFirstChild(Index) then 
                        return local__object:FindFirstChild(Index);
                    elseif local__object[Index] then 
                        return local__object[Index];
                    end
                else
                    return nil;
                end 
            end,
            __newindex = function(self,Index,Value)
                if Index == "Parent" then 
                    if local__object.Parent then 
                        local Proxy = setmetatable({ProxyID=self.ProxyID},self);
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
                elseif object__Attr[Index] then 
                    -- If the attribute exists, it changes the value.
                    -- This prevents new values from being added to the main object 
                    -- but allows already present values to be changed.
                    object__Attr[Index] = Value;
                    if local__object.Class == "UI" then 
                        local__object:__Update(Index);
                    end
                    object__Evnt.Changed:Fire(Index);
                    
                elseif object__Evnt[Index] then
                    error("Cannot set value of event");
                end
                rawset(self,Index,nil);
                -- directly clears the index from the proxy table
                return;
            end,
            __tostring = function(self)
                return self.Type;
            end;
            __call = function(self,...)
                return local__object;
            end
        });

        return local__object.__Proxy;
    end,
};

return Instance;