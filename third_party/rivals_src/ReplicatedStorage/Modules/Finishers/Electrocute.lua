local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = require(v1.Modules.Finisher)
local v_u_3 = require(v1.Modules.Utility)
local v_u_4 = setmetatable({}, v_u_2)
v_u_4.__index = v_u_4
function v_u_4.new(...)
    local v5 = v_u_2.new(...)
    local v6 = v_u_4
    local v7 = setmetatable(v5, v6)
    v7:_Init()
    return v7
end
function v_u_4.PlayServer(p8, ...)
    if p8._is_humanoid then
        p8._subject.RootPart.Anchored = true
    end
    wait(1.7999999999999998)
    if p8._is_humanoid then
        p8._subject.RootPart.Anchored = false
    end
    p8:_Ragdoll()
    p8:_AnchorModel()
end
function v_u_4.PlayClient(p9, ...)
    local v10 = {}
    for _, v11 in pairs(p9:_GetObjects()) do
        if v11:IsA("BasePart") and v11.Transparency <= 0 then
            local v12 = script[v11.Name == "Head" and "Head" or "Limb"]:Clone()
            v12.Size = v11.Size
            v12.CFrame = v11.CFrame
            v12.Parent = v11
            table.insert(v10, v12)
            local v13 = p9._destroy_these
            table.insert(v13, v12)
            local v14 = Instance.new("WeldConstraint")
            v14.Part0 = v11
            v14.Part1 = v12
            v14.Parent = v12
            if v11.Name == "Head" then
                local v15 = script.Face:Clone()
                v15.CFrame = v11.CFrame
                v15.Parent = v11
                local v16 = v15.Decal
                table.insert(v10, v16)
                local v17 = p9._destroy_these
                table.insert(v17, v15)
                local v18 = Instance.new("WeldConstraint")
                v18.Part0 = v11
                v18.Part1 = v15
                v18.Parent = v15
            end
        end
    end
    local v19 = p9._is_humanoid
    if v19 then
        v19 = p9._subject.Parent:FindFirstChild("face", true)
    end
    if v19 then
        v19:Destroy()
    end
    local v20 = {}
    local v21 = {}
    for _, v22 in pairs(p9:_GetObjects(true)) do
        if v22:IsA("BasePart") or v22:IsA("Decal") then
            v20[v22] = v22.Transparency
            if v22:IsA("BasePart") then
                local v23 = script.Particles.Enabled:Clone()
                v23.Parent = v22
                local v24 = p9._destroy_these
                table.insert(v24, v23)
                table.insert(v21, v23)
                for _, v25 in pairs(v23:GetChildren()) do
                    v_u_3:ScaleParticleEmitter(v25, 0.5)
                end
                local v26 = script.Particles.Smoke:Clone()
                v26.Parent = v22
                local v27 = p9._destroy_these
                table.insert(v27, v26)
            end
        end
    end
    p9:CreateSound("rbxassetid://79646963478511", 0.75, 1, nil, true, 5)
    for _ = 1, 15 do
        for v28, _ in pairs(v20) do
            v28.Transparency = 1
        end
        for _, v29 in pairs(v10) do
            v29.Transparency = 0
        end
        wait(0.08)
        for v30, v31 in pairs(v20) do
            v30.Transparency = v31
        end
        for _, v32 in pairs(v10) do
            v32.Transparency = 1
        end
        wait(0.04)
    end
    for _, v33 in pairs(v21) do
        v33:Destroy()
    end
    for _, v34 in pairs(v10) do
        v34:Destroy()
    end
    for _, v35 in pairs(p9:_GetObjects(true)) do
        if v35:IsA("BasePart") then
            v35.Color = Color3.fromRGB(30, 30, 30)
            v35.Material = Enum.Material.Grass
            v35.Reflectance = 0
            v35.MaterialVariant = ""
            if v35:IsA("MeshPart") then
                v35.TextureID = ""
            end
        elseif v35:IsA("Beam") or (v35:IsA("Trail") or (v35:IsA("Texture") or (v35:IsA("Decal") or (v35:IsA("Clothing") or v35:IsA("ShirtGraphic"))))) then
            v35:Destroy()
        end
    end
end
function v_u_4._Init(_) end
return v_u_4