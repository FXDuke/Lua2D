


-- Lua2d
-- A 2d Lua game engine made with love2d
-- Made by FXDuke#0001
-- Early Alpha




local WorkspaceUI = game.UIService.WorkspaceUI;


local Origin_Color = Color3.new(0.6,0.6,0.6);
local Origin_Opacity = 0.6;

local Button = Instance.new("Button");
Button.Parent = WorkspaceUI;
Button.Name = "GunButton";
Button.Size = UDim2.new(0.3,0,0,50) -- X will scale with WorkspaceUI X Size,  Y size will stay constant.
Button.Position = UDim2.new(0,25,0.5,-25);
Button.BackgroundColor3 = Origin_Color;
Button.BackgroundOpacity = Origin_Opacity;
Button.ZIndex = 2; 

local ButtonText = Instance.new("TextBox");
ButtonText.Parent = WorkspaceUI.GunButton; -- You could just do Button but this is for the example.
ButtonText.Enabled = false; -- Disables events like MouseEnter
ButtonText.BackgroundOpacity = 0;
ButtonText.Text = "Shoot!";
ButtonText.Size = UDim2.new(1,0,1,0);
ButtonText.ZIndex = 3;


-- Events 

Button.MouseEnter:Connect(function()
    Tween:Create(Button,TweenInfo.new(0.125,Enumerate.EasingStyle.Sine),{BackgroundColor3=Color3.new(0.5,0.5,0.5),BackgroundOpacity=1}):Play();
    Tween:Create(ButtonText,TweenInfo.new(0.125,Enumerate.EasingStyle.Sine),{TextColor3=Color3.new(0.8,0.8,0.8)}):Play();
end)

Button.MouseLeave:Connect(function()
    Tween:Create(Button,TweenInfo.new(0.125,Enumerate.EasingStyle.Sine),{BackgroundColor3=Origin_Color,BackgroundOpacity=Origin_Opacity}):Play();
    Tween:Create(ButtonText,TweenInfo.new(0.125,Enumerate.EasingStyle.Sine),{TextColor3=Color3.new(0,0,0)}):Play();
end)

Button.Button1Down:Connect(function()
    local Bullet = Instance.new("UI");
    Bullet.Parent = WorkspaceUI;
    Bullet.ZIndex = 4;
    Bullet.Position = Button.Position + Vector2.new(Button.AbsoluteSize.X,0); -- You can add/sub Vector2 values to the offet of a udim2 value
    Bullet.Size = UDim2.new(0,30,0,10);
    Bullet.BackgroundColor3 = Color3.new(1,0.5,0.25);
    Bullet.Destroying:Connect(function()
        print("Bullet Destroyed!");
    end)
    thread(function(Thread)
        local MovingTween = Tween:Create(Bullet,TweenInfo.new(1,Enumerate.EasingStyle.Sine),{Position=Bullet.Position + Vector2.new(WINDOW_WIDTH,0)});
        -- LOL
        MovingTween:Play();
        MovingTween.Completed:Wait(Thread);
        Bullet:Destroy();
    end):Play();
end)

Button.Button2Down:Once(function()
    Button:Destroy();
end)