repeat task.wait() until getgenv().Library

local cloneref = cloneref or function(obj)
    return obj
end
local textChatService = cloneref(game:GetService('TextChatService'))
local playersService = cloneref(game:GetService('Players'))
local Library = getgenv().Library

local wl = {
    Whitelisted = {
        ['FireantlikesLilG04L2'] = {
            Text = 'Legitimate User',
            Color = Color3.fromRGB(255, 255, 255)
        }
    }
}

textChatService.OnIncomingMessage = function(msg: TextChatMessage): TextChatMessageProperties
    local Properties = Instance.new("TextChatMessageProperties")

    if msg.TextSource then
        local plr = playersService:GetPlayerByUserId(msg.TextSource.UserId)

        if wl.Whitelisted[plr] then
            Properties.PrefixText = string.format('<font color="#%s">[%s]</font> %s:', wl.Whitelisted[plr].Color:ToHex(), wl.Whitelisted[plr].Text, wl.Whitelisted[plr].DisplayName)
        end
    end

    return Properties
end