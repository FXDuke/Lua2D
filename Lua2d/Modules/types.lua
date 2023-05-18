

local vector2__behavior = {
    __add = function(self,Object)
        if type(Object) == "Vector2" then 
            return Types.Vector2.new(self.X + Object.X,self.Y + Object.Y);
        else
            error("Attempted to add " .. type(Object) .. " to Vector2");
        end
    end,
    __sub = function(self,Object)
        if type(Object) == "Vector2" then 
            return Types.Vector2.new(self.X - Object.X,self.Y - Object.Y);
        else 
            error("Attempted to sub " .. type(Object) .. " from Vector2");
        end
    end,
    __mul = function(self,Magnitude)
        if type(Magnitude) == "number" then 
            return Types.Vector2.new(self.X * Magnitude,self.Y * Magnitude);
        else 
            error("Attempted to mul " .. type(Object) .. " with Vector2");
        end
    end,
    __div = function(self,Magnitude)
        if type(Magnitude) == "number" then 
            return Types.Vector2.new(self.X / Magnitude,self.Y / Magnitude);
        else 
            error("Attempted to div " .. type(Object) .. " with Vector2");
        end
    end,
    __eq = function(self, Object)
        if type(Object) == "Vector2" then 
            return (self.X == Object.X and self.Y == Object.Y)
        else 
            error("Attempted to compare " .. type(Object) .. " and Vector2");
        end
    end,
    __tostring = function(Vector2)
        return "(" .. Vector2.X .. ", " .. Vector2.Y .. ")";
    end,
};
vector2__behavior.__index = vector2__behavior;

function vector2__behavior:Lerp(Goal,Alpha)
    local Difference = Goal-self;
    return self + (Difference.Unit * (Difference.Magnitude*Alpha));
end

local udim__behavior = {
    __add = function(self, Object)
        if type(Object) == "UDim" then 
            local Scale = self.Scale + Object.Scale;
            local Offset = self.Offset + Object.Offset;
            return Types.UDim.new(Scale,Offset);
        else
            error("Attempted to add " .. type(Object) .. " to UDim");
        end
    end,
    __sub = function(self, Object)
        if type(Object) == "UDim" then 
            local Scale = self.Scale - Object.Scale;
            local Offset = self.Offset - Object.Offset;
            return Types.UDim.new(Scale,Offset);
        else
            error("Attempted to sub " .. type(Object) .. " from UDim");
        end
    end,
    __tostring = function(UDim)
        return "{Scale = " .. UDim.Scale .. ", Offset = " .. UDim.Offset .. "}";
    end,
};
udim__behavior.__index = udim__behavior;

local udim2__behavior = {
    __add = function(self, Object)
        if type(Object) == "Vector2" then 
            return Types.UDim2.new(self.X.Scale,self.X.Offset+Object.X,self.Y.Scale,self.Y.Offset+Object.Y);
        elseif type(Object) == "UDim2" then 
            return Types.UDim2.new(self.X.Scale+Object.X.Scale,self.X.Offset+Object.X.Offset,self.Y.Scale+Object.Y.Scale,self.Y.Offset+Object.Y.Offset);
        else
            error("Attempted to add " .. type(Object) .. " to UDim2");
        end
    end,
    __sub = function(self, Object)
        if type(Object) == "Vector2" then 
            return Types.UDim2.new(self.X.Scale,self.X.Offset-Object.X,self.Y.Scale,self.Y.Offset-Object.Y);
        elseif type(Object) == "UDim2" then 
            return Types.UDim2.new(self.X.Scale-Object.X.Scale,self.X.Offset-Object.X.Offset,self.Y.Scale-Object.Y.Scale,self.Y.Offset-Object.Y.Offset);
        else
            error("Attempted to sub " .. type(Object) .. " from UDim2");
        end
    end,
    __mul = function(self, Factor)
        if type(Factor) == "number" then 
            return Types.UDim2.new(self.X.Scale*Factor,self.X.Offset*Factor,self.Y.Scale*Factor,self.Y.Offset*Factor);
        else
            error("Attempted to mul " .. type(Object) .. " with UDim2");
        end
    end,
    __div = function(self, Factor)
        if type(Factor) == "number" then 
            return Types.UDim2.new(self.X.Scale/Factor,self.X.Offset/Factor,self.Y.Scale/Factor,self.Y.Offset/Factor);
        else
            error("Attempted to div " .. type(Object) .. " with UDim2");
        end
    end,
    __tostring = function(UDim2)
        return "(" .. tostring(UDim2.X) .. ", " .. tostring(UDim2.Y) .. ")";
    end,
};
udim2__behavior.__index = udim2__behavior;

local color3__behavior = {
    __add = function(self, Object)
        if type(Object) == "Color3" then
            return Types.Color3.new(self.Red+Object.Red,self.Green+Object.Green,self.Blue+Object.Blue);
        else
            error("Attempted to add " .. type(Object) .. " to Color3");
        end
    end,
    __sub = function(self, Object)
        if type(Object) == "Color3" then
            return Types.Color3.new(self.Red-Object.Red,self.Green-Object.Green,self.Blue-Object.Blue);
        else
            error("Attempted to sub " .. type(Object) .. " from Color3");
        end
    end,
    __tostring = function(self)
        return "(R " .. tostring(self.Red) .. ", G " .. tostring(self.Green) .. ", B " .. tostring(self.Blue) .. ")";
    end,
};
color3__behavior.__index = color3__behavior;

Types = {
    Vector2 = {
        new = function(X,Y)
            local Magnitude = math.sqrt(X*X+Y*Y);
            return setmetatable({
                Type = "Vector2",
                X=X,
                Y=Y,
                Magnitude = Magnitude,
                Unit = setmetatable({
                    X = X/Magnitude,
                    Y = Y/Magnitude;
                },vector2__behavior);
            },vector2__behavior);
        end,
    },
    Color3 = {
        new = function(Red,Green,Blue)
            return setmetatable({
                Type = "Color3",
                Red = Red,
                Green = Green,
                Blue = Blue,
            },color3__behavior);
        end,
    },
    UDim = {
        new = function(Scale,Offset)
            return setmetatable({
                Type = "UDim",
                Scale=Scale,
                Offset=Offset,
            },udim__behavior);
        end,
    },
    UDim2 = {
        new = function(xScale,xOffset,yScale,yOffset)
            return setmetatable({
                Type = "UDim2",
                X = Types.UDim.new(xScale,xOffset),
                Y = Types.UDim.new(yScale,yOffset),
            },udim2__behavior);
        end,
    },
};

return Types;