

local Type = type;
local function newType(Object)
    if Object.Type then 
        return Object.Type;
    end
    return Type(Object);
end

return newType;