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

local items
do
	items = {
		Melee = {'Wooden Sword', 'Stone Sword', 'Iron Sword', 'Diamond Sword', 'Emerald Sword'},
		Pickaxes = {'Wooden Pickaxe', 'Stone Pickaxe', 'Iron Pickaxe', 'Diamond Pickaxe'}
	}
end

local function hasTool(v)
    return lplr.Backpack and lplr.Backpack:FindFirstChild(v)
end

local function getTool(tool: string): string?
	return workspace.PlayersContainer:FindFirstChild(lplr.Name):FindFirstChild(tool)
	--return lplr.Character and lplr.Character:FindFirstChildWhichIsA('Tool', true) or nil
end

local function getItem(type, returnval)
	local tog = {}
	if not returnval then
		error('No return value')
	end

	for i, v in items[type] do 
		local tool = getTool(v)
		if entity.isAlive(lplr) then
			if returnval == 'tog' and tool then
				return true
			elseif returnval == 'table' and (hasTool(v) or tool) then
				tog[i] = v
			end
		end
	end

	if returnval == 'tog' then
		return false
	end

	return tog
end

-- Velocity
do
    local VeloSec = SubPages.Combat.Player:Section({Name = 'Velocity', Icon = '136879043989014', Side = 1})

    local Velocity, VeloConn
    Velocity = VeloSec:Toggle({
        Name = 'Velocity',
        Flag = 'Velo',
        Callback = function(callback)
            if callback then
                for i,v in replicatedStorage.Modules.VelocityUtils:GetChildren() do
					v:Destroy()
				end

				Library:Connect(replicatedStorage.Modules.VelocityUtils.ChildAdded, function(obj)
					obj:Destroy()
				end, 'Velo')
            else
                Library:Disconnect('Velo')
            end
        end
    })
end

do
    local AuraSec = SubPages.Combat.Player:Section({Name = 'Killaura', Icon = '16095745392', Side = 2})

    local Aura, Anim
    local Delay = tick()
    Aura = AuraSec:Toggle({
        Name = 'Killaura',
        Flag = 'Aura',
        Callback = function(callback)
            if callback then
                Anim = Instance.new('Animation')
                Anim.AnimationId = 'rbxassetid://123800159244236'
                Library:Connect(runService.PreSimulation, function()
                    local plr = entity.getClosestEntity(Library.Flags['Range'])

                    if plr then
                        task.spawn(function()
                            for _, v in getItem('Melee', 'table') do
                                if Library.Flags['Item'] == true and not getItem('Melee', 'tog') then
                                    continue
                                end

                                if Delay <= tick() then
                                    Delay = tick() + 0.2

                                    if Library.Flags['Swing'] == true and getItem('Melee', 'tog') then
                                        lplr.Character.Humanoid.Animator:LoadAnimation(Anim):Stop()
                                        lplr.Character.Humanoid.Animator:LoadAnimation(Anim):Play()
                                    end

                                    if Library.Flags['Face'] == true then
                                        lplr.Character.PrimaryPart.CFrame = CFrame.lookAt(lplr.Character.PrimaryPart.Position, Vector3.new(plr.Character.PrimaryPart.Position.X, plr.Character.PrimaryPart.Position.Y + 0.001, plr.Character.PrimaryPart.Position.Z))
                                    end

                                    replicatedStorage.Remotes.ItemsRemotes.SwordHit:FireServer(v, plr.Character)
                                end
                            end
                        end)
                    end
                end, 'Aura')
            else
                Library:Disconnect('Aura')
            end
        end
    })
    AuraSec:Slider({
        Name = 'Range',
        Flag = 'Range',
        Min = 0,
        Max = 18,
        Default = 18,
        Decimals = 1
    })
    AuraSec:Toggle({
        Name = 'Face target',
        Flag = 'Face'
    })
    AuraSec:Toggle({
        Name = 'Swing',
        Flag = 'Swing'
    })
    AuraSec:Toggle({
        Name = 'Hand check',
        Flag = 'Item'
    })
end

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
                Library:Disconnect('Speed')
            end
        end
    })
    SpeedSec:Slider({
        Name = 'Speed',
        Flag = 'SpeedVal',
        Min = 0,
        Max = 23,
        Default = 23,
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
                Library:Disconnect('FOV')
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

Library:Notification('Pineapple loaded', 7, '14225167795')