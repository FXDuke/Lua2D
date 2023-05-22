local UDim = {
    __add = function(self, Object)
        if type(Object) == "UDim" then 
            local Scale = self.Scale + Object.Scale;
            local Offset = self.Offset + Object.Offset;
            return self.new(Scale,Offset);
        else
            error("Attempted to add " .. type(Object) .. " to UDim");
        end
    end,
    __sub = function(self, Object)
        if type(Object) == "UDim" then 
            local Scale = self.Scale - Object.Scale;
            local Offset = self.Offset - Object.Offset;
            return self.new(Scale,Offset);
        else
            error("Attempted to sub " .. type(Object) .. " from UDim");
        end
    end,
    __tostring = function(UDim)
        return "{" .. UDim.Scale .. ", " .. UDim.Offset .. "}";
    end,
};
UDim.__index = UDim;

UDim.new = function(Scale,Offset)
    return setmetatable({
        Type = "UDim",
        Scale=Scale,
        Offset=Offset,
    },UDim);
end

return UDim;