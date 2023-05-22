-- Module for getting the workspace UI size
local STUDIO_CONFIG = config.STUDIO__OBJECT__CONFIGURATIONS;

local Layout = {
    Navigator = Instance.new("UI"),
    Explorer = Instance.new("UI"),
    Properties = Instance.new("UI"),
    Output = Instance.new("UI"),
    WorkspaceUI = Instance.new("UI"),
};

local Navigator = Layout.Navigator;
local Explorer = Layout.Explorer;
local Properties = Layout.Properties;
local Output = Layout.Output;
local WorkspaceUI = Layout.WorkspaceUI;

local UI__SCROLLING__CAST = Instance.new("ScrollingBox");
config.Cast(UI__SCROLLING__CAST,STUDIO_CONFIG.UI__SCROLLING__CAST);

local Explorer__Content = UI__SCROLLING__CAST:Clone();
Explorer__Content.Parent = Explorer;

local Properties__Content = UI__SCROLLING__CAST:Clone();
Properties__Content.Parent = Properties;

UI__SCROLLING__CAST:Destroy();

for _,UI_ITEM in pairs(Layout) do 
    config.Cast(UI_ITEM,STUDIO_CONFIG[_]);
end 

-- Clears memory

local function MAINTAIN_UI_FORMAT()
    -- This is temporary, do not expect full optimization.

    Navigator.Position = UDim2.new(0,0,0,0);
    Navigator.Size = UDim2.new(1,0,0.175,0);

    Explorer.Position = UDim2.new(Explorer.Position.X.Scale,0,Navigator.Size.Y.Scale,0);
    Explorer.Size = UDim2.new(Explorer.Size.X.Scale,0,Properties.Position.Y.Scale-Navigator.Size.Y.Scale,0);

    Properties.Position = UDim2.new(Explorer.Position.X.Scale,0,Explorer.Position.Y.Scale+Explorer.Size.Y.Scale,0);
    Properties.Size = UDim2.new(1-Properties.Position.X.Scale,0,math.max(1-Properties.Position.Y.Scale,0.2),0);

    Output.Position = UDim2.new(0,0,Output.Position.Y.Scale,0);
    Output.Size = UDim2.new(Properties.Position.X.Scale,0,math.max(1-Output.Position.Y.Scale,0.2),0);

    WorkspaceUI.Position = UDim2.new(0,0,Navigator.Size.Y.Scale,0);
    WorkspaceUI.Size = UDim2.new(Explorer.Position.X.Scale,0,Output.Position.Y.Scale-Navigator.Size.Y.Scale,0);

end

local Header = Instance.new("TextButton");
config.Cast(Header,STUDIO_CONFIG["Header"]);

local function ADD_DYNAMIC_STUDIO_UI(Object)
    -- This is temporary, do not expect full optimization.

    local clone__Header = Header:Clone();
    clone__Header.Parent = Object;
    clone__Header.Text = Object.Name;

    clone__Header.MouseEnter:Connect(function()
        Tween:Create(clone__Header,TweenInfo.new(0.1,Enumerate.EasingStyle.Sine),{TextOpacity=1}):Play();
    end)
    clone__Header.MouseLeave:Connect(function()
        Tween:Create(clone__Header,TweenInfo.new(0.1,Enumerate.EasingStyle.Sine),{TextOpacity=0.5}):Play();
    end)

    local Mouse__Held = false;
    local Button1Press = clone__Header.Button1Down:Connect(function()
        Mouse__Held = true;
        local Old_Position = Mouse.Position;

        -- Temporary Color Change for Header to Show mouse has been pressed.
        Tween:Create(clone__Header,TweenInfo.new(0.1,Enumerate.EasingStyle.Sine),{TextColor3=Color3.new(0,1,0)}):Play();

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
                MAINTAIN_UI_FORMAT();
                Old_Position = New_Position;
            until not Held;

            Object.ZIndex = Object.ZIndex - 1;

            Thread:Close();
        end):Play()
    end)
    local Button1Release = clone__Header.Button1Up:Connect(function()
        -- Temporary Color Change for Header to Show mouse has been Released.
        Tween:Create(clone__Header,TweenInfo.new(0.1,Enumerate.EasingStyle.Sine),{TextColor3=Color3.new(0,0,0)}):Play();
        -- ^
        Mouse__Held = false;

    end)
    Object.Destroying:Once(function()
        -- When the object is destroyed, this function is fired once then the memory is cleared
        Button1Press:Disconnect();
        Button1Release:Disconnect();
    end)
end


for _,Object in pairs(Layout) do
    ADD_DYNAMIC_STUDIO_UI(Object);  
end

ui_service.ChildAdded:Connect(function(self,Object)
    ADD_DYNAMIC_STUDIO_UI(Object);
    Instance.Update_Draw_Order();
end);

return Layout;