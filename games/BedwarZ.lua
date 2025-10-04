local cloneref = cloneref or function(obj)
    return obj
end

local function downloadFile(file)
    url = file:gsub('pineapple/', '')
    if not isfile(file) then
        writefile(file, game:HttpGet('https://raw.githubusercontent.com/pinpple/pineapplerewrite/'..readfile('pineapple/commit.txt')..'/'..url))
    end

    repeat task.wait() until isfile(file)
    return readfile(file)
end

local Library = loadfile('pineapple/gui/interface.lua')()
local entity = loadstring(downloadFile('pineapple/libraries/entity.lua'))()

local Window = Library:Window({Name = 'Pineapple'})
Window:Category('Main')

local CombatPage = Window:Page({Name = 'Combat', Icon = "16095745392"})
local PlayerPage = Window:Page({Name = 'Player', Icon = "136879043989014"})
local RenderPage = Window:Page({Name = 'Render', Icon = "11963367322"})

Window:Category('Settings')
local SettingsPage = Library:CreateSettingsPage(Window)

Library:Notification('Pineapple loaded', 5, '14225167795')