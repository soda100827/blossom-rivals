local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = require(v1.Modules.BetterDebris)
local v_u_3 = require(v1.Modules.Finishers.Ragdoll)
local v_u_4 = require(v1.Modules.Utility)
local v_u_5 = setmetatable({}, v_u_3)
v_u_5.__index = v_u_5
function v_u_5.new(...)
    local v6 = v_u_3.new(...)
    local v7 = v_u_5
    local v8 = setmetatable(v6, v7)
    v8:_Init()
    return v8
end
function v_u_5.PlayServer(p9, ...)
    v_u_3.PlayServer(p9, ...)
    if p9._is_humanoid then
        local v10 = script.Part:Clone()
        v10.CFrame = p9._subject.RootPart.CFrame
        v10.Parent = workspace
        v_u_4:PlayParticles(v10)
        v_u_2:AddItem(v10, 10)
        local v11 = p9._destroy_these
        table.insert(v11, v10)
        local v12 = Random.new():NextUnitVector()
        local v13 = v12 * Vector3.new(1, 0, 1)
        local v14 = v12.Y
        local v15 = (v13 + Vector3.new(0, 1, 0) * math.abs(v14)) * (16 + 16 * math.random())
        local v16 = p9._subject.Parent:GetPivot().Position
        local v17 = v_u_4:Raycast(v16, v16 + v15, v15.Magnitude, { p9._subject.Parent }, Enum.RaycastFilterType.Exclude)
        p9._subject.Parent:PivotTo(CFrame.new(v17.Position) * CFrame.Angles(math.random() * 3.141592653589793 * 2, math.random() * 3.141592653589793 * 2, math.random() * 3.141592653589793 * 2))
    end
end
function v_u_5.PlayClient(p18, ...)
    p18:CreateSound("rbxassetid://77408061407414", 1, 1 + 0.1 * math.random(), nil, true, 5)
    v_u_3.PlayClient(p18, ...)
end
function v_u_5._Init(_) end
return v_u_5