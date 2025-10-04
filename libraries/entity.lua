local cloneref = cloneref or function(obj)
    return obj
end
local playersService = cloneref(game:GetService('Players'))
local lplr = playersService.LocalPlayer

local function teamCheck(v)
    if not v.Team then return true end
    if tostring(lplr.Team) == 'Spectators' and tostring(v.Team) == 'Spectators' then return true end
    if lplr.Team == v.Team then return false end

    return true
end

local entity = {}

entity.isAlive = function(plr)
    local suc, res = pcall(function()
        return plr.Character:FindFirstChildOfClass('Humanoid')
    end)

    return suc and res and res.Health > 0
end

entity.getClosestEntity = function(RANGE)
    local closestEntity, closestDist = nil, math.huge

    if not entity.isAlive(lplr) then
        return nil
    end

    for i,v in playersService:GetPlayers() do
        if v == lplr then continue end
        if not entity.isAlive(v) then continue end

        local DIST = lplr:DistanceFromCharacter(v.Character.PrimaryPart.Position)
        if entity.isAlive(v) and (DIST <= RANGE and DIST <= closestDist) and teamCheck(v) and lplr:GetAttribute('PVP') then
            closestEntity = v
            closestDist = DIST
        end
    end

    return closestEntity
end

return entity