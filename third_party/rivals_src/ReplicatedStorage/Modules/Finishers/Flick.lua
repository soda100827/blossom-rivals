local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("RunService")
local v_u_3 = require(v1.Modules.Finishers.Ragdoll)
local v_u_4 = require(v1.Modules.Utility)
local v_u_5 = require(v1.Modules.Spring)
local v_u_6 = setmetatable({}, v_u_3)
v_u_6.__index = v_u_6
function v_u_6.new(...)
    local v7 = v_u_3.new(...)
    local v8 = v_u_6
    local v9 = setmetatable(v7, v8)
    v9:_Init()
    return v9
end
function v_u_6.PlayServer(p10, ...)
    v_u_3.PlayServer(p10, ...)
    wait(1)
    v_u_4:Knockback(p10._is_humanoid and p10._subject.RootPart or p10._subject, p10:_GetKnockbackDirection() * 75)
end
function v_u_6.PlayClient(p11, ...)
    v_u_3.PlayClient(p11, ...)
    local v12 = p11._is_humanoid and p11._subject.RootPart or p11._subject
    local v13 = p11:_GetKnockbackDirection()
    local v_u_14 = script.Model:Clone()
    v_u_14.Parent = p11._subject
    local v15 = p11._destroy_these
    table.insert(v15, v_u_14)
    local v16 = v_u_5.new(v12.Position + -v13 * Vector3.new(5, -5, 5) * 2, 1, 10)
    local v17 = tick()
    while tick() < v17 + 1 do
        v16.Target = v12.Position + -v13 * Vector3.new(1, -1, 1)
        v_u_14:PivotTo(CFrame.new(v16.Value) * CFrame.new(Vector3.new(0, 0, 0), v13 * Vector3.new(1, 0, 1)))
        v_u_2.RenderStepped:Wait()
    end
    p11:CreateSound("rbxassetid://120809068918800", 1.25, 1, nil, true, 5)
    p11:CreateSound("rbxassetid://92760487729234", 2.5, 1, nil, true, 5)
    v_u_14.Before.Transparency = 1
    v_u_14.After.Transparency = 0
    local v_u_18 = v_u_14.After.Size * 2
    local v_u_19 = v_u_14.After.Size
    local v_u_20 = v_u_14.After.CFrame
    local v21 = v13 * Vector3.new(1, 0, 1)
    local v22 = v13.Y
    local v23 = math.abs(v22)
    local v_u_24 = (v21 + Vector3.new(0, v23, 0)) * 2
    v_u_4:RenderstepForLoop(0, 100, 4, function(p25)
        local v26 = 1 - (1 - p25 / 100) ^ 3
        v_u_14.After.Size = v_u_18:Lerp(v_u_19, v26)
        v_u_14.After.CFrame = v_u_20 + v_u_24:Lerp(Vector3.new(0, 0, 0), v26)
    end)
    local v_u_27 = v_u_14.After.CFrame
    local v_u_28 = v_u_14.After.CFrame - Vector3.new(0, 10, 0)
    v_u_4:RenderstepForLoop(0, 100, 4, function(p29)
        local v30 = (p29 / 100) ^ 3
        v_u_14.After.CFrame = v_u_27:Lerp(v_u_28, v30)
    end)
end
function v_u_6._GetKnockbackDirection(p31)
    return (Random.new(p31._serial and p31._serial.Seed or p31._seed):NextUnitVector() * Vector3.new(1, 0, 1) + Vector3.new(0, 1, 0)).Unit
end
function v_u_6._Init(_) end
return v_u_6