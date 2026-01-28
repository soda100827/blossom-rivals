local v_u_1 = game:GetService("CollectionService")
local v2 = game:GetService("ReplicatedStorage")
local v3 = game:GetService("Players")
local v_u_4 = require(v2.Modules.CONSTANTS)
local v_u_5 = require(v2.Modules.ScavengerHuntLibrary)
local v_u_6 = require(v3.LocalPlayer.PlayerScripts.Controllers.PlayerDataController)
local v_u_7 = require(v3.LocalPlayer.PlayerScripts.Controllers.CameraController)
local v_u_8 = require(v3.LocalPlayer.PlayerScripts.Modules.Functions.CollectEffect)
local v_u_9 = {}
v_u_9.__index = v_u_9
function v_u_9._new()
    local v10 = v_u_9
    local v11 = setmetatable({}, v10)
    v11._collected = {}
    v11:_Init()
    return v11
end
function v_u_9._UpdateObject(p12, p13, p14)
    if p12._collected[p13] then
        return
    else
        local v15 = p13:GetAttribute("ScavengerHuntName")
        local v16 = v_u_5.Info[v15]
        local v17 = v_u_6:Get("ScavengerHunts")[v15]
        if v17 and table.find(v17, p13:GetAttribute("ObjectName")) then
            p12._collected[p13] = true
            task.defer(p13.Destroy, p13)
            if not p14 then
                v_u_8(p13:GetPivot().Position, v16.Color, "rbxassetid://129198689909472")
            end
        else
            local v18 = v_u_7:GetPublicState() ~= v_u_7.CameraState.States.CustomFreecam and v_u_4.IS_PRIVATE_HUB_SERVER
            if v18 then
                v18 = not v16.AllowedInPrivateServers
            end
            local v19 = v18 and 1 or 0
            for _, v20 in pairs(p13:GetDescendants()) do
                if v20:IsA("BasePart") or v20:IsA("ParticleEmitter") then
                    v20.LocalTransparencyModifier = v19
                end
            end
        end
    end
end
function v_u_9._UpdateAllObjects(p21, p22)
    for _, v23 in pairs(v_u_1:GetTagged("ScavengerHunt")) do
        task.defer(p21._UpdateObject, p21, v23, p22)
    end
end
function v_u_9._Init(p_u_24)
    v_u_6:GetDataChangedSignal("ScavengerHunts"):Connect(function()
        p_u_24:_UpdateAllObjects()
    end)
    v_u_1:GetInstanceAddedSignal("ScavengerHunt"):Connect(function(p25)
        p_u_24:_UpdateObject(p25, true)
    end)
    v_u_7.CustomFreecamStateChanged:Connect(function()
        p_u_24:_UpdateAllObjects()
    end)
    p_u_24:_UpdateAllObjects(true)
end
return v_u_9._new()