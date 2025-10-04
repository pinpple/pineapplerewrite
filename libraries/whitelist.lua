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

Library.Connections['Text'] = function(msg)
	local Properties = Instance.new('TextChatMessageProperties')
	
	if msg.TextSource then
        local Player = msg.TextSource.UserId
        local plr = playersService:GetPlayerByUserId(msg.TextSource.UserId)

        if wl.Whitelisted[Player] then
            Properties.PrefixText = string.format('<font color="#%s">[%s]</font> %s:%s', wl.Whitelisted[Player].Color:ToHex(), wl.Whitelisted[Player].Text, plr.DisplayName, Properties.PrefixText)
        end
    end

    return Properties
end

textChatService.OnIncomingMessage = Library.Connections['Text']