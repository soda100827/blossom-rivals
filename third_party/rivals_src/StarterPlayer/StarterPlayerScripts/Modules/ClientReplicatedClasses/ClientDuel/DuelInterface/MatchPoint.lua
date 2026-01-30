local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = require(v1.Modules.Utility)
local v_u_3 = {}
v_u_3.__index = v_u_3
function v_u_3.new(p4)
    local v5 = v_u_3
    local v6 = setmetatable({}, v5)
    v6.DuelInterface = p4
    v6.Frame = v6.DuelInterface.Frame:WaitForChild("Top"):WaitForChild("MatchPoint")
    v6.Background = v6.Frame:WaitForChild("Background")
    v6.Title = v6.Frame:WaitForChild("Title")
    v6._destroyed = false
    v6._match_point_hash = 0
    v6:_Init()
    return v6
end
function v_u_3.Play(p_u_7, p8)
    p_u_7._match_point_hash = p_u_7._match_point_hash + 1
    if not p_u_7.DuelInterface.ClientDuel:Get("MatchPointVisualDisabled") then
        local v_u_9 = p_u_7._match_point_hash
        p_u_7.DuelInterface:CreateSound(p8 and "rbxassetid://17467242617" or "rbxassetid://17026600996", p8 and 1.5 or 1, 1, script, true, 15)
        p_u_7.DuelInterface.Timer:SetVisible(false)
        p_u_7.DuelInterface.Scores:SetVisible(false)
        p_u_7.Frame.Visible = true
        p_u_7.Frame.GroupTransparency = 0
        p_u_7.Frame.Position = UDim2.new(0.5, 0, 0.02, 5)
        p_u_7.Background.Size = p8 and UDim2.new(0.66, 0, 0.5, 0) or UDim2.new(0.6, 0, 0.5, 0)
        p_u_7.Title.Text = p8 and "SUDDEN DEATH" or "MATCH POINT"
        p_u_7:_UpdateTextBounds()
        p_u_7.Frame:TweenPosition(UDim2.new(0.5, 0, 0.0425, 10), "Out", "Quint", 2, true, function()
            v_u_2:RenderstepForLoop(0, 100, 2, function(p10)
                if v_u_9 ~= p_u_7._match_point_hash then
                    return true
                end
                p_u_7.Frame.GroupTransparency = 1 - (1 - p10 / 100) ^ 4
            end)
            if v_u_9 == p_u_7._match_point_hash then
                p_u_7.DuelInterface.Timer:SetVisible(true)
                p_u_7.DuelInterface.Scores:SetVisible(true)
                p_u_7.Frame.Visible = false
            end
        end)
    end
end
function v_u_3.Destroy(p11)
    p11._destroyed = true
    p11._match_point_hash = p11._match_point_hash + 1
end
function v_u_3._UpdateTextBounds(p12)
    p12.Background.Size = UDim2.new(0.1, p12.Title.TextBounds.X, 0.5, 0)
end
function v_u_3._Init(p_u_13)
    p_u_13.Title:GetPropertyChangedSignal("TextBounds"):Connect(function()
        p_u_13:_UpdateTextBounds()
    end)
    p_u_13:_UpdateTextBounds()
end
return v_u_3