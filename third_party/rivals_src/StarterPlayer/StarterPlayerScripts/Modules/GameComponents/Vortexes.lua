local v_u_1 = game:GetService("CollectionService")
local v2 = game:GetService("ReplicatedStorage")
local v_u_3 = game:GetService("Players")
local v_u_4 = require(v2.Modules.Utility)
local v_u_5 = require(v2.Modules.Spring)
local v_u_6 = require(v_u_3.LocalPlayer.PlayerScripts.Controllers.MechanicsController)
local v_u_7 = require(v_u_3.LocalPlayer.PlayerScripts.Controllers.FighterController)
local v_u_8 = v_u_3.LocalPlayer.PlayerScripts.Assets.Misc.Vortexes
local v_u_9 = {}
v_u_9.__index = v_u_9
function v_u_9._new()
    local v10 = v_u_9
    local v11 = setmetatable({}, v10)
    v11._vortexes = {}
    v11._forces = {}
    v11._was_sitting = false
    v11:_Init()
    return v11
end
function v_u_9.UpdateForces(p12)
    local v13 = v_u_7.LocalFighter and v_u_7.LocalFighter.Entity
    if v13 then
        v13 = v_u_7.LocalFighter.Entity.Humanoid
    end
    local v14
    if v13 then
        v14 = v13.RootPart
    else
        v14 = v13
    end
    if v14 then
        for v15, v16 in pairs(p12._vortexes) do
            local v17 = (v15.Position - v14.Position).Magnitude
            if v15.Size.X / 2 < v17 then
                if v15.Size.X * 1 < v17 then
                    local v18 = p12._forces[v15]
                    if v18 then
                        p12:_Cleanup(v18)
                        p12._forces[v15] = nil
                    end
                end
            elseif v16.UserID ~= v_u_3.LocalPlayer.UserId and (not v16.TeamID or v16.TeamID ~= v_u_3.LocalPlayer:GetAttribute("TeamID")) and not p12._forces[v15] then
                local v19 = Instance.new("VectorForce")
                v19.RelativeTo = Enum.ActuatorRelativeTo.World
                v19.Attachment0 = v14.RootRigAttachment
                v19.Parent = v14
                p12._forces[v15] = {
                    ["RootPart"] = v14,
                    ["VectorForce"] = v19
                }
            end
        end
        if next(p12._forces) then
            if v_u_6.IsSliding then
                v_u_6:StopSliding()
            end
            for v20, v21 in pairs(p12._forces) do
                local v22 = CFrame.new(v14.Position, v20.Position)
                local v23 = (v22.RightVector * 0.15 + v22.LookVector) * 5000
                local v24 = v21.VectorForce
                local v25 = v23.Unit
                local v26 = v23.Magnitude
                v24.Force = v25 * math.min(v26, 5000)
                v13.Sit = true
                p12._was_sitting = true
            end
        elseif p12._was_sitting then
            p12._was_sitting = false
            v13.Sit = false
        end
    else
        for _, v27 in pairs(p12._forces) do
            p12:_Cleanup(v27)
        end
        p12._forces = {}
        return
    end
end
function v_u_9.UpdateVisuals(p28, p29)
    for v30, v31 in pairs(p28._vortexes) do
        local v32 = (tick() - v31.Start) / v31.Lifetime
        local v33 = math.clamp(v32, 0, 1)
        v31.Clock = v31.Clock + p29 * (v33 ^ 4 + 1)
        local v34 = 1 - v33 ^ 4
        local v35 = math.max(0.01, v34)
        local v36 = CFrame.new(v30.Position, workspace.CurrentCamera.CFrame.Position) * CFrame.Angles(-1.5707963267948966, 0, 0) * CFrame.Angles(0, v31.Clock * (v33 ^ 4 * 4 + 4) % 6.283185307179586, 0) * CFrame.Angles((1 - v33 ^ 6 * 3) * 0.7853981633974483, 0, 0) * CFrame.Angles(0, v31.Clock * (v33 ^ 4 * 4 + 4) % 6.283185307179586, 0)
        v31.Visual:ScaleTo(v31.OriginalScale * v31.ScaleSpring.Value * v35)
        v31.Visual:PivotTo(v36)
        if tick() > v31.NextShrink then
            v31.NextShrink = tick() + 0.25
            local v37 = v31.ScaleSpring
            v37.Value = v37.Value - 0.125
        end
    end
end
function v_u_9.Update(p38, p39)
    p38:UpdateForces(p39)
    p38:UpdateVisuals(p39)
end
function v_u_9._Cleanup(_, p40)
    p40.VectorForce:Destroy()
end
function v_u_9._ObjectAdded(p41, p42)
    p41:_ObjectRemoved(p42)
    v_u_4:CreateSound("rbxassetid://90138246017443", 1.25, 0.75 + 0.1 * math.random(), p42, true)
    local v43 = (v_u_8:FindFirstChild(p42:GetAttribute("ViewModelName") or "Default") or v_u_8.Default):Clone()
    v43:ScaleTo(v43:GetScale() * p42.Size.X / 24)
    v43.Parent = p42
    local v44 = v_u_5.new(1, 0.75, 20)
    v44.Value = 0
    p41._vortexes[p42] = {
        ["Visual"] = v43,
        ["OriginalScale"] = v43:GetScale(),
        ["ScaleSpring"] = v44,
        ["NextShrink"] = tick() + 0.5,
        ["Start"] = tick(),
        ["Clock"] = 0,
        ["Lifetime"] = p42:GetAttribute("Lifetime"),
        ["TeamID"] = p42:GetAttribute("TeamID"),
        ["UserID"] = p42:GetAttribute("UserID")
    }
end
function v_u_9._ObjectRemoved(p45, p46)
    p45._vortexes[p46] = nil
    if p45._forces[p46] then
        p45:_Cleanup(p45._forces[p46])
        p45._forces[p46] = nil
    end
end
function v_u_9._Init(p_u_47)
    v_u_1:GetInstanceRemovedSignal("Vortex"):Connect(function(p48)
        p_u_47:_ObjectRemoved(p48)
    end)
    v_u_1:GetInstanceAddedSignal("Vortex"):Connect(function(p49)
        p_u_47:_ObjectAdded(p49)
    end)
    for _, v50 in pairs(v_u_1:GetTagged("Vortex")) do
        task.defer(p_u_47._ObjectAdded, p_u_47, v50)
    end
end
return v_u_9._new()