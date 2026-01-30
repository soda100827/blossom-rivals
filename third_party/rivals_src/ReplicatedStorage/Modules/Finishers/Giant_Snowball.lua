local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("RunService")
local v_u_3 = require(v1.Modules.Finishers.Ragdoll)
local v_u_4 = require(v1.Modules.BetterDebris)
local v_u_5 = require(v1.Modules.Utility)
local v_u_6 = setmetatable({}, v_u_3)
v_u_6.__index = v_u_6
function v_u_6.new(...)
    local v7 = v_u_3.new(...)
    local v8 = v_u_6
    local v9 = setmetatable(v7, v8)
    v9:_Init()
    return v9
end
function v_u_6.PlayClient(p10, ...)
    v_u_3.PlayClient(p10, ...)
    local v_u_11 = p10._is_humanoid and p10._subject.RootPart or p10._subject
    local v_u_12 = script.Model:Clone()
    v_u_12.PrimaryPart = v_u_12.Primary
    v_u_12.Parent = v_u_11
    v_u_12:ScaleTo(v_u_12:GetScale() * (1 + 1 * math.random()))
    local v13 = p10._destroy_these
    table.insert(v13, v_u_12)
    v_u_4:AddItem(v_u_12, 10)
    local v_u_14 = math.random() * 3.141592653589793 * 2
    v_u_5:RenderstepForLoop(0, 100, 4, function(p15)
        local v16 = v_u_11.Position - Vector3.new(0, 1.5, 0)
        local v17 = v_u_14
        local v18 = math.cos(v17)
        local v19 = v_u_14
        local v20 = math.sin(v19)
        local v21 = v16 + Vector3.new(v18, 0, v20) * 128 + Vector3.new(0, 128, 0)
        local v22 = (v21 - v16).Magnitude * (1 - p15 / 100)
        v_u_12:PivotTo(CFrame.new(v16, v21) * CFrame.new(0, 0, -v22 / 2))
    end)
    v_u_5:PlayParticles(v_u_12)
    p10:CreateSound("rbxassetid://110743147230828", 1.5, 1 + 0.1 * math.random(), nil, true, 5)
    local v23 = tick()
    while tick() < v23 + 2 do
        v_u_12:PivotTo(CFrame.new(v_u_11.Position - Vector3.new(0, 1.5, 0)))
        v_u_2.RenderStepped:Wait()
    end
    v_u_12.PrimaryPart.Anchored = false
end
function v_u_6._Init(_) end
return v_u_6