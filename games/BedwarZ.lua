local cloneref = cloneref or function(obj)
    return obj
end

local Library = loadfile('pineapple/gui/interface.lua')
local Window = Library:Window({Name = 'Pineapple'})
Window:Category('Main')

Window:Category('Settings')
local SettingsPage = Library:CreateSettingsPage(Window)

Library:Notification('Pineapple loaded', 5, '14225167795')