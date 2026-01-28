local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("HttpService")
local v_u_3 = game:GetService("Lighting")
local v4 = game:GetService("Players")
local v5 = require(v1.Modules.CONSTANTS)
local v_u_6 = require(v1.Modules.Finishers.Ragdoll)
local v_u_7 = require(v1.Modules.Utility)
local v_u_8 = v5.IS_CLIENT
if v_u_8 then
    v_u_8 = require(v4.LocalPlayer.PlayerScripts.Controllers.FighterController)
end
local v_u_9 = v5.IS_CLIENT
if v_u_9 then
    v_u_9 = require(v4.LocalPlayer.PlayerScripts.Controllers.CameraController)
end
local v_u_10 = setmetatable({}, v_u_6)
v_u_10.__index = v_u_10
function v_u_10.new(...)
    local v11 = v_u_6.new(...)
    local v12 = v_u_10
    local v13 = setmetatable(v11, v12)
    v13._fov_offset_key = v_u_2:GenerateGUID(false)
    v13:_Init()
    return v13
end
function v_u_10.PlayClient(p_u_14, p15)
    v_u_6.PlayClient(p_u_14, p15)
    if not p15 then
        local v16 = v_u_8:GetFighter(p_u_14._eliminator)
        if not (v16 and v16:Get("IsSpectating")) then
            return
        end
    end
    p_u_14:CreateSound("rbxassetid://74603473314180", 1.25, 0.95 + 0.1 * math.random(), script, true, 10)
    local v_u_17 = Instance.new("ColorCorrectionEffect")
    v_u_17.Parent = v_u_3
    local v18 = p_u_14._destroy_these
    table.insert(v18, v_u_17)
    v_u_7:RenderstepForLoop(0, 100, 2, function(p19)
        if p_u_14._destroyed then
            return true
        end
        local v20 = p19 / 100
        local v21
        if v20 < 0.5 then
            v21 = 16 * v20 ^ 5
        else
            v21 = 1 - (-2 * v20 + 2) ^ 5 / 2
        end
        local v22 = 1 - v21
        v_u_17.Brightness = 0.25 * v22
        v_u_17.Contrast = 0.5 * v22
        v_u_17.Saturation = 1 * v22
        v_u_9:SetExternalFOVOffset(p_u_14._fov_offset_key, 10 * v22)
    end)
    v_u_17:Destroy()
    v_u_9:SetExternalFOVOffset(p_u_14._fov_offset_key, 0)
end
function v_u_10.Destroy(p23)
    if v_u_9 then
        v_u_9:SetExternalFOVOffset(p23._fov_offset_key, 0)
    end
    v_u_6.Destroy(p23)
end
function v_u_10._Init(_) end
return v_u_10