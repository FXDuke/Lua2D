-- THIS IS A TEMPORARY DEBUG TOOL. THIS IS NOT OPTIMIZED.

local function table_to_string(Table,Name)
    Name = Name or "table"
    local result = Name .. " = {\n";

    local Printed = {

    };

    local function indent(Table,Indentation)
        for _, Data in pairs(Table) do
            if Type(Data) == "table" and not Printed[Data] then
                Printed[Data] = true; 
                if Data.Class then 
                    result = result .. Indentation .. _ .. ' = ' .. tostring(Data) .. ",\n";
                elseif Data.__Connections then 
                    result = result .. Indentation .. _ .. ' = ' .. "Event" .. ",\n";
                elseif Data.Type then 
                    result = result .. Indentation .. _ .. ' = ' .. Data.Type .. ",\n";
                else 
                    result = result .. Indentation .. _ .. ' = {\n';
                    indent(Data,Indentation.."\t");
                    result = result .. Indentation .. "},\n";
                end 
            else
                local Enclose = Type(Data) == "string" and '"' or '';
                result = result .. Indentation .. _ .. ' = ' .. Enclose .. tostring(Data) .. Enclose .. ",\n" 
            end
        end
    end

    indent(Table,"\t");
    result = result .. "}";
    return result;
end

return table_to_string;