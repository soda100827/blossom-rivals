local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("CollectionService")
local v_u_3 = game:GetService("Players")
local v_u_4 = require(v1.Modules.Utility)
local v_u_5 = require(v_u_3.LocalPlayer.PlayerScripts.Controllers:WaitForChild("FighterController"))
local v_u_6 = {}
v_u_6.__index = v_u_6
function v_u_6._new()
    local v7 = v_u_6
    local v8 = setmetatable({}, v7)
    v8._objects = {}
    v8:_Init()
    return v8
end
function v_u_6._ObjectAdded(p9, p_u_10)
    local v_u_11 = {
        ["Connections"] = {},
        ["Cooldowns"] = {}
    }
    local function v35(p12)
        local v13 = p12.AssemblyRootPart or p12
        if p12.Parent == v_u_3.LocalPlayer.Character and (tick() >= (v_u_11.Cooldowns[v13] or 0) and (v_u_5.LocalFighter and v_u_5.LocalFighter:IsAlive())) then
            local v14 = p_u_10:GetAttribute("Velocity")
            local v15 = p_u_10:GetAttribute("LocalTo")
            local v16 = p_u_10:GetAttribute("MinimumYVelocity")
            if v15 then
                v14 = p_u_10.CFrame[v15] * v14
            end
            if v16 then
                local v17 = v14.X
                local v18 = v14.Y
                if math.abs(v18) >= 0.001 then
                    local v19 = v14.Y
                    local v20 = math.abs(v19)
                    local v21 = math.max(v16, v20)
                    local v22 = v14.Y
                    v16 = v21 * math.sign(v22)
                end
                local v23 = v14.Z
                v14 = Vector3.new(v17, v16, v23)
            end
            local v24 = p_u_10:GetAttribute("HasToBeInFront")
            local v25
            if typeof(v24) == "CFrame" then
                v25 = v24
            else
                v25 = CFrame.identity
            end
            if v24 and v_u_4:AngleBetweenVectors((v13.Position - (p_u_10.CFrame * v25).Position).Unit, v14.Unit) > 1.5707963267948966 then
                return
            else
                v_u_11.Cooldowns[v13] = tick() + (p_u_10:GetAttribute("Cooldown") or 0.5)
                local v26 = v_u_5.LocalFighter.Entity.RootPart.Velocity
                local v27 = v_u_5.LocalFighter.Entity.Humanoid.WalkSpeed
                local v28 = v_u_4:AngleBetweenVectors(v14, Vector3.new(0, 1, 0)) < 0.08726646259971647 and true or v_u_4:AngleBetweenVectors(v14, Vector3.new(-0, -1, -0)) < 0.08726646259971647
                local v29 = p_u_10:GetAttribute("SpringSpeed") or 12
                local v30
                if v28 then
                    local v31 = v26.Unit
                    local v32 = (v26 * (Vector3.new(1, 0, 1)).Unit).Magnitude
                    v30 = v31 * math.max(v32, v27)
                else
                    v30 = nil
                end
                if not v30 or (v30 ~= v30 or (v30.Magnitude <= 0.001 or not v30)) then
                    v30 = nil
                end
                if p_u_10:GetAttribute("Override") then
                    v_u_5.LocalFighter.Entity:CancelCustomKnockback()
                end
                v_u_5.LocalFighter.Entity:CustomKnockback(v14, v29, nil, v30)
                local v33 = p_u_10:GetAttribute("SoundID")
                local v34 = p_u_10:GetAttribute("SoundVolume") or 1
                if v33 then
                    v_u_4:CreateSound(v33, 1 * v34, 1, script, true, 10)
                else
                    v_u_4:CreateSound("rbxassetid://17835965717", 1 * v34, 1.25, script, true, 5)
                end
            end
        else
            return
        end
    end
    local v36 = v_u_11.Connections
    local v37 = p_u_10.Touched
    table.insert(v36, v37:Connect(v35))
    local v38 = v_u_11.Connections
    local v39 = p_u_10.TouchEnded
    table.insert(v38, v39:Connect(v35))
    p9._objects[p_u_10] = v_u_11
end
function v_u_6._ObjectRemoved(p40, p41)
    local v42 = p40._objects[p41]
    if v42 then
        for _, v43 in pairs(v42.Connections) do
            v43:Disconnect()
        end
        p40._objects[p41] = nil
    end
end
function v_u_6._Init(p_u_44)
    v_u_2:GetInstanceAddedSignal("CustomKnockbackPart"):Connect(function(p45)
        p_u_44:_ObjectAdded(p45)
    end)
    v_u_2:GetInstanceRemovedSignal("CustomKnockbackPart"):Connect(function(p46)
        p_u_44:_ObjectRemoved(p46)
    end)
    for _, v47 in pairs(v_u_2:GetTagged("CustomKnockbackPart")) do
        task.defer(p_u_44._ObjectAdded, p_u_44, v47)
    end
end
return v_u_6._new()