local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("CollectionService")
local v3 = game:GetService("Players")
local v_u_4 = require(v1.Modules.SeasonLibrary)
local v_u_5 = require(v3.LocalPlayer.PlayerScripts.Modules.StaticModel.StaticViewModel)
local v_u_6 = require(v3.LocalPlayer.PlayerScripts.Modules.LobbyElement)
local v_u_7 = setmetatable({}, v_u_6)
v_u_7.__index = v_u_7
function v_u_7._new(...)
    local v8 = v_u_6.new(...)
    local v9 = v_u_7
    local v10 = setmetatable(v8, v9)
    v10:_Init()
    return v10
end
function v_u_7._ModelAdded(_, p11)
    local v12 = v_u_4.CurrentSeason.TopPlayerRewardSkinName
    p11:WaitForChild("NeonCone").Transparency = not v12 and 1 or p11:WaitForChild("NeonCone").Transparency
    local v13 = p11:WaitForChild("Neon")
    local v14
    if v12 then
        v14 = Enum.Material.Neon
    else
        v14 = Enum.Material.SmoothPlastic
    end
    v13.Material = v14
    if v12 then
        local v15 = v_u_5.new(v12)
        v15:ScaleTo(3.25)
        v15:PivotTo(p11:WaitForChild("Preview").CFrame)
        v15:SetParent(p11:WaitForChild("Preview"))
    end
end
function v_u_7._Init(p_u_16)
    v_u_2:GetInstanceAddedSignal("LobbyTopPlayerReward"):Connect(function(p17)
        p_u_16:_ModelAdded(p17)
    end)
    for _, v18 in pairs(v_u_2:GetTagged("LobbyTopPlayerReward")) do
        task.defer(p_u_16._ModelAdded, p_u_16, v18)
    end
end
return v_u_7._new()