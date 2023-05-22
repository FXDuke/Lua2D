



-- Lua2d
-- Made by FXDuke
-- Small example

-- Im gonna make a button that "shoots" a bullet

local workspaceui = game.UIService.WorkspaceUI;


local Button = Instance.new("TextButton");
Button.Name = "GunButton";
Button.Parent = workspaceui;
Button.ZIndex = 2;
Button.Text = "Shoot!";
Button.Size = UDim2.new(0.2,0,0,50); -- Y size wont scale as you will see 
Button.Position = UDim2.new(0,25,0.3,-25);
Button.BackgroundColor3 = Color3.new(0.3,0.3,0.3);
Button.TextOpacity = 0.5;

Button.MouseEnter:Connect(function()
    Tween:Create(Button,TweenInfo.new(0.25,Enumerate.EasingStyle.Sine),{BackgroundColor3=Color3.new(0.3,0.3,0.3),TextOpacity=1,TextColor3=Color3.new(0.5,0.5,0.5)}):Play();
end)

Button.MouseLeave:Connect(function()
    Tween:Create(Button,TweenInfo.new(0.25,Enumerate.EasingStyle.Sine),{BackgroundColor3=Color3.new(0,0,0),TextOpacity=0.5,TextColor3=Color3.new(0,0,0)}):Play();
end)


local Bullet = Instance.new("UI");
Bullet.Size = UDim2.new(0,30,0,10);
Bullet.Name = "Bullet";
Bullet.ZIndex = 3;
Bullet.BackgroundColor3 = Color3.new(1,0.5,0.25);

Button.Button1Up:Connect(function()
    local Bullet_Info = TweenInfo.new(1,Enumerate.EasingStyle.Sine);
    local Bullet_Goal = {Position = Button.Position + Vector2.new(WINDOW_WIDTH,0)}; -- You can add Vector2 values to the offsets of udim2 values 
    local local__Bullet = Bullet:Clone();
    local__Bullet.Parent = workspaceui;
    local__Bullet.Position = Button.Position + Vector2.new(Button.AbsoluteSize.X,0);
    local__Bullet.Destroying:Connect(function()
        print("Goodbye Bullet :(");
    end)
    thread(function(Thread)
        local local__Bullet__tween = Tween:Create(local__Bullet,Bullet_Info,Bullet_Goal);
        local__Bullet__tween:Play();
        local__Bullet__tween.Completed:Wait(Thread);
        local__Bullet:Destroy();
    end):Play();
end)

