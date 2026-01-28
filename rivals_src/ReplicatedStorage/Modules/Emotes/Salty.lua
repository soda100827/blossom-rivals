local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = require(v1.Modules.Emote)
local v_u_3 = setmetatable({}, v_u_2)
v_u_3.__index = v_u_3
function v_u_3.new(...)
    local v4 = v_u_2.new(2.6, script.Name, ...)
    local v5 = v_u_3
    local v6 = setmetatable(v4, v5)
    v6:_Init()
    return v6
end
function v_u_3.PlayClient(p7, ...)
    v_u_2.PlayClient(p7, ...)
    p7:_PlayAnimation("rbxassetid://72081093559633")
    local v8 = {}
    for _, v9 in pairs(script.Particles:GetChildren()) do
        local v10 = v9:Clone()
        local v11 = p7._humanoid.Parent
        if v11 then
            v11 = p7._humanoid.Parent:FindFirstChild("LeftHand")
        end
        v10.Parent = v11
        table.insert(v8, v10)
        local v12 = p7._destroy_these
        table.insert(v12, v10)
    end
    for _, v13 in pairs(v8) do
        v13.Enabled = false
    end
    wait(0.5)
    p7:CreateSound("rbxassetid://82749828642126", 1, 1, nil, true, 5)
    wait(0.2)
    for _, v14 in pairs(v8) do
        v14.Enabled = true
    end
    wait(0.6)
    for _, v15 in pairs(v8) do
        v15.Enabled = false
    end
end
function v_u_3._Init(_) end
return v_u_3