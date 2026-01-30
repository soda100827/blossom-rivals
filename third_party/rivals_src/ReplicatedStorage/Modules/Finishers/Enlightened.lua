local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("RunService")
local v_u_3 = require(v1.Modules.Finisher)
local v_u_4 = require(v1.Modules.Utility)
local v_u_5 = Color3.fromRGB(255, 255, 255)
local v_u_6 = setmetatable({}, v_u_3)
v_u_6.__index = v_u_6
function v_u_6.new(...)
    local v7 = v_u_3.new(...)
    local v8 = v_u_6
    local v9 = setmetatable(v7, v8)
    v9:_Init()
    return v9
end
function v_u_6.PlayServer(p_u_10)
    p_u_10:_AnchorModel(0)
    p_u_10:_InternalThread(task.delay, 2, function()
        p_u_10:_AnchorModel(0, false)
        p_u_10:_AnchorModel()
        p_u_10:_BreakJoints()
        for _, v11 in pairs(p_u_10:_GetObjects()) do
            if v11:IsA("Clothing") then
                v11:Destroy()
            end
            if v11:IsA("BasePart") then
                for _, v12 in pairs(v11:GetChildren()) do
                    if v12:IsA("Texture") or v12:IsA("Decal") then
                        v12:Destroy()
                    end
                end
                v11.Material = Enum.Material.Neon
                local v13 = Instance.new("BodyForce")
                v13.Force = Vector3.new(0, 1, 0) * workspace.Gravity * v11:GetMass() * (1.25 + 0.5 * math.random())
                v13.Parent = v11
                local v14 = math.random() - 0.5
                local v15 = math.random() - 0.5
                v11.Velocity = Vector3.new(v14, 0, v15).Unit * 80 * math.random()
                local v16 = math.random() - 0.5
                local v17 = math.random() - 0.5
                local v18 = math.random() - 0.5
                v11.RotVelocity = Vector3.new(v16, v17, v18) * 180 * math.random()
                v11.CFrame = v11.CFrame * CFrame.Angles(math.random() * 3.141592653589793 * 2, math.random() * 3.141592653589793 * 2, math.random() * 3.141592653589793 * 2)
            end
        end
    end)
end
function v_u_6.PlayClient(p_u_19, ...)
    local v_u_20 = p_u_19._is_humanoid and p_u_19._subject.Parent or p_u_19._subject
    local v21 = p_u_19._is_humanoid and p_u_19._subject.Parent.Head or p_u_19._subject
    local v22 = p_u_19._is_humanoid and p_u_19._subject.RootPart or p_u_19._subject
    local v_u_23 = v_u_20:GetPivot()
    local v_u_24 = tick()
    local v_u_25 = {}
    local v_u_26 = {}
    local v27 = p_u_19._connections
    local v28 = v_u_2.RenderStepped
    local function v41(_)
        if tick() < v_u_24 + 2 then
            local v29 = (tick() - v_u_24) / 2
            local v30 = math.clamp(v29, 0, 1)
            local v31 = v_u_20
            local v32 = v_u_23
            local v33 = math.random() - 0.5
            local v34 = math.random() - 0.5
            local v35 = math.random() - 0.5
            v31:PivotTo(v32 + Vector3.new(v33, v34, v35) * 3 * v30 ^ 3)
            for _, v36 in pairs(p_u_19:_GetObjects(true)) do
                if v36:IsA("BasePart") then
                    v_u_26[v36] = v_u_26[v36] or v36.Color
                    v36.Color = v_u_26[v36]:Lerp(v_u_5, v30)
                end
            end
            for _, v37 in pairs(v_u_25) do
                local v38 = (tick() - v_u_24 - v37.AppearDelay) / 0.5
                local v39 = math.clamp(v38, 0, 1)
                for _, v40 in pairs(v37.Object:GetDescendants()) do
                    if v40:IsA("ParticleEmitter") or v40:IsA("Beam") then
                        v40.LocalTransparencyModifier = 1 - v39
                    end
                end
            end
        end
    end
    table.insert(v27, v28:Connect(v41))
    for _, v42 in pairs(script.Head:GetChildren()) do
        local v43 = v42:Clone()
        v43.Parent = v21
        local v44 = p_u_19._destroy_these
        table.insert(v44, v43)
        local v45 = {
            ["AppearDelay"] = 1.5 * math.random(),
            ["Object"] = v43
        }
        table.insert(v_u_25, v45)
    end
    for _, v46 in pairs(p_u_19:_GetObjects(true)) do
        if v46:IsA("BasePart") and (v46.Name ~= "Head" and v46.Transparency <= 0.5) then
            for _ = 1, math.random(2, 6) do
                local v47 = Vector3.FromNormalId(Enum.NormalId:GetEnumItems()[math.random(#Enum.NormalId:GetEnumItems())])
                local v48 = v46.Size * v47 / 2
                local v49 = v46.Size * (Vector3.new(1, 1, 1) - v47 * v47)
                local v50 = v47.Magnitude
                local v51 = v49 * math.sign(v50)
                local v52 = math.random() - 0.5
                local v53 = math.random() - 0.5
                local v54 = math.random() - 0.5
                local v55 = v48 + v51 * Vector3.new(v52, v53, v54)
                local v56 = script.Beam.Finish:Clone()
                v56.Parent = v46
                local v57 = p_u_19._destroy_these
                table.insert(v57, v56)
                local v58 = script.Beam.Start:Clone()
                v58.Position = v55
                v58.Beam1.Attachment1 = v56
                v58.Beam2.Attachment1 = v56
                v58.Beam3.Attachment1 = v56
                v58.Parent = v46
                local v59 = p_u_19._destroy_these
                table.insert(v59, v58)
                local v60 = {
                    ["AppearDelay"] = 1.5 * math.random(),
                    ["Object"] = v58
                }
                table.insert(v_u_25, v60)
                v56.Position = v58.Position + v47 * (0.5 + 1.5 * math.random())
            end
        end
    end
    p_u_19:CreateSound("rbxassetid://104941307595770", 1, 1, nil, true, 5)
    p_u_19:CreateSound("rbxassetid://137299793298455", 1, 1, nil, true, 5)
    wait(2)
    for _, v61 in pairs(v_u_25) do
        v61.Object:Destroy()
    end
    local v62 = script.Explosion:Clone()
    v62.CFrame = v_u_23
    v62.Parent = v22
    local v63 = p_u_19._destroy_these
    table.insert(v63, v62)
    v_u_4:PlayParticles(v62)
    p_u_19:CreateSound("rbxassetid://79678979817013", 1.5, 1, nil, true, 5)
end
function v_u_6._Init(_) end
return v_u_6