

local Type = type;
local function newType(Object)
    local TypeOf = Type(Object);
    if TypeOf == "table" then 
        if Object.Type then
            return Object.Type;
        end
    end
    return TypeOf;
end

return newType;