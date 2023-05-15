local ThreadObject = {};
ThreadObject.__index = ThreadObject;

function ThreadObject:Wait(WaitTime)
    local Start = os.clock();
    self.Suspended = true;
    if WaitTime == nil then 
        self.WaitTime = Start;
        return coroutine.yield();
    end
    self.WaitTime = Start+WaitTime/1000;
    coroutine.yield();
end

function ThreadObject:Loop(...)
    self.Looping = true;
    self.Coroutine = coroutine.create(self.Function);
    return coroutine.resume(self.Coroutine,self,...);
end

function ThreadObject:Pause(...)
    self.Looping = false;
    coroutine.close(self.Coroutine);
end

function ThreadObject:Play(...)
    self.Coroutine = self.Coroutine or coroutine.create(self.Function);
    return coroutine.resume(self.Coroutine,self,...);
end

function ThreadObject:Close()
    rawset(taskr.Threads, self.ID, nil);
end

taskr = {
    new = function(Func)
        local Size = #taskr.Threads + 1;
        taskr.Threads[Size] = setmetatable({
            ID = Size;
            Function = Func,
            Coroutine = coroutine.create(Func),
        },ThreadObject);
        return taskr.Threads[Size];
    end,
    Update = function()
        for _, Thread in pairs(taskr.Threads) do
            if Thread.Suspended then
                if Thread.WaitTime <= os.clock() then
                    Thread.Suspended = false;
                    coroutine.resume(Thread.Coroutine,Thread);  
                end
            elseif coroutine.status(Thread.Coroutine) == "dead" then 
                if Thread.Looping then
                    Thread.Coroutine = coroutine.create(Thread.Function);
                    coroutine.resume(Thread.Coroutine,Thread); 
                else 
                    taskr.Threads[_] = nil;
                end
            end
        end
    end,
    Threads = {},
};
	
return taskr;