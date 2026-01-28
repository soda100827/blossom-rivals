local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("CollectionService")
local v_u_3 = game:GetService("Players")
local v_u_4 = require(v1.Modules.Utility)
local v_u_5 = require(v_u_3.LocalPlayer.PlayerScripts.Modules.LobbyElement)
local v_u_6 = require(v_u_3.LocalPlayer.PlayerScripts.Modules.RewardSlot)
local v_u_7 = v_u_3.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("LikeBoardGui")
local v_u_8 = setmetatable({}, v_u_5)
v_u_8.__index = v_u_8
function v_u_8._new(...)
    local v9 = v_u_5.new(...)
    local v10 = v_u_8
    local v11 = setmetatable(v9, v10)
    v11:_Init()
    return v11
end
function v_u_8._BoardAdded(_, p_u_12)
    local v_u_13 = v_u_7:Clone()
    local v_u_14 = nil
    local function v25()
        if v_u_14 then
            v_u_14:Destroy()
            v_u_14 = nil
        end
        local v15 = p_u_12:GetAttribute("Loaded")
        local v16 = p_u_12:GetAttribute("CurrentLikes") or 0
        local v17 = p_u_12:GetAttribute("GoalLikes") or 0
        local v18 = p_u_12:GetAttribute("LastGoalLikes") or 0
        local v19 = p_u_12:GetAttribute("CurrentMilestone") or 0
        local v20 = p_u_12:GetAttribute("KeyQuantity") or 0
        local v21 = p_u_12:GetAttribute("Code") or ""
        local v22 = (v16 - v18) / (v17 - v18)
        v_u_13.MainFrame.Progress.Current.Text = v_u_4:PrettyNumber(v16)
        v_u_13.MainFrame.Progress.Goal.Text = v_u_4:PrettyNumber(v17)
        v_u_13.MainFrame.Progress.Bar.Bar.Size = UDim2.new(math.clamp(v22, 0, 1), 0, 1, 0)
        local v23 = v_u_13.MainFrame.Progress.Percent
        local v24 = v22 * 100
        v23.Text = math.floor(v24) .. "%"
        v_u_13.MainFrame.Code.Text = string.upper(v21)
        v_u_13.MainFrame.Description.Visible = v19 > 0
        v_u_13.MainFrame.Visible = v15
        v_u_13.Waiting.Visible = not v15
        if v_u_13.Waiting.Visible then
            v_u_13.Waiting.Dots:AddTag("UILoadingDots")
        else
            v_u_13.Waiting.Dots:RemoveTag("UILoadingDots")
        end
        if v19 > 0 then
            v_u_14 = v_u_6.new({
                ["Name"] = "Key",
                ["Quantity"] = v20
            })
            v_u_14:SetParent(v_u_13.MainFrame.Reward)
        end
    end
    p_u_12:GetAttributeChangedSignal("CurrentLikes"):Connect(v25)
    p_u_12:GetAttributeChangedSignal("GoalLikes"):Connect(v25)
    p_u_12:GetAttributeChangedSignal("LastGoalLikes"):Connect(v25)
    p_u_12:GetAttributeChangedSignal("CurrentMilestone"):Connect(v25)
    p_u_12:GetAttributeChangedSignal("KeyQuantity"):Connect(v25)
    p_u_12:GetAttributeChangedSignal("Code"):Connect(v25)
    v25()
    v_u_13.Adornee = p_u_12
    v_u_13.Parent = v_u_3.LocalPlayer.PlayerGui
end
function v_u_8._Init(p_u_26)
    v_u_2:GetInstanceAddedSignal("LobbyLikeBoard"):Connect(function(p27)
        p_u_26:_BoardAdded(p27)
    end)
    for _, v28 in pairs(v_u_2:GetTagged("LobbyLikeBoard")) do
        task.defer(p_u_26._BoardAdded, p_u_26, v28)
    end
end
return v_u_8._new()