local class__tween = {};
class__tween.__index = class__tween;


function class__tween:Play()
    self.PlaybackState = Enumerate.PlaybackState.Playing;
    self.Thread:Play();
end
-- Begins or resumes the tween

function class__tween:Pause()
    self.PlaybackState = Enumerate.PlaybackState.Paused;
    self.Thread:Pause();
end
-- Pauses the tween and allows it to be resumed later

function class__tween:Close()
    self.PlaybackState = Enumerate.PlaybackState.Completed;
    self.Completed:Fire();
    self.Thread:Close();   
    self = nil;
end
-- Completely Closes the Tween, Abruptly stopping the animation where it is at



local EasingInfo = config.EasingStyle;

local ActiveTweens = {}; -- stores the active tweens and prevents overlap

local Tween = {
    GetAlpha = function(Alpha,EasingStyle,EasingDirection)
        return math.min(EasingInfo[EasingStyle][EasingDirection](Alpha),1);
    end,
    TweenInfo = {
        new = function(Time,EasingStyle,EasingDirection,RepeatCount,Delay)
            if not (Time and EasingStyle) then error("Missing Arguments in TweenInfo.new") return end;
            return {Time=Time,EasingStyle=EasingStyle,EasingDirection=EasingDirection or 0,RepeatCount=RepeatCount or 1,Delay=Delay};
        end,
    },
};

function Tween:Create(Object,TweenInfo,PropertyTable)
    if not (Object and TweenInfo and PropertyTable) then error("Missing arguments in Tween:Create"); return end;
    local Differences = {};
    for _,Property in pairs(PropertyTable) do 
        if Object[_] then 
            Differences[_] = {Origin=Object[_],Goal=Property-Object[_]};
        else
            error("Unable to cast " .. _ .. " to " .. tostring(Object));
            return;
        end
    end
    local tweenObject;
    tweenObject = setmetatable({
        Thread = thread(function(Thread)
            local Object__ID = Object.ID;
            if ActiveTweens[Object__ID] then 
                ActiveTweens[Object__ID]:Close(); -- Closes the active tween so there is no con
            end
            local TweenInfo = TweenInfo;
            ActiveTweens[Object__ID] = tweenObject;
            while TweenInfo.RepeatCount > 0 do 
                Thread:Wait(TweenInfo.Delay);
                local Alpha = 0;
                local Start = os.clock();
                while Alpha < 1 and Object do
                    Alpha = Tween.GetAlpha((os.clock()-Start)/TweenInfo.Time,TweenInfo.EasingStyle,TweenInfo.EasingDirection);
                    for _,Property in pairs(PropertyTable) do 
                        Object[_] = Differences[_].Origin + (Differences[_].Goal*Alpha);
                    end
                    Thread:Wait();
                end
                TweenInfo.RepeatCount = TweenInfo.RepeatCount - 1;
            end 
            tweenObject:Close();
            ActiveTweens[Object__ID] = nil;
        end),
        PlaybackState = Enumerate.PlaybackState.Normal,
        Completed = createConnection(),
    },class__tween);
    return tweenObject;
end

function Tween:Close(Object)
    if ActiveTweens[Object.ID] then 
        ActiveTweens[Object.ID]:Close(); -- Closes the active tween so there is no con
    end
end

return Tween;