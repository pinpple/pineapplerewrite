local ids = {
    [71480482338212] = 'BedwarZ.lua'
}

local function downloadFile(file)
    url = file:gsub('pineapple/', '')
    if not isfile(file) then
        writefile(file, game:HttpGet('https://raw.githubusercontent.com/pinpple/pineapplerewrite/'..readfile('pineapple/commit.txt')..'/'..url))
    end

    repeat task.wait() until isfile(file)
    return readfile(file)
end

for i,v in ids do
    if i == game.PlaceId then
        return loadstring(downloadFile('pineapple/games/'..v))()
    end
end

return loadstring(downloadFile('pineapple/games/universal.lua'))()