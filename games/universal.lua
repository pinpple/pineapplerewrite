local cloneref = cloneref or function(obj)
    return obj
end

local runService = cloneref(game:GetService('RunService'))
local playersService = cloneref(game:GetService('Players'))
local replicatedStorage = cloneref(game:GetService('ReplicatedStorage'))
local inputService = cloneref(game:GetService('UserInputService'))
local lplr = playersService.LocalPlayer

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

local Pages = {
    Combat = Window:Page({Name = 'Combat', Icon = '16095745392'}),
    Player = Window:Page({Name = 'Player', Icon = '136879043989014'}),
    Render = Window:Page({Name = 'Render', Icon = '11963367322'})
}

Window:Category('Settings')
Library:CreateSettingsPage(Window)

local SubPages = {
    Combat = {
        Player = Pages.Combat:SubPage({Name = 'Player'})
    },
    Player = {
        Movement = Pages.Player:SubPage({Name = 'Movement'})
    },
    Render = {
        Self = Pages.Render:SubPage({Name = 'Self'}),
        Enemies = Pages.Render:SubPage({Name = 'Enemies'})
    }
}

-- Functions

do
    local SpeedSec = SubPages.Player.Movement:Section({Name = 'Speed', Icon = '136879043989014', Side = 1})

    local Speed
    Speed = SpeedSec:Toggle({
        Name = 'Speed',
        Flag = 'Speed',
        Callback = function(callback)
            if callback then
                Library:Connect(runService.PreSimulation, function(delta)
                    if entity.isAlive(lplr) then
                        local speedVal = (Library.Flags['SpeedVal'] - lplr.Character.Humanoid.WalkSpeed)
                        lplr.Character.PrimaryPart.CFrame += (lplr.Character.Humanoid.MoveDirection * speedVal * delta)
                    end
                end, 'Speed')
            else
                task.spawn(function()
                    Library:Disconnect('Speed')
                end)
            end
        end
    })
    SpeedSec:Slider({
        Name = 'Speed',
        Flag = 'SpeedVal',
        Min = 0,
        Max = 150,
        Default = 16,
        Decimals = 1
    })
end

do
    local RenderSec = SubPages.Render.Self:Section({Name = 'FOV', Icon = '11963367322', Side = 1})

    local oldFOV, FOV = workspace.CurrentCamera.FieldOfView
    FOV = RenderSec:Toggle({
        Name = 'FOV',
        Flag = 'FOV',
        Callback = function(callback)
            if callback then
                oldFOV = workspace.CurrentCamera.FieldOfView
                Library:Connect(runService.RenderStepped, function()
                    workspace.CurrentCamera.FieldOfView = Library.Flags['FOVVal']
                end, 'FOV')
            else
                task.spawn(function()
                    Library:Disconnect('FOV')
                end)
                workspace.CurrentCamera.FieldOfView = oldFOV
            end
        end
    })
    RenderSec:Slider({
        Name = 'FOV',
        Flag = 'FOVVal',
        Min = 30,
        Max = 120,
        Default = 120,
        Decimals = 1
    })
end

Library:Notification('Pineapple loaded', 5, '14225167795')