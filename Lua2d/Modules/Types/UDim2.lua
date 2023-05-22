local UDim2 = {
    __add = function(self, Object)
        if type(Object) == "Vector2" then 
            return self.new(self.X.Scale,self.X.Offset+Object.X,self.Y.Scale,self.Y.Offset+Object.Y);
        elseif type(Object) == "UDim2" then 
            return self.new(self.X.Scale+Object.X.Scale,self.X.Offset+Object.X.Offset,self.Y.Scale+Object.Y.Scale,self.Y.Offset+Object.Y.Offset);
        else
            error("Attempted to add " .. type(Object) .. " to UDim2");
        end
    end,
    __sub = function(self, Object)
        if type(Object) == "Vector2" then 
            return self.new(self.X.Scale,self.X.Offset-Object.X,self.Y.Scale,self.Y.Offset-Object.Y);
        elseif type(Object) == "UDim2" then 
            return self.new(self.X.Scale-Object.X.Scale,self.X.Offset-Object.X.Offset,self.Y.Scale-Object.Y.Scale,self.Y.Offset-Object.Y.Offset);
        else
            error("Attempted to sub " .. type(Object) .. " from UDim2");
        end
    end,
    __mul = function(self, Factor)
        if type(Factor) == "number" then 
            return self.new(self.X.Scale*Factor,self.X.Offset*Factor,self.Y.Scale*Factor,self.Y.Offset*Factor);
        else
            error("Attempted to mul " .. type(Factor) .. " with UDim2");
        end
    end,
    __div = function(self, Factor)
        if type(Factor) == "number" then 
            return self.new(self.X.Scale/Factor,self.X.Offset/Factor,self.Y.Scale/Factor,self.Y.Offset/Factor);
        else
            error("Attempted to div " .. type(Factor) .. " with UDim2");
        end
    end,
    __tostring = function(UDim2)
        return "(" .. tostring(UDim2.X) .. ", " .. tostring(UDim2.Y) .. ")";
    end,
};
UDim2.__index = UDim2;

function UDim2.new(xScale,xOffset,yScale,yOffset)
    return setmetatable({
        Type = "UDim2",
        X = UDim.new(xScale,xOffset),
        Y = UDim.new(yScale,yOffset),
    },UDim2);
end

return UDim2;


