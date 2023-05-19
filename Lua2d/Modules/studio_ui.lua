-- Module for getting the workspace UI size


local Layout = {
    Navigator = Instance.new("TextBox"),
    Explorer = Instance.new("TextBox"),
    Properties = Instance.new("TextBox"),
    Output = Instance.new("TextBox"),
};


Layout.Navigator.Parent = ui_service;
Layout.Navigator.Name = "Navigator";
Layout.Navigator.Text = "Navigator";
Layout.Navigator.TextColor3 = Color3.new(0,0,0);
Layout.Navigator.ZIndex = 0;
Layout.Navigator.Size = UDim2.new(1,0,0.175,0);
Layout.Navigator.Position = UDim2.new(0,0,0,0);
Layout.Navigator.BackgroundColor3 = Color3.new(0.9,0.9,0.9);
Layout.Explorer.Parent = ui_service;
Layout.Explorer.Name = "Explorer";
Layout.Explorer.Text = "Explorer";
Layout.Explorer.TextColor3 = Color3.new(1,1,1);
Layout.Explorer.ZIndex = 0;
Layout.Explorer.Size = UDim2.new(0.2,0,0.525,0);
Layout.Explorer.Position = UDim2.new(0.8,0,0.175,0);
Layout.Explorer.BackgroundColor3 = Color3.new(0.4,0.4,0.4);
Layout.Properties.Parent = ui_service;
Layout.Properties.Name = "Properties";
Layout.Properties.Text = "Properties";
Layout.Properties.TextColor3 = Color3.new(1,1,1);
Layout.Properties.ZIndex = 0;
Layout.Properties.Size = UDim2.new(0.2,0,0.4,0);
Layout.Properties.Position = UDim2.new(0.8,0,0.7,0);
Layout.Properties.BackgroundColor3 = Color3.new(0.3,0.3,0.3);
Layout.Output.Parent = ui_service;
Layout.Output.Name = "Output";
Layout.Output.Text = "Output";
Layout.Output.TextColor3 = Color3.new(1,1,1);
Layout.Output.ZIndex = 0;
Layout.Output.Size = UDim2.new(0.8,0,0.2,0);
Layout.Output.Position = UDim2.new(0,0,0.8,0);
Layout.Output.BackgroundColor3 = Color3.new(0.2,0.2,0.2);

return Layout;