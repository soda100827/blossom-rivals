local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.BetterDebris)
local v_u_4 = require(v1.Modules.Utility)
local v_u_5 = require(v2.LocalPlayer.PlayerScripts.Modules.ClientReplicatedClasses.ClientEntity.ClientHumanoidEntity.ClientEnemy)
local v_u_6 = v2.LocalPlayer.PlayerScripts.Assets.Misc.FlagZombieEmpoweredEffect
local v_u_7 = v2.LocalPlayer.PlayerScripts.Assets.Misc.ZombieFlag
local v_u_8 = setmetatable({}, v_u_5)
v_u_8.__index = v_u_8
function v_u_8.new(...)
    local v9 = v_u_5.new(...)
    local v10 = v_u_8
    local v11 = setmetatable(v9, v10)
    v11._dropped_flags = {}
    v11:_Init()
    return v11
end
function v_u_8.ReplicateFromServer(p12, p13, ...)
    if p13 == "DropFlagEffect" then
        if p12:IsRendered() then
            local v14, v15 = ...
            local v_u_16 = v_u_7:Clone()
            v_u_16:PivotTo(CFrame.new(v14) * CFrame.Angles(0, 6.283185307179586 * math.random(), 0))
            v_u_16.Parent = workspace
            v_u_3:AddItem(v_u_16, 30)
            for _, v17 in pairs(v_u_16.Effect:GetDescendants()) do
                if v17:IsA("ParticleEmitter") then
                    v_u_4:ScaleParticleEmitter(v17, v15 / 25)
                end
            end
            task.spawn(function()
                for _ = 1, 3 do
                    v_u_4:PlayParticles(v_u_16)
                    wait(0.25)
                end
            end)
            v_u_4:CreateSound("rbxassetid://98975031346830", 1, 0.9 + 0.2 * math.random(), v_u_16.PrimaryPart, true, 10)
            local v_u_18 = v_u_16:GetPivot()
            local v_u_19 = CFrame.Angles(6.283185307179586 * math.random(), 6.283185307179586 * math.random(), 6.283185307179586 * math.random())
            local v_u_20 = v_u_16:GetScale()
            local v_u_21 = v_u_20 * 0.5
            local v_u_22 = v_u_16.Effect
            v_u_4:RenderstepForLoop(0, 100, 2, function(p23)
                local v24 = 1 - (1 - p23 / 100) ^ 3
                v_u_16:ScaleTo(v_u_21 + (v_u_20 - v_u_21) * v24)
                v_u_16:PivotTo(v_u_18 * CFrame.Angles(0, 0 + 9.42477796076938 * v24, 0) * v_u_19:Lerp(CFrame.identity, v24))
                v_u_22.CFrame = CFrame.new(v_u_22.Position)
            end)
            wait(15)
            v_u_4:RenderstepForLoop(0, 100, 1, function(p25)
                local v26 = (p25 / 100) ^ 3
                for _, v27 in pairs(v_u_16:GetDescendants()) do
                    if v27:IsA("BasePart") then
                        v27.LocalTransparencyModifier = v26
                    end
                end
            end)
            v_u_16:Destroy()
        end
    elseif p13 == "EmpowerOtherEntityEffect" then
        if p12:IsRendered() then
            local v28, v29 = ...
            if v28 then
                wait(1 * math.random())
                v_u_4:CreateSound("rbxassetid://104302486797762", 0.5 + 0.5 * math.random(), 0.75 + 0.5 * math.random(), v28, true, 10)
                local v30 = v_u_6:Clone()
                v30.CFrame = v28.CFrame * CFrame.new(0, -2, 0)
                v30.Parent = v28
                v_u_3:AddItem(v30, v29 + 10)
                local v31 = Instance.new("WeldConstraint")
                v31.Part0 = v28
                v31.Part1 = v30
                v31.Parent = v30
                wait(v29)
                for _, v32 in pairs(v30:GetDescendants()) do
                    if v32:IsA("ParticleEmitter") then
                        v32.Enabled = false
                    end
                end
                wait(3)
                v30:Destroy()
            end
        else
            return
        end
    else
        v_u_5.ReplicateFromServer(p12, p13, ...)
        return
    end
end
function v_u_8.Destroy(p33)
    for _, v34 in pairs(p33._dropped_flags) do
        v34:Destroy()
    end
    v_u_5.Destroy(p33)
end
function v_u_8._Init(_) end
return v_u_8