local Font = love.graphics.getFont();

local empty__Vector = Vector2.new(0,0);

local function DrawUI(UI)
    local Position = Vector2.new(UI.AbsolutePosition.X,UI.AbsolutePosition.Y);
    local Size = Vector2.new(UI.AbsoluteSize.X,UI.AbsoluteSize.Y); 
    local Color = UI.BackgroundColor3;
    local Clips = nil;
    if UI.Parent.Class == "UI" then 
        local Scrolling = UI:FindFirstAncestorOfType("ScrollingBox");
        if Scrolling then 
            Position = Position + Scrolling.CanvasPosition;
        end 
        if UI.Parent.ClipsChildren then
            Clips = UI.Parent;
            local Parent = UI.Parent;
            local PPos = Vector2.new(Parent.AbsolutePosition.X,Parent.AbsolutePosition.Y);
            local PSiz = Vector2.new(Parent.AbsoluteSize.X,Parent.AbsoluteSize.Y); 
            Size.X = Position.X+Size.X <= PPos.X+PSiz.X and Size.X or math.max(PPos.X+PSiz.X-Position.X,0);
            Size.Y = Position.Y+Size.Y <= PPos.Y+PSiz.Y and Size.Y or math.max(PPos.Y+PSiz.Y-Position.Y,0);
            Size.X = Position.X > PPos.X and Size.X or -math.min(PPos.X-(Position.X+Size.X),0);
            Size.Y = Position.Y > PPos.Y and Size.Y or -math.min(PPos.Y-(Position.Y+Size.Y),0);
            Position.X = Position.X >= PPos.X and Position.X or PPos.X-1;
            Position.Y = Position.Y >= PPos.Y and Position.Y or PPos.Y-1;
        end
    end 
    love.graphics.setColor(Color.Red,Color.Green,Color.Blue,UI.BackgroundOpacity);
    love.graphics.rectangle("fill",
        Position.X,
        Position.Y,
        Size.X,
        Size.Y
    );
    return Position, Size, Color, Clips;
end

local UI_Drawing = {
    ["UI"] = DrawUI,
    ["Button"] = DrawUI,
    ["TextBox"] = function(TextBox)
        local Position, Size, Color, Clips = DrawUI(TextBox);
        if Clips then 
            if Clips.AbsolutePosition.Y+Clips.AbsoluteSize.Y < Position.Y+TextBox.FontSize or Position.Y < Clips.AbsolutePosition.Y then 
                return;
            end
        end 
        local TextColor = TextBox.TextColor3;
        love.graphics.setColor(TextColor.Red,TextColor.Green,TextColor.Blue, TextBox.TextOpacity);
        love.graphics.printf(
            TextBox.Text,
            Position.X,
            Position.Y,
            Size.Magnitude,
            "left"
        );
    end,
    ["ScrollingBox"] = function(ScrollingBox)
        local Position, Size, Color = DrawUI(ScrollingBox);
    end,
    ["TextButton"] = function(TextButton)
        local Position, Size, Color, Clips = DrawUI(TextButton);
        if Clips then 
            if Clips.AbsolutePosition.Y+Clips.AbsoluteSize.Y < Position.Y+TextButton.FontSize then 
                return;
            end
        end 
        local TextColor = TextButton.TextColor3;
        love.graphics.setColor(TextColor.Red,TextColor.Green,TextColor.Blue, TextButton.TextOpacity);
        love.graphics.printf(
            TextButton.Text,
            Position.X,
            Position.Y,
            Size.Magnitude,
            "left"
        );
    end,
};

return UI_Drawing;