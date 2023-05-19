local Font = love.graphics.getFont();

local function DrawUI(UI)
    local Position = UI.__Attributes.AbsolutePosition;
    local Size = UI.__Attributes.AbsoluteSize;
    local Color = UI.__Attributes.BackgroundColor3;
    love.graphics.setColor(Color.Red,Color.Green,Color.Blue,UI.__Attributes.BackgroundOpacity);
    love.graphics.rectangle("fill",
        Position.X,
        Position.Y,
        Size.X,
        Size.Y
    );
    return Position, Size, Color;
end

local UI_Drawing = {
    ["UI"] = DrawUI,
    ["Button"] = DrawUI,
    ["TextBox"] = function(TextBox)
        local Position, Size, Color = DrawUI(TextBox);
        local TextColor = TextBox.__Attributes.TextColor3;
        love.graphics.setColor(TextColor.Red,TextColor.Green,TextColor.Blue);
        love.graphics.printf(
            TextBox.__Attributes.Text,
            Position.X,
            Position.Y,
            Size.X,
            "left"
        );
    end,
};

return UI_Drawing;