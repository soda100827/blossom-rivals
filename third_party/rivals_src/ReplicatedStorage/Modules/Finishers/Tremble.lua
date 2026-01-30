local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("RunService")
local v_u_3 = require(v1.Modules.Finisher)
require(v1.Modules.Utility)
local v_u_4 = setmetatable({}, v_u_3)
v_u_4.__index = v_u_4
function v_u_4.new(...)
    local v5 = v_u_3.new(...)
    local v6 = v_u_4
    local v7 = setmetatable(v5, v6)
    v7:_Init()
    return v7
end
function v_u_4.PlayServer(p8)
    p8:_AnchorModel(0)
end
function v_u_4.PlayClient(p9, ...)
    local v_u_10 = {}
    for _, v11 in pairs(p9:_GetObjects(true)) do
        if v11:IsA("BasePart") then
            v_u_10[v11] = v11.CFrame
        end
    end
    local v12 = p9._connections
    local v13 = v_u_2.RenderStepped
    table.insert(v12, v13:Connect(function(_)
        for v14, v15 in pairs(v_u_10) do
            local v16 = math.random() - 0.5
            local v17 = math.random() - 0.5
            local v18 = math.random() - 0.5
            v14.CFrame = v15 + Vector3.new(v16, v17, v18) * 0.2
        end
    end))
    p9:CreateSound("rbxassetid://82637145735352", 1, 1 + 0.1 * math.random(), nil, true)
end
function v_u_4._Init(_) end
return v_u_4