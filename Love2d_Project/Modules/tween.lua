local class__tween = {};
class__tween.__index = class__tween;

function class__tween:Play()
    self.PlaybackState = Enumerate.PlaybackState.Playing;
    self.Thread:Play();
end

function class__tween:Pause()
    self.PlaybackState = Enumerate.PlaybackState.Paused;
    self.Thread:Pause();
end

function class__tween:Close()
    self.PlaybackState = Enumerate.PlaybackState.Completed;
    self.Completed:Fire();
    self.Thread:Close();
    self = nil;
end



local EasingInfo = {
    [1] = {
        [0] = function(Alpha)
            return 1 - math.cos((Alpha * math.pi) / 2);
        end,
        [1] = function(Alpha)
            return math.sin((Alpha * math.pi) / 2);
        end,
        [2] = function(Alpha)
            return -(math.cos(math.pi * Alpha) - 1) / 2;
        end,
    },
};


local Tween = {
    GetAlpha = function(Alpha,EasingStyle,EasingDirection)
        return math.min(EasingInfo[EasingStyle][EasingDirection](Alpha),1);
    end,
    TweenInfo = {
        new = function(Time,EasingStyle,EasingDirection,RepeatCount,Delay)
            if not (Time and EasingStyle) then error("Missing Arguments in TweenInfo.new",debug.traceback()) return end;
            return {Time=Time,EasingStyle=EasingStyle,EasingDirection=EasingDirection or 0,RepeatCount=RepeatCount or 1,Delay=Delay};
        end,
    },
};

function Tween:Create(Object,TweenInfo,PropertyTable)
    if not (Object and TweenInfo and PropertyTable) then error("Missing arguments in Tween:Create",debug.traceback()); return end;
    local Differences = {};
    for _,Property in pairs(PropertyTable) do 
        if Object[_] then 
            Differences[_] = {Origin=Object[_],Goal=Property-Object[_]};
        else
            error("Unable to cast " .. _ .. " to Object",debug.traceback());
            break;
        end
    end
    l__tweenObject = setmetatable({
        Thread = thread(function(Thread)
            while TweenInfo.RepeatCount > 0 do 
                Thread:Wait(TweenInfo.Delay);
                local Alpha = 0;
                local Start = os.clock();
                while Alpha < 1 do
                    Thread:Wait();
                    Alpha = Tween.GetAlpha((os.clock()-Start)/TweenInfo.Time,TweenInfo.EasingStyle,TweenInfo.EasingDirection);
                    for _,Property in pairs(PropertyTable) do 
                        Object[_] = Differences[_].Origin + (Differences[_].Goal*Alpha);
                    end
                end
                TweenInfo.RepeatCount = TweenInfo.RepeatCount - 1;
            end 
            l__tweenObject:Close();
        end),
        PlaybackState = Enumerate.PlaybackState.Normal,
        Completed = createConnection(),
    },class__tween);
    return l__tweenObject;
end

return Tween;