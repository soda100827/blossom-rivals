local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("RunService")
local v_u_3 = require(v1.Modules.Finisher)
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
function v_u_4.PlayClient(p9)
    for _, v10 in pairs(p9:_GetObjects(true)) do
        if v10:IsA("BasePart") then
            local v11, _, v12 = v10.Color:ToHSV()
            v10.Color = Color3.fromHSV(v11, 0, v12 * 0.5)
        elseif v10:IsA("ParticleEmitter") or (v10:IsA("Beam") or v10:IsA("Trail")) then
            v10:Destroy()
        end
    end
    local v_u_13 = p9._is_humanoid and p9._subject.Parent or p9._subject
    local v14 = p9._is_humanoid and p9._subject.RootPart or p9._subject
    local v_u_15 = script.Skull:Clone()
    v_u_15.Parent = v14
    local v16 = p9._destroy_these
    table.insert(v16, v_u_15)
    p9:CreateSound("rbxassetid://117434088219830", 0.75, 1 + 0.1 * math.random(), nil, true, 5)
    local v_u_17 = v_u_13:GetPivot()
    local v18 = p9._connections
    local v19 = v_u_2.RenderStepped
    table.insert(v18, v19:Connect(function(_)
        local v20 = v_u_17
        local v21 = math.random() - 0.5
        local v22 = math.random() - 0.5
        local v23 = math.random() - 0.5
        local v24 = v20 + Vector3.new(v21, v22, v23) * 0.1
        v_u_13:PivotTo(v24)
        local v25 = v_u_15
        local v26 = CFrame.new(workspace.CurrentCamera.CFrame.Position, v24.Position).LookVector
        local v27 = (workspace.CurrentCamera.CFrame.Position - v24.Position).Magnitude * 0.5
        v25.CFrame = v24 + v26 * -math.min(3, v27)
    end))
end
function v_u_4._Init(_) end
return v_u_4