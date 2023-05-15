local Instances = {};

function __DebugGetSelf(Object)
    return Instances[Object.ID];
end

local l__Instance = {};
l__Instance.__index = l__Instance;


function l__Instance:FindFirstChild(Name)
    self = (self.ProxyID) and __DebugGetSelf(self) or self;
    for _,Child in pairs(self.__Children) do 
        if Child.Name == Name then 
            return Child;
        end
    end
    return nil;
end

function l__Instance:WaitForChild(Name)
    self = (self.ProxyID) and __DebugGetSelf(self) or self;
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
            error(self.Name,"Possible infinite yield waiting for child " .. Name, debug.traceback()); 
        end):Play();
    end
end

function l__Instance:FindFirstAncestor(Name)
    self = (self.ProxyID) and __DebugGetSelf(self) or self;
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

function l__Instance:GetChildren()
    self = (self.ProxyID) and __DebugGetSelf(self) or self;
    return self.__Children;
end

function l__Instance:Destroy()
    self = (self.ProxyID) and __DebugGetSelf(self) or self;
    for _,Child in pairs(self.__Children) do 
        Child:Destroy();
    end
    self.__Events.Destroying:Fire();
    if self.Parent then 
        self.Parent.__Events.ChildRemoved:Fire(self);
        rawset(self.Parent.__Children,self.__Proxy.ProxyID,nil);
    end
    rawset(Instances,self.ID,nil);
end




local Instance = {
    new = function(Type)

        -- Applying Root Class

        Type = Type or "Folder";

        local ID = #Instances+1;
        Instances[ID] = setmetatable({
            Type = "Object",
            ID = ID,
            __Children = {},
            __Attributes = {
            },
            __Events = {
                ChildAdded = createConnection(),
                ChildRemoved = createConnection(),
                Destroying = createConnection(),
                Changed = createConnection(),
            },
        },l__Instance);
        Instances[ID].__index = Instances[ID];

        -- Applying Class

        local l__Attr = Instances[ID].__Attributes;
        l__Attr.ClassName = Type;
        l__Attr.Name = Type;

        if Type == "Object" then 
            l__Attr.Position = Vector2.new(0,0);
            l__Attr.Size = Vector2.new(0,0);
            --l__Attr.Color3 = true;
            l__Attr.Transparency = 0;
        elseif Type == "UI" then
            l__Attr.Position = Vector2.new(0,0); 
            l__Attr.Size = Vector2.new(0,0);
            l__Attr.Enabled = true;
            l__Attr.Visible = true;
            --l__Attr.Color3 = true;
            l__Attr.Transparency = 0;
        end 

        -- Creating Proxy

        Instances[ID].__Proxy = setmetatable({
            ID = ID,
            ClassName = Type;
            Name = Type;
            ProxyID = tostring(Instances[ID]);
        },{
            __index = function(self,Index)
                if l__Attr[Index] then 
                    return l__Attr[Index];
                elseif Instances[ID].__Events[Index] then 
                    return Instances[ID].__Events[Index];
                elseif Instances[ID]:FindFirstChild(Index) then 
                    return Instances[ID]:FindFirstChild(Index);
                else 
                    return Instances[ID].__index[Index];
                end
            end,
            __newindex = function(self,Index,Value)
                if Index == "Parent" then 
                    if Instances[self.ID].Parent then 
                        local l__proxy = setmetatable({ID=self.ID,ProxyID=self.ProxyID},self);
                        Instances[self.ID].ChildRemoved:Fire(Instances[self.ID]);
                        rawset(Instances[self.ID].Parent.__Children,self.ProxyID,nil);
                        self = l__proxy;
                    end
                    if Value.ClassName then 
                        Instances[self.ID].Parent = Value;
                        Value.__Children[self.ProxyID] = self;
                        Value.__Events.ChildAdded:Fire(Instances[self.ID]);
                    else
                        error("Parent must be an instance", debug.traceback())
                    end
                elseif Index == "__Children" then 
                    if Value.ClassName then 
                        Instances[self.ID].__Children[Index] = Value;
                    end
                elseif l__Attr[Index] then 
                    l__Attr[Index] = Value;
                    self.Changed:Fire(Index);
                elseif Instances[self.ID].__Events[Index] then
                    error("Cannot set value of event",debug.traceback());
                end
                rawset(self,Index,nil);
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