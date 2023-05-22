local Color3 = {
    __add = function(self, Object)
        if type(Object) == "Color3" then
            return self.new(self.Red+Object.Red,self.Green+Object.Green,self.Blue+Object.Blue);
        else
            error("Attempted to add " .. type(Object) .. " to Color3");
        end
    end,
    __sub = function(self, Object)
        if type(Object) == "Color3" then
            return self.new(self.Red-Object.Red,self.Green-Object.Green,self.Blue-Object.Blue);
        else
            error("Attempted to sub " .. type(Object) .. " from Color3");
        end
    end,
    __mul = function(self, Factor)
        if type(Factor) == "number" then 
            return self.new(self.Red*Factor,self.Green*Factor,self.Blue*Factor);
        else
            error("Attempted to mul " .. type(Factor) .. " with Color3");
        end
    end,
    __div = function(self, Factor)
        if type(Factor) == "number" then 
            return self.new(self.Red/Factor,self.Green/Factor,self.Blue/Factor);
        else
            error("Attempted to div " .. type(Factor) .. " with UDim2");
        end
    end,
    __tostring = function(self)
        return "(R " .. tostring(self.Red) .. ", G " .. tostring(self.Green) .. ", B " .. tostring(self.Blue) .. ")";
    end,
};
Color3.__index = Color3;

Color3.new = function(Red,Green,Blue)
    return setmetatable({
        Type = "Color3",
        Red = Red,
        Green = Green,
        Blue = Blue,
    },Color3);
end

return Color3;