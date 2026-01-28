local v_u_1 = game:GetService("Players").LocalPlayer.PlayerScripts.UserInterface:WaitForChild("DuelScoresChatBubble")
local v_u_2 = {}
v_u_2.__index = v_u_2
function v_u_2.new(p3)
    local v4 = v_u_2
    local v5 = setmetatable({}, v4)
    v5.Scores = p3
    v5._chat_bubble_layout_order = 0
    v5._chat_messages = {}
    v5:_Init()
    return v5
end
function v_u_2.NewChatMessage(p_u_6, p7, p8)
    p_u_6._chat_bubble_layout_order = p_u_6._chat_bubble_layout_order + 1
    local v_u_9 = v_u_1:Clone()
    v_u_9.ZIndex = -p_u_6._chat_bubble_layout_order
    v_u_9.LayoutOrder = p_u_6._chat_bubble_layout_order
    v_u_9.Title.Text = p8
    local function v10()
        v_u_9.Background.Size = UDim2.new(0.125, v_u_9.Title.TextBounds.X, 1, 0)
    end
    v_u_9.Title:GetPropertyChangedSignal("TextBounds"):Connect(v10)
    v_u_9.AncestryChanged:Connect(v10)
    v_u_9.Background.Size = UDim2.new(0.125, v_u_9.Title.TextBounds.X, 1, 0)
    local v_u_11 = {
        ["Player"] = p7,
        ["Frame"] = v_u_9
    }
    local v12 = p_u_6._chat_messages
    table.insert(v12, 1, v_u_11)
    p_u_6:_UpdateParent(v_u_11)
    local v13 = 0
    for v14, v15 in pairs(p_u_6._chat_messages) do
        if v15.Player == p7 then
            v13 = v13 + 1
            if v13 > 4 then
                v15.Frame:Destroy()
                table.remove(p_u_6._chat_messages, v14)
                break
            end
        end
    end
    task.delay(7, function()
        v_u_9:Destroy()
        local v16 = table.find(p_u_6._chat_messages, v_u_11)
        if v16 then
            table.remove(p_u_6._chat_messages, v16)
        end
    end)
end
function v_u_2.Hide(p17)
    for _, v18 in pairs(p17._chat_messages) do
        v18.Frame.Parent = nil
    end
end
function v_u_2.Show(p19)
    for _, v20 in pairs(p19._chat_messages) do
        p19:_UpdateParent(v20)
    end
end
function v_u_2.Destroy(p21)
    for _, v22 in pairs(p21._chat_messages) do
        v22.Frame:Destroy()
    end
    p21._chat_messages = {}
end
function v_u_2._UpdateParent(p23, p24)
    p24.Frame.Parent = p23.Scores:GetChatBubbleContainer(p24.Player)
end
function v_u_2._Init(_) end
return v_u_2