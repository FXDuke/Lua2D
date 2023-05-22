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



local EasingInfo = {
    [1] = { -- Sine
        [0] = function(Alpha) -- in
            return 1 - math.cos((Alpha * math.pi) / 2);
        end,
        [1] = function(Alpha) -- out 
            return math.sin((Alpha * math.pi) / 2);
        end,
        [2] = function(Alpha) -- inout
            return -(math.cos(math.pi * Alpha) - 1) / 2;
        end,
    },
    [2] = { -- Elastic 
        [0] = function(Alpha) -- in
            local c4 = (2 * math.pi) / 3;
            return Alpha == 0 and 0 or Alpha == 1 and 1 or -math.pow(2, 10 * Alpha - 10) * math.sin((Alpha * 10 - 10.75) * c4);
        end,
        [1] = function(Alpha) -- out
            local c4 = (2 * math.pi) / 3;

            return Alpha == 0 and 0 or Alpha == 1 and 1 or math.pow(2, -10 * Alpha) * math.sin((Alpha * 10 - 0.75) * c4) + 1;
        end,
        [2] = function(Alpha) -- inout
            local c5 = (2 * math.pi) / 4.5;

            return Alpha == 0 and 0 or Alpha == 1 and 1 or Alpha < 0.5 and -(math.pow(2, 20 * Alpha - 10) * math.sin((20 * Alpha - 11.125) * c5)) / 2 or (math.pow(2, -20 * Alpha + 10) * math.sin((20 * Alpha - 11.125) * c5)) / 2 + 1;
        end,
    },
};

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
            -- The Indexs of PropertyTable must be directly castabe to the Index of Object.__Attributes
            if not Object then return end;
            error("Unable to cast " .. _ .. " to " .. tostring(Object));
            break;
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

return Tween;