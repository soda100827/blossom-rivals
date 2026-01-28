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
    local v9 = p8._is_humanoid and p8._subject.RootPart or p8._subject
    v9.Anchored = true
    wait(2.55)
    local v10 = p8:_GetObjects(true)
    local v11 = p8:_GetGroundPosition(v9.Position, v10)
    local v12 = v9.CFrame
    local v13 = CFrame.new(v11 + Vector3.new(0, -16, 0)) * v12.Rotation
    local v14 = tick()
    while tick() < v14 + 0.25 do
        local v15 = (tick() - v14) / 0.25
        v9.CFrame = v12:Lerp(v13, math.clamp(v15, 0, 1) ^ 2)
        v_u_2.Heartbeat:Wait()
    end
    wait(0.25)
    v9.Anchored = false
    p8:_Ragdoll()
    p8:_AnchorModel()
    wait(0.5)
end
function v_u_4.PlayClient(p_u_16)
    if p_u_16._is_humanoid then
        local v17 = Instance.new("Animation")
        v17.AnimationId = "rbxassetid://82538222745985"
        local v18, v19 = pcall(p_u_16._subject.LoadAnimation, p_u_16._subject, v17)
        if v18 then
            v19:Play(0)
        end
    end
    local v20 = script.Hole:Clone()
    v20.Parent = workspace
    local v21 = p_u_16._destroy_these
    table.insert(v21, v20)
    local v22 = p_u_16:_GetObjects(true)
    table.insert(v22, v20)
    p_u_16:CreateSound("rbxassetid://93213527475361", 1, 1, nil, true, 5)
    p_u_16:_InternalThread(task.defer, function()
        wait(2.4499999999999997)
        p_u_16:CreateSound("rbxassetid://128064423147007", 1, 0.875, nil, true, 5)
        wait(0.6)
        p_u_16:CreateSound("rbxassetid://128064423147007", 0.375, 1.5, nil, true, 5)
    end)
    local v23 = (p_u_16._is_humanoid and p_u_16._subject.RootPart or p_u_16._subject).Position
    local v24 = tick()
    while tick() < v24 + 2.55 + 0.25 + 0.5 do
        local v25
        if tick() < v24 + 2.55 + 0.25 then
            local v26 = (tick() - v24) / 2.55
            v25 = math.clamp(v26, 0, 1)
        else
            local v27 = (tick() - v24 - 2.55 - 0.25) / 0.5
            v25 = math.clamp(v27, 0, 1)
        end
        local v28
        if tick() < v24 + 2.55 + 0.25 then
            v28 = v25 < 0.5 and v25 ^ 5 * 16 or 1 - (v25 * -2 + 2) ^ 5 / 2
        else
            v28 = 1 - v25 ^ 5
        end
        v20.Size = (Vector3.new(0, 0, 0)):Lerp(Vector3.new(0.5, 12, 12), v28)
        v20.CFrame = CFrame.new(p_u_16:_GetGroundPosition(v23, v22)) * CFrame.Angles(0, 0, 1.5707963267948966)
        v_u_2.RenderStepped:Wait()
    end
    v20:Destroy()
end
function v_u_4._Init(_) end
return v_u_4