local Vector2 = {
    __add = function(self,Object)
        if type(Object) == "Vector2" then 
            return self.new(self.X + Object.X,self.Y + Object.Y);
        else
            error("Attempted to add " .. type(Object) .. " to Vector2");
        end
    end,
    __sub = function(self,Object)
        if type(Object) == "Vector2" then 
            return self.new(self.X - Object.X,self.Y - Object.Y);
        else 
            error("Attempted to sub " .. type(Object) .. " from Vector2");
        end
    end,
    __mul = function(self,Magnitude)
        if type(Magnitude) == "number" then 
            return self.new(self.X * Magnitude,self.Y * Magnitude);
        else 
            error("Attempted to mul " .. type(Magnitude) .. " with Vector2");
        end
    end,
    __div = function(self,Magnitude)
        if type(Magnitude) == "number" then 
            return self.new(self.X / Magnitude,self.Y / Magnitude);
        else 
            error("Attempted to div " .. type(Magnitude) .. " with Vector2");
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
Vector2.__index = Vector2;


function Vector2.new(X,Y)
    local Magnitude = math.sqrt(X*X+Y*Y);
    return setmetatable({
        Type = "Vector2",
        X=X,
        Y=Y,
        Magnitude = Magnitude,
        Unit = setmetatable({
            X = X/Magnitude,
            Y = Y/Magnitude;
        },Vector2);
    },Vector2);
end

function Vector2:Lerp(Goal,Alpha)
    local Difference = Goal-self;
    return self + (Difference.Unit * (Difference.Magnitude*Alpha));
end

return Vector2;


