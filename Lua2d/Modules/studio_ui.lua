-- Module for getting the workspace UI size


local Layout = {
    Navigator = Instance.new("UI"),
    Explorer = Instance.new("Button"),
    Properties = Instance.new("Button"),
    Output = Instance.new("Button"),
    ui_workspace = Instance.new("UI");
};

local ui_workspace = Layout.ui_workspace;
local Navigator = Layout.Navigator;
local Explorer = Layout.Explorer;
local Properties = Layout.Properties;
local Output = Layout.Output;

ui_workspace.Parent = ui_service;
ui_workspace.Name = "WorkspaceUI";
ui_workspace.ZIndex = 0;
ui_workspace.Size = UDim2.new(0.8,0,0.625,0);
ui_workspace.Position = UDim2.new(0,0,0.175,0);
ui_workspace.BackgroundColor3 = Color3.new(1,1,1);
Navigator.Parent = ui_service;
Navigator.Name = "Navigator";
Navigator.ZIndex = 0;
Navigator.Size = UDim2.new(1,0,0.175,0);
Navigator.Position = UDim2.new(0,0,0,0);
Navigator.BackgroundColor3 = Color3.new(0.9,0.9,0.9);
Explorer.Parent = ui_service;
Explorer.Name = "Explorer";
Explorer.ZIndex = 0;
Explorer.Size = UDim2.new(0.2,0,0.525,0);
Explorer.Position = UDim2.new(0.8,0,0.175,0);
Explorer.BackgroundColor3 = Color3.new(0.4,0.4,0.4);
Properties.Parent = ui_service;
Properties.Name = "Properties";
Properties.ZIndex = 0;
Properties.Size = UDim2.new(0.2,0,0.4,0);
Properties.Position = UDim2.new(0.8,0,0.7,0);
Properties.BackgroundColor3 = Color3.new(0.3,0.3,0.3);
Output.Parent = ui_service;
Output.Name = "Output";
Output.ZIndex = 0;
Output.Size = UDim2.new(0.8,0,0.2,0);
Output.Position = UDim2.new(0,0,0.8,0);
Output.BackgroundColor3 = Color3.new(0.2,0.2,0.2);

local function l__MAINTAIN_UI_FORMAT()

    Explorer.Position = UDim2.new(Explorer.Position.X.Scale,0,Navigator.Size.Y.Scale,0);
    Explorer.Size = UDim2.new(Explorer.Size.X.Scale,0,Properties.Position.Y.Scale-Navigator.Size.Y.Scale,0);

    Properties.Position = UDim2.new(Explorer.Position.X.Scale,0,Explorer.Position.Y.Scale+Explorer.Size.Y.Scale,0);
    Properties.Size = UDim2.new(1-Properties.Position.X.Scale,0,math.max(1-Properties.Position.Y.Scale,0.2),0);

    Output.Position = UDim2.new(0,0,Output.Position.Y.Scale,0);
    Output.Size = UDim2.new(Properties.Position.X.Scale,0,math.max(1-Output.Position.Y.Scale,0.2),0);

    ui_workspace.Position = UDim2.new(0,0,Navigator.Size.Y.Scale,0);
    ui_workspace.Size = UDim2.new(Explorer.Position.X.Scale,0,Output.Position.Y.Scale-Navigator.Size.Y.Scale,0);
end

local function ADD_DYNAMIC_STUDIO_UI(Object)
    local Held = false;
    local Button1Press = Object.Button1Down:Connect(function()
        Held = true;
        local Old_Position = Mouse.Position;
        -- Temporary Color Change for Header to Show mouse has been pressed.
        Tween:Create(Object.Header,TweenInfo.new(0.1,Enumerate.EasingStyle.Sine),{TextColor3=Color3.new(0,1,0)}):Play();
        -- ^
        thread(function(Thread)
            Object.ZIndex = Object.ZIndex + 1;
            repeat 
                Thread:Wait();
                local New_Position = Mouse.Position;
                local Difference = New_Position-Old_Position;
                local oX,oY = Difference.X/WINDOW_WIDTH,Difference.Y/WINDOW_HEIGHT;
                -- Converts AbsolutePosition to Scale but dividing by width/height
                oX,oY = Object.Size.X.Scale-oX > 0.1 and oX or 0, Object.Size.Y.Scale-oY > 0.1 and oY or 0;
                -- Size Constraint; UI_Service Object cannot be smaller than 0.1 Scale
                Object.Position = Object.Position + UDim2.new(oX,0,oY,0);
                Object.Size = Object.Size + UDim2.new(-oX,0,oY,0);
                l__MAINTAIN_UI_FORMAT();
                Old_Position = New_Position;
            until not Held;
            Object.ZIndex = Object.ZIndex - 1;
            Thread:Close();
        end):Play()
    end)
    local Button1Release = Object.Button1Up:Connect(function()
        -- Temporary Color Change for Header to Show mouse has been Released.
        Tween:Create(Object.Header,TweenInfo.new(0.1,Enumerate.EasingStyle.Sine),{TextColor3=Color3.new(0,0,0)}):Play();
        -- ^
        Held = false;
    end)
    Object.Destroying:Once(function()
        -- When the object is destroyed, this function is fired once then the memory is cleared
        Button1Press:Disconnect();
        Button1Release:Disconnect();
    end)
end

local function TEMP_ADD_OBJECT_HEADER(Object)
    -- Temporary Tool to display the name of the object added to UI_SERVICE when the object is hovered over.
    local Header = Instance.new("TextBox");
    Header.Parent = Object;
    Header.Name = "Header";
    Header.Text = Object.Name;
    Header.Enabled = false;
    Header.BackgroundOpacity = 0;
    Header.TextOpacity = 0;
    Header.Size = UDim2.new(1,0,0,50);
    Header.ZIndex = 1;
    Object.MouseEnter:Connect(function()
        Tween:Create(Header,TweenInfo.new(0.1,Enumerate.EasingStyle.Sine),{TextOpacity=1}):Play();
    end)
    Object.MouseLeave:Connect(function()
        Tween:Create(Header,TweenInfo.new(0.1,Enumerate.EasingStyle.Sine),{TextOpacity=0}):Play();
    end)
end

for _,Object in pairs(Layout) do
    if type(Object) == "Button" then 
        ADD_DYNAMIC_STUDIO_UI(Object);
    end
    TEMP_ADD_OBJECT_HEADER(Object);
end


ui_service.ChildAdded:Connect(function(self,Object)
    if type(Object) == "Button" then 
        ADD_DYNAMIC_STUDIO_UI(Object);
    end
    TEMP_ADD_OBJECT_HEADER(Object);
    Instance.Update_Draw_Order();
end);

return Layout;