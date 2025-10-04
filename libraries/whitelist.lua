repeat task.wait() until getgenv().Library

local cloneref = cloneref or function(obj)
    return obj
end
local textChatService = cloneref(game:GetService('TextChatService'))
local playersService = cloneref(game:GetService('Players'))
local Library = getgenv().Library

local wl = {
    Whitelisted = {
        [9642263838] = {
            Text = 'Legitimate User',
            Color = Color3.fromRGB(255, 255, 255)
        }
    }
}

textChatService.OnIncomingMessage = function(msg: TextChatMessage): TextChatMessageProperties
    local Properties = Instance.new("TextChatMessageProperties")

    if msg.TextSource then
        local plr = playersService:GetPlayerByUserId(msg.TextSource.UserId)

        if wl.Whitelisted[msg.TextSource.UserId] and plr then
            Properties.PrefixText = string.format('<font color="#%s">[%s]</font> %s:', wl.Whitelisted[msg.TextSource.UserId].Color:ToHex(), wl.Whitelisted[msg.TextSource.UserId].Text, plr.DisplayName)
        end
    end

    return Properties
end