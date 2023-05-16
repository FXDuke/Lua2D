
local UI_Drawing = {
    ["TextBox"] = function(TextBox)
        local Position = TextBox.__Attributes.Position;
        local Size = TextBox.__Attributes.Size;
        local Color = TextBox.__Attributes.BackgroundColor3;
        local TextColor = TextBox.__Attributes.TextColor3;
        love.graphics.setColor(Color.Red,Color.Green,Color.Blue,TextBox.__Attributes.BackgroundOpacity);
        love.graphics.rectangle("fill",
            Position.X.Offset+WINDOW_WIDTH*Position.X.Scale,
            Position.Y.Offset+WINDOW_HEIGHT*Position.Y.Scale,
            Size.X.Offset+WINDOW_WIDTH*Size.X.Scale,
            Size.Y.Offset+WINDOW_HEIGHT*Size.Y.Scale
        );
        love.graphics.setColor(TextColor.Red,TextColor.Green,TextColor.Blue);
        love.graphics.print(
            TextBox.__Attributes.Text,
            Position.X.Offset+WINDOW_WIDTH*Position.X.Scale,
            Position.Y.Offset+WINDOW_HEIGHT*Position.Y.Scale+(Size.Y.Offset+WINDOW_HEIGHT*Size.Y.Scale)/2
        );
    end,
};

return UI_Drawing;