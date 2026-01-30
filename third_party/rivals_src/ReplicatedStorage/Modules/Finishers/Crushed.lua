local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("RunService")
local v_u_3 = game:GetService("Players")
local v_u_4 = require(v1.Modules.Finishers.Ragdoll)
local v_u_5 = require(v1.Modules.Utility)
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
    local v11 = p10._is_humanoid and p10._subject.RootPart or p10._subject
    wait(0.5)
    p10:_HideBody({ v11 })
end
function v_u_6.PlayClient(p12, ...)
    v_u_4.PlayClient(p12, ...)
    local v13 = p12._is_humanoid and p12._subject.Parent or p12._subject
    v13.Archivable = true
    local v14 = v13:Clone()
    local v15 = p12._destroy_these
    table.insert(v15, v14)
    local v_u_16 = p12:_GetTemplate():Clone()
    v_u_16.Parent = workspace
    local v17 = p12._destroy_these
    table.insert(v17, v_u_16)
    local v18 = v_u_16:FindFirstChild("Broken")
    if v18 then
        for _, v19 in pairs(v18:GetDescendants()) do
            if v19:IsA("BasePart") then
                v19.LocalTransparencyModifier = 1
            end
        end
    end
    local v_u_20 = p12._is_humanoid and p12._subject.RootPart or p12._subject
    local v_u_21 = CFrame.Angles(0, math.random() * 3.141592653589793 * 2, 0)
    local v_u_22 = tick()
    local v32 = v_u_2.Heartbeat:Connect(function()
        local v23 = CFrame.new(v_u_20.Position)
        local v24, v25, v26
        if tick() < v_u_22 + 0.5 then
            local v27 = (tick() - v_u_22) / 0.5
            v24 = math.clamp(v27, 0, 1)
            v25 = v23 * (v_u_21 * CFrame.Angles(0, 3.141592653589793, 0):Lerp(CFrame.identity, v24 ^ 6))
            v26 = Vector3.new(0, 128, 0)
        else
            local v28 = (tick() - v_u_22 - 0.5) / 0.5
            local v29 = math.clamp(v28, 0, 1)
            local v30 = 4.71238898038469 * v29
            local v31 = math.sin(v30) * (1 - v29)
            v24 = 1 - math.abs(v31)
            v25 = v23 * (v_u_21 * CFrame.identity:Lerp(CFrame.Angles(0, 2.827433388230814, 0), 1 - (1 - v29) ^ 6))
            v26 = Vector3.new(0, 12, 0)
        end
        v_u_16:PivotTo(v25 + v26:Lerp(Vector3.new(0, 0, 0), v24))
    end)
    local v33 = p12._connections
    table.insert(v33, v32)
    wait(0.5)
    if v18 then
        v_u_16.Normal:Destroy()
        for _, v34 in pairs(v18:GetDescendants()) do
            if v34:IsA("BasePart") then
                v34.LocalTransparencyModifier = 0
            end
        end
    end
    local v35 = Instance.new("Camera")
    local v36 = script.Flattened:Clone()
    v36.CFrame = CFrame.new(v_u_20.Position)
    v36.Parent = workspace
    local v37 = p12._destroy_these
    table.insert(v37, v36)
    for _, v38 in pairs({ v_u_16:GetDescendants(), p12:_GetObjects(true) }) do
        for _, v39 in pairs(v38) do
            if v39:IsA("BasePart") then
                local v40 = Instance.new("NoCollisionConstraint")
                v40.Part0 = v39
                v40.Part1 = v36
                v40.Parent = v36
            end
        end
    end
    for _, v41 in pairs(v36:GetDescendants()) do
        if v41:IsA("ParticleEmitter") then
            v_u_5:ScaleParticleEmitter(v41, 2)
        end
    end
    v_u_5:PlayParticles(v36)
    local v42 = v36.SurfaceGui
    v42.ViewportFrame.CurrentCamera = v35
    v42.Adornee = v36
    v42.Parent = v_u_3.LocalPlayer.PlayerGui
    local v43 = p12._destroy_these
    table.insert(v43, v42)
    local v44 = v14:Clone()
    v44:PivotTo(v44:GetPivot().Rotation)
    v44.Parent = v42.ViewportFrame
    v35.CFrame = CFrame.new(Vector3.new(0, 15, 0), Vector3.new(0, 0, 0)) * CFrame.Angles(0, 0, 3.141592653589793)
    v35.FieldOfView = 30
    v35.Parent = v42.ViewportFrame
    p12:CreateSound("rbxassetid://122470995632560", 1, 1, nil, true, 5)
    p12:CreateSound("rbxassetid://88491524279903", 1, 1, nil, true, 5)
    if v_u_16.Name == "Piano" then
        p12:CreateSound("rbxassetid://129097983310355", 1, 0.75 + 0.5 * math.random(), nil, true, 5)
    end
    wait(0.5)
    v32:Disconnect()
    wait(3)
end
function v_u_6._GetSortedChildren(_)
    local v45 = script.Models:GetChildren()
    table.sort(v45, function(p46, p47)
        return v_u_5:StringLessThan(p46.Name, p47.Name)
    end)
    return v45
end
function v_u_6._GetTemplate(p48)
    local v49 = p48:_GetSortedChildren()
    return v49[Random.new(p48._serial and p48._serial.Seed or p48._seed):NextInteger(1, #v49)]
end
function v_u_6._Init(_) end
return v_u_6