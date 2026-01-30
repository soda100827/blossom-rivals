local v_u_1 = require(script:WaitForChild("ChatBubbles"))
local v_u_2 = require(script:WaitForChild("Duelers"))
local v_u_3 = require(script:WaitForChild("Teams"))
local v_u_4 = {}
v_u_4.__index = v_u_4
function v_u_4.new(p5)
    local v6 = v_u_4
    local v7 = setmetatable({}, v6)
    v7.DuelInterface = p5
    v7.Frame = v7.DuelInterface.Frame:WaitForChild("Top"):WaitForChild("Scores")
    v7.ChatBubbles = v_u_1.new(v7)
    v7.Duelers = v_u_2.new(v7)
    v7.Teams = v_u_3.new(v7)
    v7._is_visible = true
    v7:_Init()
    return v7
end
function v_u_4.GetChatBubbleContainer(p8, p9)
    return p8.Duelers:GetChatBubbleContainer(p9) or p8.Teams:GetChatBubbleContainer(p9)
end
function v_u_4.SetVisible(p10, p11)
    p10._is_visible = p11
    p10:UpdateVisibility()
end
function v_u_4.UpdateVisibility(p12)
    local v13 = p12.Frame
    local v14 = p12._is_visible and not p12.DuelInterface:IsPageOpen()
    if v14 then
        v14 = not p12.DuelInterface.ClientDuel:Get("HideMostDuelInterfaceElements")
    end
    v13.Visible = v14
end
function v_u_4.NewChatMessage(p15, ...)
    p15.ChatBubbles:NewChatMessage(...)
end
function v_u_4.Generate(p16)
    p16.ChatBubbles:Hide()
    p16.Duelers:Generate()
    p16.Teams:Generate()
    p16.ChatBubbles:Show()
end
function v_u_4.Destroy(p17)
    p17.ChatBubbles:Destroy()
    p17.Duelers:Destroy()
    p17.Teams:Destroy()
end
function v_u_4._Init(_) end
return v_u_4