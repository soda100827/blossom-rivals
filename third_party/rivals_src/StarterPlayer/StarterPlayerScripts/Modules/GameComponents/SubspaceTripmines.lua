local v_u_1 = game:GetService("CollectionService")
local v_u_2 = game:GetService("RunService")
local v_u_3 = game:GetService("Players")
local v_u_4 = require(v_u_3.LocalPlayer.PlayerScripts.Controllers.FighterController)
local v_u_5 = require(v_u_3.LocalPlayer.PlayerScripts.Controllers.WrapController)
local v_u_6 = {}
v_u_6.__index = v_u_6
function v_u_6._new()
    local v7 = v_u_6
    local v8 = setmetatable({}, v7)
    v8:_Init()
    return v8
end
function v_u_6._GetItem(_, p9)
    for _, v10 in pairs(v_u_4.Objects) do
        local v11 = v10:GetItem(p9)
        if v11 then
            return v11
        end
    end
end
function v_u_6._SetupWrap(_, p_u_12, p_u_13)
    local v_u_14 = nil
    p_u_12.DescendantAdded:Connect(function(p15)
        if p15:HasTag("Wrappable") then
            v_u_5:ResetWrap(v_u_14)
            v_u_14 = v_u_5:RecordOriginalWrapProperties(p_u_12)
            v_u_5:ApplyWrap(v_u_14, p_u_13:GetWrap(), true)
        end
    end)
    v_u_5:ResetWrap(v_u_14)
    v_u_14 = v_u_5:RecordOriginalWrapProperties(p_u_12)
    v_u_5:ApplyWrap(v_u_14, p_u_13:GetWrap(), true)
end
function v_u_6._ObjectAdded(p16, p17)
    p17:WaitForChild("Hitbox")
    local v18 = p17:GetAttribute("ObjectID")
    local v19 = p17:GetAttribute("HitboxDelay")
    local v20 = p17:GetAttribute("PlacedByUserID")
    local v21 = p17:GetAttribute("TeamID")
    local v22 = p16:_GetItem(v18)
    if v22 then
        v22.ViewModel:PlayHideMineSound(p17)
        p16:_SetupWrap(p17, v22)
    end
    wait(v19 / 2)
    local v23 = {}
    for _, v24 in pairs(p17:GetDescendants()) do
        if v24:IsA("BasePart") or (v24:IsA("Decal") or (v24:IsA("Texture") or v24:IsA("ParticleEmitter"))) then
            v23[v24] = true
        end
    end
    local v25 = v20 ~= v_u_3.LocalPlayer.UserId and (v_u_4.LocalFighter and v_u_4.LocalFighter:Get("TeamID"))
    if v25 then
        v25 = v_u_4.LocalFighter:Get("TeamID") == v21
    end
    local v26 = v19 / 2
    local v27 = tick()
    local v28 = v25 and 0.5 or 1
    while p17:IsDescendantOf(workspace) and tick() < v27 + v26 do
        local v29 = (tick() - v27) / v26
        local v30 = math.clamp(v29, 0, 1)
        for v31 in pairs(v23) do
            v31.LocalTransparencyModifier = v28 * v30
        end
        v_u_2.RenderStepped:Wait()
    end
    for v32 in pairs(v23) do
        v32.LocalTransparencyModifier = v28
    end
end
function v_u_6._Init(p_u_33)
    v_u_1:GetInstanceAddedSignal("SubspaceTripmine"):Connect(function(p34)
        p_u_33:_ObjectAdded(p34)
    end)
    for _, v35 in pairs(v_u_1:GetTagged("SubspaceTripmine")) do
        task.defer(p_u_33._ObjectAdded, p_u_33, v35)
    end
end
return v_u_6._new()