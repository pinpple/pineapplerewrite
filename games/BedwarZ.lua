local cloneref = cloneref or function(obj)
    return obj
end

local runService = cloneref(game:GetService('RunService'))
local playersService = cloneref(game:GetService('Players'))
local replicatedStorage = cloneref(game:GetService('ReplicatedStorage'))
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
				end)
            else
                if VeloConn then
                    VeloConn:Disconnect()
                    VeloConn = nil
                end
            end
        end
    })
end

do
    local AuraSec = SubPages.Combat.Player:Section({Name = 'Killaura', Icon = '16095745392', Side = 2})

    local Aura, AuraConn
    local Range = 18
    local Item = false
    Aura = AuraSec:Toggle({
        Name = 'Killaura',
        Flag = 'Aura',
        Callback = function(callback)
            if callback then
                Library:Connect(runService.PreSimulation, function()
                    local plr = entity.getClosestEntity(Library.Flags['Range'])

                    if plr then
                        task.spawn(function()
                            for _, v in getItem('Swords', 'table') do
                                if Library.Flags['Item'] == true and not getItem('Swords', 'tog') then
                                    continue
                                end

                                replicatedStorage.Remotes.ItemRemotes.SwordHit:FireServer(v, plr.Character)
                            end
                        end)
                    end
                end)
            end
        end
    })
    AuraSec:Slider({
        Name = 'Range',
        Flag = 'Range',
        Min = 0,
        Max = 18,
        Default = 18,
        Decimals = 1,
        Callback = function(val)
            Range = val
        end
    })
    AuraSec:Toggle({
        Name = 'Hand check',
        Flag = 'Item',
        Callback = function(callback)
            Item = callback
        end
    })
end

Library:Notification('Pineapple loaded', 5, '14225167795')