local v_u_1 = game:GetService("CollectionService")
local v2 = game:GetService("ReplicatedStorage")
local v3 = game:GetService("Players")
require(v2.Modules.BetterDebris)
require(v2.Modules.Utility)
require(v2.Modules.Spring)
local v_u_4 = require(v3.LocalPlayer.PlayerScripts.Controllers.SpectateController)
local v_u_5 = require(v3.LocalPlayer.PlayerScripts.Modules.SmokeCloud)
v3.LocalPlayer.PlayerScripts.Assets:WaitForChild("Misc"):WaitForChild("SmokeClouds")
local v_u_6 = v3.LocalPlayer.PlayerScripts.Modules:WaitForChild("SmokeClouds")
local v_u_7 = {}
v_u_7.__index = v_u_7
function v_u_7._new()
    local v8 = v_u_7
    local v9 = setmetatable({}, v8)
    v9._smoke_clouds = {}
    v9:_Init()
    return v9
end
function v_u_7.Update(p10, p11)
    local v12 = {}
    for v13, v14 in pairs(p10._smoke_clouds) do
        if v14:IsDestroyed() then
            v12[v13] = true
        elseif v_u_4:IsRendered(v14.EnvironmentID) then
            v14:Update(p11)
        end
    end
    for v15 in pairs(v12) do
        p10._smoke_clouds[v15] = nil
    end
end
function v_u_7._ObjectRemoved(p16, p17)
    local v18 = p16._smoke_clouds[p17]
    if v18 then
        v18:Clear()
    end
end
function v_u_7._ObjectAdded(p19, p20)
    if p19._smoke_clouds[p20] then
        p19._smoke_clouds[p20]:Destroy()
        p19._smoke_clouds[p20] = nil
    end
    p19._smoke_clouds[p20] = (v_u_6:FindFirstChild(p20.Name) and require(v_u_6[p20.Name]) or v_u_5).new(p20)
    p19._smoke_clouds[p20].Model.Parent = workspace
    p19:Update(0)
end
function v_u_7._Init(p_u_21)
    v_u_1:GetInstanceRemovedSignal("SmokeCloud"):Connect(function(p22)
        p_u_21:_ObjectRemoved(p22)
    end)
    v_u_1:GetInstanceAddedSignal("SmokeCloud"):Connect(function(p23)
        p_u_21:_ObjectAdded(p23)
    end)
    for _, v24 in pairs(v_u_1:GetTagged("SmokeCloud")) do
        task.spawn(p_u_21._ObjectAdded, p_u_21, v24)
    end
end
return v_u_7._new()