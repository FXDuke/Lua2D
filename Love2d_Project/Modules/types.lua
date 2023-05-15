

local vector2__behavior = {
    __add = function(self,Object)
        return Types.Vector2.new(self.X + Object.X,self.Y + Object.Y);
    end,
    __sub = function(self,Object)
        return Types.Vector2.new(self.X - Object.X,self.Y - Object.Y);
    end,
    __mul = function(self,Magnitude)
        return Types.Vector2.new(self.X * Magnitude,self.Y * Magnitude);
    end,
    __div = function(self,Magnitude)
        return Types.Vector2.new(self.X / Magnitude,self.Y / Magnitude);
    end,
    __eq = function(self, Object)
        return (self.X == Object.X and self.Y == Object.Y)
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
};

return Types;