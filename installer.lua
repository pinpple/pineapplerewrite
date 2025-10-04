local cloneref = cloneref or function(obj)
    return obj
end
local httpService = cloneref(game:GetService('HttpService'))

local function wipeFolders()
    for _, v in {'pineapple', 'pineapple/games', 'pineapple/gui'} do
        if isfolder(v) then
            for x, d in listfiles(v) do
                if string.find(d, 'commit.txt') then continue end
                
                if not isfolder(d) then
                    delfile(d)
                end
            end
        end
    end
end

local function downloadFile(file, read)
    url = file:gsub('pineapple/', '')
    if not isfile(file) then
        writefile(file, game:HttpGet('https://raw.githubusercontent.com/pinpple/pineapplerewrite/'..readfile('pineapple/commit.txt')..'/'..url))
    end

    if read ~= nil and read == false then
        return
    end

    repeat task.wait() until isfile(file)
    return readfile(file)
end

for _, v in {'pineapple', 'pineapple/games', 'pineapple/gui', 'pineapple/assets', 'pineapple/configs', 'pineapple/libraries'} do
    if not isfolder(v) then
        makefolder(v)
    end
end

local commit = httpService:JSONDecode(game:HttpGet('https://api.github.com/repos/pinpple/pineapplerewrite/commits'))[1].sha
if not isfile('pineapple/commit.txt') then
    writefile('pineapple/commit.txt', commit)
elseif readfile('pineapple/commit.txt') ~= commit then
    wipeFolders()
    writefile('pineapple/commit.txt', commit)
end

repeat task.wait() until isfile('pineapple/commit.txt')

downloadFile('pineapple/gui/interface.lua', false)
loadstring(downloadFile('pineapple/main.lua'))()