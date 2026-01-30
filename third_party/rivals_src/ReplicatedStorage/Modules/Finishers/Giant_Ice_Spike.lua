local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("TweenService")
game:GetService("RunService")
local v_u_3 = require(v1.Modules.BetterDebris)
local v_u_4 = require(v1.Modules.Finishers.Ragdoll)
require(v1.Modules.Utility)
local v_u_5 = TweenInfo.new(1, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
local v_u_6 = setmetatable({}, v_u_4)
v_u_6.__index = v_u_6
function v_u_6.new(...)
    local v7 = v_u_4.new(...)
    local v8 = v_u_6
    local v9 = setmetatable(v7, v8)
    v9:_Init()
    return v9
end
function v_u_6.PlayServer(p10, ...)
    v_u_4.PlayServer(p10, ...)
    local v11 = p10._is_humanoid and (p10._subject.Parent:FindFirstChild("UpperTorso") or p10._subject.RootPart) or p10._subject
    local v12 = p10._eliminator and p10._eliminator.Character
    if v12 then
        v12 = p10._eliminator.Character:FindFirstChild("HumanoidRootPart")
    end
    if v12 then
        for _, v13 in pairs(p10:_GetObjects(true)) do
            if v13:IsA("BasePart") then
                v13.CustomPhysicalProperties = PhysicalProperties.new(v13.CurrentPhysicalProperties.Density, 2, 0, 100, 100)
            end
        end
        local v14 = Instance.new("BodyVelocity")
        v14.MaxForce = Vector3.new(10000, 10000, 10000)
        v14.Velocity = CFrame.new(v12.Position, v11.Position).LookVector * 300
        v14.Parent = v11
        v_u_3:AddItem(v14, 5)
        local v15 = Instance.new("BodyGyro")
        v15.CFrame = CFrame.new(v11.Position, v12.Position)
        v15.Parent = v11
        v_u_3:AddItem(v15, 5)
    end
end
function v_u_6.PlayClient(p16, ...)
    v_u_4.PlayClient(p16, ...)
    local v17 = p16._is_humanoid and (p16._subject.Parent:FindFirstChild("UpperTorso") or p16._subject.RootPart) or p16._subject
    local v18 = script.Icicle:Clone()
    v18.CFrame = v17.CFrame * CFrame.Angles(-1.5707963267948966, 0, 0)
    v18.WeldConstraint.Part0 = v17
    v18.Parent = v17
    local v19 = p16._destroy_these
    table.insert(v19, v18)
    v_u_3:AddItem(v18.WeldConstraint, 5 + v_u_5.Time / 2)
    p16:CreateSound("rbxassetid://73317248668904", 1, 1 + 0.1 * math.random(), nil, true, 5)
    p16:CreateSound("rbxassetid://115260318005653", 1.5, 1 + 0.1 * math.random(), nil, true, 5)
    wait(5)
    v_u_2:Create(v18, v_u_5, {
        ["Size"] = Vector3.new(0, 0, 0)
    }):Play()
    wait(v_u_5.Time)
end
function v_u_6._Init(_) end
return v_u_6