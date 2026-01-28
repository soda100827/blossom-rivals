local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("RunService")
local v_u_3 = game:GetService("Players")
local v_u_4 = require(v1.Modules.Finisher)
local v_u_5 = require(v1.Modules.Utility)
local v_u_6 = require(v1.Modules.Spring)
local v_u_7 = setmetatable({}, v_u_4)
v_u_7.__index = v_u_7
function v_u_7.new(...)
    local v8 = v_u_4.new(...)
    local v9 = v_u_7
    local v10 = setmetatable(v8, v9)
    v10:_Init()
    return v10
end
function v_u_7.PlayServer(p11)
    p11:_AnchorModel(0)
    wait(0.3)
    p11:_HideBody()
end
function v_u_7.PlayClient(p12)
    local v13 = p12._is_humanoid and p12._subject.RootPart or p12._subject
    local v14 = CFrame.Angles(0, math.random() * 3.141592653589793 * 2, 0)
    local v15 = p12._is_humanoid and p12._subject.Parent or p12._subject
    v15.Archivable = true
    local v16 = v15:Clone()
    local v17 = p12._destroy_these
    table.insert(v17, v16)
    local v18 = script.Model:Clone()
    v18.Parent = workspace
    local v19 = p12._destroy_these
    table.insert(v19, v18)
    local v20 = v18.Left:GetPivot():ToObjectSpace(v18.PrimaryPart.CFrame):Inverse()
    local v21 = v18.Right:GetPivot():ToObjectSpace(v18.PrimaryPart.CFrame):Inverse()
    local v22 = v_u_6.new(v13.Position, 1, 10)
    local v23 = v18.Right.Size
    local v24 = v18.Left.Size
    local v25 = tick()
    while tick() < v25 + 0.3 do
        local v26 = (tick() - v25) / 0.3
        local v27 = math.clamp(v26, 0, 1) ^ 2
        v22.Target = v13.Position
        v18.PrimaryPart.CFrame = CFrame.new(v22.Value) * v14
        v18.Right.Size = v23 * (v27 * 1 + 1)
        v18.Left.Size = v24 * (v27 * 1 + 1)
        v18.Right:PivotTo(v18.PrimaryPart.CFrame * v21 * CFrame.Angles(0, 0, v27 * -2.356194490192345))
        v18.Left:PivotTo(v18.PrimaryPart.CFrame * v20 * CFrame.Angles(0, 0, v27 * 2.356194490192345))
        v_u_2.RenderStepped:Wait()
    end
    p12:CreateSound("rbxassetid://100411689677104", 1.5, 1, v18.Primary, true, 5)
    p12:CreateSound("rbxassetid://92760487729234", 2.5, 1, v18.Primary, true, 5)
    v_u_5:PlayParticles(v18)
    local v28 = script.Flattened:Clone()
    v28.CFrame = CFrame.new(v13.Position) * v14
    v28.RotVelocity = Vector3.new(0, 20, 0) + Random.new():NextUnitVector() * 5
    v28.Parent = workspace
    local v29 = p12._destroy_these
    table.insert(v29, v28)
    for _, v30 in pairs(p12:_GetObjects(true)) do
        if v30:IsA("BasePart") then
            local v31 = Instance.new("NoCollisionConstraint")
            v31.Part0 = v30
            v31.Part1 = v28
            v31.Parent = v28
        end
    end
    local v32 = { v14 * CFrame.new(0, 0, 15), v14 * CFrame.Angles(0, 3.141592653589793, 0) * CFrame.new(0, 0, 15) }
    for v33, v34 in pairs(v32) do
        local v35 = Instance.new("Camera")
        local v36 = v28[v33]
        v36.ViewportFrame.CurrentCamera = v35
        v36.Adornee = v28
        v36.Parent = v_u_3.LocalPlayer.PlayerGui
        local v37 = v16:Clone()
        v37:PivotTo(v37:GetPivot().Rotation)
        v37.Parent = v36.ViewportFrame
        v35.CFrame = CFrame.new(v34.Position, Vector3.new(0, 0, 0))
        v35.FieldOfView = 30
        v35.Parent = v36.ViewportFrame
    end
    local v38 = v18:GetPivot()
    local v39 = tick()
    while tick() < v39 + 0.1 do
        local v40 = math.random() - 0.5
        local v41 = math.random() - 0.5
        local v42 = math.random() - 0.5
        v18:PivotTo(v38 + Vector3.new(v40, v41, v42) * math.random() * 1)
        v_u_2.RenderStepped:Wait()
    end
    for _, v43 in pairs(v18:GetDescendants()) do
        if v43:IsA("BasePart") then
            v43.Anchored = false
        end
    end
end
function v_u_7._Init(_) end
return v_u_7