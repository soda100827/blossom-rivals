local v_u_1 = game:GetService("TextChatService")
local v_u_2 = game:GetService("StarterGui")
local v3 = game:GetService("Players")
local v_u_4 = require(v3.LocalPlayer.PlayerScripts.Controllers:WaitForChild("ComplianceController"))
local v_u_5
if v_u_1.ChatVersion == Enum.ChatVersion.TextChatService then
    v_u_5 = Instance.new("TextChannel")
    v_u_5.Name = "ServerMessageChannel"
    v_u_5.Parent = v_u_1:WaitForChild("TextChannels")
    function v_u_5.OnIncomingMessage(p6)
        local v7 = Instance.new("TextChatMessageProperties")
        local v8 = p6.Text
        local v9 = p6.Metadata
        if v9 then
            v8 = v9 .. v8 .. "</font>"
        end
        v7.Text = v8
        return v7
    end
else
    v_u_5 = nil
end
return function(p10)
    local v11 = typeof(p10) == "table"
    local v12 = "Argument 1 invalid, expected a table, got " .. tostring(p10)
    assert(v11, v12)
    if v_u_4:IsChina() then
        return
    elseif v_u_1.ChatVersion == Enum.ChatVersion.LegacyChatService then
        p10.Text = p10.Text or string.rep("?", 16)
        p10.Color = p10.Color or Color3.fromRGB(0, 0, 0)
        p10.Font = p10.Font or Enum.Font.GothamMedium
        p10.TextSize = p10.TextSize or 14
        v_u_2:SetCore("ChatMakeSystemMessage", p10)
    else
        p10.Text = p10.Text or "???????????????????????????????????????????????????????????"
        p10.Font = p10.Font or Enum.Font.GothamBold
        p10.TextSize = p10.TextSize or 14
        local v13 = p10.Color
        local v14 = typeof(v13) == "Color3" and p10.Color
        if not v14 then
            local v15 = p10.Color
            if typeof(v15) == "string" then
                v14 = Color3.fromHex(p10.Color)
            else
                v14 = false
            end
        end
        p10.Color = v14
        Color3.new()
        local v16 = "<font"
        if p10.Color then
            local v17 = p10.Color.R * 255
            local v18 = math.floor(v17)
            local v19 = p10.Color.G * 255
            local v20 = math.floor(v19)
            local v21 = p10.Color.B * 255
            v16 = v16 .. " color=\"rgb(" .. v18 .. "," .. v20 .. "," .. math.floor(v21) .. ")\""
        end
        if p10.Font then
            local v22 = p10.Font
            local v23
            if typeof(v22) == "EnumItem" then
                v23 = p10.Font.Name
            else
                local v24 = p10.Font
                v23 = tostring(v24)
            end
            v16 = v16 .. " face=\"" .. v23 .. "\""
        end
        if p10.TextSize then
            v16 = v16 .. " size=\"" .. p10.TextSize .. "\""
        end
        local v25 = v16 .. ">"
        v_u_5:DisplaySystemMessage(p10.Text, v25)
    end
end