local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("TweenService")
local v_u_3 = require(v1.Modules.Finisher)
local v_u_4 = TweenInfo.new(1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
local v_u_5 = TweenInfo.new(1, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
local v_u_6 = setmetatable({}, v_u_3)
v_u_6.__index = v_u_6
function v_u_6.new(...)
    local v7 = v_u_3.new(...)
    local v8 = v_u_6
    local v9 = setmetatable(v7, v8)
    v9:_Init()
    return v9
end
function v_u_6.PlayClient(p10)
    local v11 = p10._is_humanoid and p10._subject.RootPart or p10._subject
    for _, v12 in pairs(p10:_GetObjects(true)) do
        if v12:IsA("BasePart") and v12 ~= v11 then
            v12:Destroy()
        end
    end
    v11.Size = Vector3.new(0, 0, 0)
    for _ = 1, math.random(5, 10) do
        local v13 = Random.new():NextUnitVector() * Vector3.new(1, 0, 1)
        local v14 = 0.5 + 0.5 * math.random()
        local v15 = v13 + Vector3.new(0, v14, 0)
        local v16 = script.Bone:Clone()
        v16.CFrame = v11.CFrame
        v16.Size = v16.Size * (0.875 + 0.25 * math.random())
        v16.Velocity = v15 * (15 + 15 * math.random())
        v16.RotVelocity = Random.new():NextUnitVector() * (5 + 10 * math.random())
        v16.Parent = v11
        local v17 = p10._destroy_these
        table.insert(v17, v16)
    end
    local v18 = script.BonePile:Clone()
    v18.Size = Vector3.new(0, 0, 0)
    v18.CFrame = v11.CFrame
    v18.Velocity = Random.new():NextUnitVector() * (5 + 10 * math.random())
    v18.CollisionGroup = "IgnorePlayers"
    v18.Parent = v11
    local v19 = p10._destroy_these
    table.insert(v19, v18)
    v_u_2:Create(v18, v_u_4, {
        ["Size"] = script.BonePile.Size
    }):Play()
    p10:CreateSound("rbxassetid://71015990947254", 1.25, 0.95 + 0.1 * math.random(), v18, true, 10)
    wait(3)
    v_u_2:Create(v18, v_u_5, {
        ["Size"] = Vector3.new(0, 0, 0)
    }):Play()
    wait(1)
end
function v_u_6._Init(_) end
return v_u_6