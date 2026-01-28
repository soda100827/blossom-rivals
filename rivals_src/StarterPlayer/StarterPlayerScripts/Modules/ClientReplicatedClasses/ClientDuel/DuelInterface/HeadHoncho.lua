local v1 = game:GetService("ReplicatedStorage")
game:GetService("Players")
local v_u_2 = require(v1.Modules.DuelLibrary)
local v_u_3 = {}
v_u_3.__index = v_u_3
function v_u_3.new(p4)
    local v5 = v_u_3
    local v6 = setmetatable({}, v5)
    v6.DuelInterface = p4
    v6.Frame = v6.DuelInterface.Frame:WaitForChild("HeadHoncho")
    v6.Container = v6.Frame:WaitForChild("Container")
    v6.HeadHonchoFrame = v6.Container:WaitForChild("HeadHoncho")
    v6.HeadHonchoBackground = v6.HeadHonchoFrame:WaitForChild("Background")
    v6.BodyguardFrame = v6.Container:WaitForChild("Bodyguard")
    v6.BodyguardBackground = v6.BodyguardFrame:WaitForChild("Background")
    v6:_Init()
    return v6
end
function v_u_3.Update(p7)
    local v8 = not (p7.DuelInterface.Scoreboard:IsOpen() or (p7.DuelInterface.Voting:IsOpen() or p7.DuelInterface:IsPageOpen()))
    if v8 then
        v8 = not p7.DuelInterface.RoundResult.Frame.Visible
    end
    local v9
    if p7.DuelInterface.ClientDuel.LocalDueler then
        v9 = p7.DuelInterface.ClientDuel.LocalDueler:Get("IsHeadHoncho")
    else
        v9 = nil
    end
    local v10 = v_u_2
    local v11 = p7.DuelInterface.ClientDuel.LocalDueler
    if v11 then
        v11 = p7.DuelInterface.ClientDuel.LocalDueler:Get("TeamID")
    end
    local v12 = v10:GetTeamColor(v11)
    local v13 = p7.Frame
    if v8 then
        v8 = p7.DuelInterface.ClientDuel:Get("Status") ~= "GameOver"
    end
    v13.Visible = v8
    p7.HeadHonchoFrame.Visible = v9 == true
    p7.BodyguardFrame.Visible = v9 == false
    p7.HeadHonchoBackground.ImageColor3 = v12
    p7.BodyguardBackground.ImageColor3 = v12
end
function v_u_3.Destroy(_) end
function v_u_3._Init(p_u_14)
    p_u_14.DuelInterface.RoundResult.Frame:GetPropertyChangedSignal("Visible"):Connect(function()
        p_u_14:Update()
    end)
    p_u_14.DuelInterface.Scoreboard.VisibilityChanged:Connect(function()
        p_u_14:Update()
    end)
    p_u_14.DuelInterface.Voting.VisibilityChanged:Connect(function()
        p_u_14:Update()
    end)
end
return v_u_3