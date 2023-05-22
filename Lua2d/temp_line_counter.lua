-- TEMPORARY FILE SO I CAN KEEP TRACK OF LINES IVE WRITTEN

function scandir(directory)
    local i, t, popen = 0, {}, io.popen
    local pfile = popen('dir "'..directory..'" /b ')
    for filename in pfile:lines() do
        i = i + 1
        t[i] = filename
    end
    pfile:close()
    return i == 0 and 1 or t;
end

local Lines = 0;

Loop__Through__Directory = function(Directory)
    local Found = scandir(Directory);
    if Found ~= 1 then
        for _,File in pairs(Found) do 
            Loop__Through__Directory(Directory .. "/" .. File);
        end
        return;
    end
    local File = io.open(Directory);
    if File then 
        local lines = File:lines();
        for _,line in lines do 
            Lines = Lines + 1;
        end 
        File:close();
     end
end

Loop__Through__Directory(".");

local File = io.open("main.lua");
    if File then 
        local lines = File:lines();
        for _,line in lines do 
            Lines = Lines + 1;
        end 
        File:close();
     end
     local File = io.open("editor.lua");
    if File then 
        local lines = File:lines();
        for _,line in lines do 
            Lines = Lines + 1;
        end 
        File:close();
     end

print("Total Lines: " .. Lines)