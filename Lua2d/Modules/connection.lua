
local instance__Connection = {};
instance__Connection.__index = instance__Connection;

function instance__Connection:Disconnect()
	table.remove(self.__Connector.__Connections,self.ID);
	self = nil;
end

function instance__Connection:Pause()
	self.__Firing = false;
end 

function instance__Connection:Play()
	self.__Firing = true;
end

local class__Connection = {};
class__Connection.__index = class__Connection;

function class__Connection:Connect(Func)
	self.Size = self.Size + 1;
	self.__Connections[self.Size] = setmetatable({
		ID = self.Size,
		Function = Func,	
		__Firing = true,
		__Connector = self;
	},instance__Connection);
	return setmetatable({},{
		__index = self.__Connections[self.Size],
		__newindex = function(self, Index, Value)
			error("Connections are read only. Use :Play(),:Pause(), or :Disconnect()");
		end,
	});
end

function class__Connection:Once(Func)
	local l__evnt = self:Connect(Func);
	thread(function(Thread)
		self:Wait(Thread);
		l__evnt:Disconnect();
		thread:Close();
	end):Play();
	return l__evnt;
end

function class__Connection:Wait(Thread)
    self.__Waiting = true;
    if Thread then 
        repeat 
            Thread:Wait();
        until self.__Waiting == false;
        return;
    end
    repeat
    until self.__Waiting == false;
    return; 
end

function class__Connection:Fire(...)
    self.__Waiting = false;
	for _,Connection in pairs(self.__Connections) do 
		if Connection.__Firing then 
			Connection.Function(Connection,...);
		end
	end
end

local Connections = {};

local NO_ID_INDEX = 0;
local Connections_Module = {
	waitForConnection = function(ID)
		local Limit = os.clock()+10;
		repeat 
			if Connections[ID] then
				return Connections[ID];
			end
		until os.clock() > Limit;
		error("Possible infinite yield for Connection (" .. ID .. ")", debug.traceback());
		return {};
	end,
	getConnection = function(ID)
		if not (ID and Connections[ID]) then error("Connection ("..ID..") not found", debug.traceback()) return end;
		return Connections[ID];
	end,
	createConnection = function(ID)
		if not ID then 
            NO_ID_INDEX = NO_ID_INDEX + 1;
            ID = NO_ID_INDEX;
        end
		if Connections[ID] then error("Connection (" .. ID .. ") already exists", debug.traceback()) return end;
		Connections[ID] = setmetatable({
			Size = 0,
			__Connections = {},	
		},class__Connection);
		return Connections[ID];
	end,	
};

return Connections_Module;