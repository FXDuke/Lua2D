local Font = love.graphics.getFont();

local empty__Vector = Vector2.new(0,0);

local OLD = {};

local function DrawUI(UI,ClipBoundary)
    local Position = Vector2.new(UI.AbsolutePosition.X,UI.AbsolutePosition.Y);
    local Size = Vector2.new(UI.AbsoluteSize.X,UI.AbsoluteSize.Y); 
    local Scrolling = UI:FindFirstAncestorOfType("ScrollingBox");
    if Scrolling then 
        Position = Position + Scrolling.CanvasPosition;
    end 
    if ClipBoundary then
        if ClipBoundary.Position.Y+ClipBoundary.Size.Y < Position.Y or Position.Y+Size.Y < ClipBoundary.Position.Y then 
            if not OLD[UI.ID] then 
                OLD[UI.ID] = {
                    Enabled=UI.Enabled,
                    Visible=UI.Visible,
                };
                UI.Enabled = false;
                UI.Visible = false;
            end
        elseif OLD[UI.ID] then
            UI.Enabled = UI.Enabled == true and true or OLD[UI.ID].Enabled;
            UI.Visible = UI.Visible == true and true or OLD[UI.ID].Visible;
            OLD[UI.ID] = nil;
        end
        if not UI.Visible then return nil end;
        local PPos = ClipBoundary.Position;
        local PSiz = ClipBoundary.Size; 
        Size.X = Position.X+Size.X <= PPos.X+PSiz.X and Size.X or math.max(PPos.X+PSiz.X-Position.X,0);
        Size.Y = Position.Y+Size.Y <= PPos.Y+PSiz.Y and Size.Y or math.max(PPos.Y+PSiz.Y-Position.Y,0);
        Size.X = Position.X > PPos.X and Size.X or -math.min(PPos.X-(Position.X+Size.X),0);
        Size.Y = Position.Y > PPos.Y and Size.Y or -math.min(PPos.Y-(Position.Y+Size.Y),0);
        Position.X = Position.X >= PPos.X and Position.X or PPos.X-1;
        Position.Y = Position.Y >= PPos.Y and Position.Y or PPos.Y-1;
    end
    local Color = UI.BackgroundColor3;
    love.graphics.setColor(Color.Red,Color.Green,Color.Blue,UI.BackgroundOpacity);
    love.graphics.rectangle("fill",
        Position.X,
        Position.Y,
        Size.X,
        Size.Y
    );
    return Position, Size, Color, ClipBoundary;
end

local UI_Drawing = {
    ["UI"] = DrawUI,
    ["Button"] = DrawUI,
    ["TextBox"] = function(TextBox,ClipBoundary)
        local Position, Size, Color = DrawUI(TextBox,ClipBoundary);
        if not Position then return end;
        if ClipBoundary then 
            if ClipBoundary.Position.Y+ClipBoundary.Size.Y < Position.Y or Position.Y < ClipBoundary.Position.Y then 
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
    ["ScrollingBox"] = function(ScrollingBox,ClipBoundary)
        local Position, Size, Color = DrawUI(ScrollingBox,ClipBoundary);
    end,
    ["TextButton"] = function(TextButton,ClipBoundary)
        local Position, Size, Color = DrawUI(TextButton,ClipBoundary);
        if not Position then return end;
        if ClipBoundary then 
            if ClipBoundary.Position.Y+ClipBoundary.Size.Y < Position.Y or Position.Y < ClipBoundary.Position.Y then 
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