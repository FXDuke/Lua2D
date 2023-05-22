

local Config = {
    STUDIO__OBJECT__CONFIGURATIONS = {
        UI__SCROLLING__CAST = {
            Name = "Content";
            Size = UDim2.new(1,0,1,-30);
            Position = UDim2.new(0,0,0,30);
            CanvasSize = UDim2.new(1,0,0,0);
            BackgroundOpacity = 0;
            ZIndex = 2;
        },
        WorkspaceUI = {
            Name = "WorkspaceUI";
            Parent = ui_service;
            ClipsDescendants = true;
            Size = UDim2.new(0.8,0,0.625,0);
            Position = UDim2.new(0,0,0.175,0);
            BackgroundColor3 = Color3.new(1,1,1);
        },
        Navigator = {
            Name = "Navigator";
            Parent = ui_service;
            Size = UDim2.new(1,0,0.175,0);
            BackgroundColor3 = Color3.new(0.9,0.9,0.9);
        },
        Explorer = {
            Name = "Explorer";
            Parent = ui_service;
            ZIndex = 2;
            Enabled = false;
            Size = UDim2.new(0.2,0,0.525,0);
            Position = UDim2.new(0.8,0,0.175,0);
            BackgroundColor3 = Color3.new(0.4,0.4,0.4);
        },
        Properties = {
            Name = "Properties";
            Parent = ui_service;
            ZIndex = 4;
            Enabled = false;
            Size = UDim2.new(0.2,0,0.4,0);
            Position = UDim2.new(0.8,0,0.7,0);
            BackgroundColor3 = Color3.new(0.3,0.3,0.3);
        },
        Output = {
            Name = "Output";
            Parent = ui_service;
            Size = UDim2.new(0.8,0,0.2,0);
            Position = UDim2.new(0,0,0.8,0);
            BackgroundColor3 = Color3.new(0.2,0.2,0.2);
        },
        Header = {
            Name = "Header";
            Enabled = true;
            BackgroundOpacity = 0.2;
            TextOpacity = 0.7;
            Size = UDim2.new(1,0,0,25);
            ZIndex = 4;
        },
    },
    NAVIGATOR__CONFIGURATIONS = {
        Explorer__Object = {
            Name = "Explorer__Object";
            Size = UDim2.new(1,0,0,20);
            Enabled = false;
            ZIndex = 2;
            BackgroundOpacity = 0;
        },
        Explorer__Label = {
            Name = "Label";
            Size = UDim2.new(1,-25,0,20);
            Position = UDim2.new(0,25,0,0);
            Text = "Label";
            BackgroundOpacity = 0.5;
            ZIndex = 3;
        },
        Explorer__Expand = {
            Name = "Expand";
            Size = UDim2.new(0,20,0,20);
            Position = UDim2.new(0,5,0,0);
            Text = "+";
            BackgroundOpacity = 0.5;
            ZIndex = 3;
        },
        Properties__Object = {
            Name = "Properties__Object";
            Size = UDim2.new(1,0,0,30);
            Enabled = true;
            BackgroundOpacity = 0.5;
            ZIndex = 4;
        },
        Properties__Label = {
            Name = "Property_Name";
            Size = UDim2.new(0.4,0,0,30);
            Position = UDim2.new(0,0,0,0);
            Text = "Property_Name";
            BackgroundOpacity = 0;
            ZIndex = 5;
        },
        Properties__Value = {
            Name = "Property_Value";
            Size = UDim2.new(0.6,-5,0,30);
            Position = UDim2.new(0.4,5,0,0);
            Text = "Property_Value";
            BackgroundOpacity = 0;
            ZIndex = 5;
        },
    },
    EasingStyle = {
        [0] = { -- Linear (idk how to do out or inout for linear...)
            [0] = function(Alpha) -- in
                return Alpha;
            end,
            [1] = function(Alpha) -- out 
                return Alpha;
            end,
            [2] = function(Alpha) -- inout
                return Alpha;
            end,
        },
        [1] = { -- Sine
            [0] = function(Alpha) -- in
                return 1 - math.cos((Alpha * math.pi) / 2);
            end,
            [1] = function(Alpha) -- out 
                return math.sin((Alpha * math.pi) / 2);
            end,
            [2] = function(Alpha) -- inout
                return -(math.cos(math.pi * Alpha) - 1) / 2;
            end,
        },
        [2] = { -- Elastic 
            [0] = function(Alpha) -- in
                local c4 = (2 * math.pi) / 3;
                return Alpha == 0 and 0 or Alpha == 1 and 1 or -math.pow(2, 10 * Alpha - 10) * math.sin((Alpha * 10 - 10.75) * c4);
            end,
            [1] = function(Alpha) -- out
                local c4 = (2 * math.pi) / 3;
    
                return Alpha == 0 and 0 or Alpha == 1 and 1 or math.pow(2, -10 * Alpha) * math.sin((Alpha * 10 - 0.75) * c4) + 1;
            end,
            [2] = function(Alpha) -- inout
                local c5 = (2 * math.pi) / 4.5;
    
                return Alpha == 0 and 0 or Alpha == 1 and 1 or Alpha < 0.5 and -(math.pow(2, 20 * Alpha - 10) * math.sin((20 * Alpha - 11.125) * c5)) / 2 or (math.pow(2, -20 * Alpha + 10) * math.sin((20 * Alpha - 11.125) * c5)) / 2 + 1;
            end,
        },
    },
};

function Config.Cast(local__Object, local__CONFIG)
    if not (local__Object and local__CONFIG) then error("Config.Cast missing arguments"); return; end;
    for Property__Name, Property__Value in pairs(local__CONFIG) do 
        local__Object[Property__Name] = Property__Value;
    end
end

return setmetatable({},{
    __index = Config,
    __newindex = function()
        error("Config values are read only.");
    end,
});