local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("RunService")
require(v1.Modules.BetterDebris)
local v_u_3 = require(v1.Modules.Finisher)
local v_u_4 = {
    "rbxassetid://91261888651237",
    "rbxassetid://116627376811943",
    "rbxassetid://131046967935934",
    "rbxassetid://98510973512946",
    "rbxassetid://102276174123211",
    "rbxassetid://119206791261589",
    "rbxassetid://85250994493837",
    "rbxassetid://80578622827590",
    "rbxassetid://108990615121442",
    "rbxassetid://123917383226893"
}
local v_u_5 = setmetatable({}, v_u_3)
v_u_5.__index = v_u_5
function v_u_5.new(...)
    local v6 = v_u_3.new(...)
    local v7 = v_u_5
    local v8 = setmetatable(v6, v7)
    v8:_Init()
    return v8
end
function v_u_5.PlayServer(p9)
    if p9._is_humanoid then
        local v10 = p9._subject
        v10.HipHeight = v10.HipHeight + 1.5
        local v11 = p9._subject.RootPart
        local v12 = Instance.new("BodyGyro")
        v12.CFrame = CFrame.new(Vector3.new(0, 0, 0), v11.CFrame.LookVector * Vector3.new(1, 0, 1))
        v12.MaxTorque = Vector3.new(100000, 100000, 100000)
        v12.Parent = v11
        local v13 = p9._destroy_these
        table.insert(v13, v12)
        local v14 = Instance.new("Animation")
        v14.AnimationId = p9:_GetAnimationID()
        local v15, v16 = pcall(p9._subject.LoadAnimation, p9._subject, v14)
        if v15 then
            v16:Play(0)
        end
        wait(1.5)
        p9:_AnchorModel(0)
    end
end
function v_u_5.PlayClient(p_u_17)
    if p_u_17._is_humanoid then
        for _, v18 in pairs(p_u_17:_GetObjects(true)) do
            if v18:IsA("BasePart") then
                v18.Color = Color3.fromRGB(105, 104, 106)
                v18.Material = Enum.Material.SmoothPlastic
                v18.MaterialVariant = ""
                if v18:IsA("MeshPart") then
                    v18.TextureID = ""
                end
            elseif v18:IsA("ParticleEmitter") or (v18:IsA("Beam") or (v18:IsA("Trail") or (v18:IsA("Texture") or (v18:IsA("Decal") or (v18:IsA("Clothing") or v18:IsA("ShirtGraphic")))))) then
                v18:Destroy()
            end
        end
        local v19 = Instance.new("Animation")
        v19.AnimationId = p_u_17:_GetAnimationID()
        local v_u_20 = script.Model:Clone()
        v_u_20.PrimaryPart = v_u_20.HumanoidRootPart
        v_u_20:PivotTo(p_u_17._subject.RootPart.CFrame)
        v_u_20.Parent = workspace
        local v21 = p_u_17._destroy_these
        table.insert(v21, v_u_20)
        for _, v22 in pairs(v_u_20:GetDescendants()) do
            if v22:IsA("BasePart") then
                v22.CollisionGroup = "Noclip"
            end
        end
        local v23, v24 = pcall(v_u_20.AnimationController.LoadAnimation, v_u_20.AnimationController, v19)
        if v23 then
            v24:Play(0)
        end
        local v25 = v_u_2.RenderStepped:Connect(function()
            v_u_20:PivotTo(p_u_17._subject.RootPart.CFrame * CFrame.new(0, 2.25, 0))
        end)
        local v26 = p_u_17._connections
        table.insert(v26, v25)
        p_u_17:CreateSound("rbxassetid://90323515241815", 1, 1 + 0.1 * math.random(), nil, true, 5)
        wait(1.5)
        v25:Disconnect()
        for _, v27 in pairs(v_u_20:GetDescendants()) do
            if v27:IsA("BasePart") then
                v27.Anchored = true
            end
        end
    end
end
function v_u_5._GetAnimationID(p28)
    return v_u_4[Random.new(p28._serial and p28._serial.Seed or p28._seed):NextInteger(1, #v_u_4)]
end
function v_u_5._Init(_) end
return v_u_5