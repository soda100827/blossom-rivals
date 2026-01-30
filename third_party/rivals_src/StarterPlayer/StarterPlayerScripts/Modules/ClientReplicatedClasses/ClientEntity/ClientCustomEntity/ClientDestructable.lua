local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.Utility)
local v_u_4 = require(v2.LocalPlayer.PlayerScripts.Modules.ClientReplicatedClasses.ClientEntity.ClientCustomEntity)
local v_u_5 = v2.LocalPlayer.PlayerScripts.Assets.Destructables.ShatterVisuals
local v_u_6 = v2.LocalPlayer.PlayerScripts.Assets.Destructables.Visuals
local v_u_7 = CFrame.Angles(0, 1.5707963267948966, 0)
local v_u_8 = setmetatable({}, v_u_4)
v_u_8.__index = v_u_8
function v_u_8.new(...)
    local v9 = v_u_4.new(...)
    local v10 = v_u_8
    local v11 = setmetatable(v9, v10)
    v11.AimAssistBlacklist = true
    v11._shatter_template = v_u_5:FindFirstChild(v11.Model.Name)
    v11._death_animation_override = true
    v11._death_sound_override = true
    v11._visual = nil
    v11._always_face_camera = v11.Model:GetAttribute("AlwaysFaceCamera") or false
    v11._shatter_sound_id = v11.Model:GetAttribute("ShatterSoundID") or (v11._shatter_template and (v11._shatter_template:GetAttribute("ShatterSoundID") or "rbxassetid://14441658101") or "rbxassetid://14441658101")
    v11._next_update = 0
    v11:_Init()
    return v11
end
function v_u_8._ExplosiveBarrelDeathEffect(p12, _)
    for _, v13 in pairs(p12.Model:GetDescendants()) do
        if v13.Name == "Rubble" then
            v13.Transparency = 0
            v13.CanCollide = true
        elseif v13:IsA("BasePart") then
            v13.Transparency = 1
            v13.CanCollide = false
        elseif v13:IsA("Decal") then
            v13.Transparency = 1
        end
    end
end
function v_u_8._ShatterEffect(p14, p15)
    local v16 = p14._visual and p14._visual.CFrame * v_u_7:Inverse() * CFrame.Angles(0, 6.283185307179586 * math.random(), 0) or p14.Model:GetPivot()
    p14.Model:ClearAllChildren()
    local v17 = p14._shatter_template:Clone()
    v17.Parent = p14.Model
    v17.PrimaryPart = v17.Primary
    v17:PivotTo(v16)
    v17.PrimaryPart:Destroy()
    local v18 = Random.new()
    for _, v19 in pairs(v17:GetChildren()) do
        local v20 = CFrame.new(p14.RootPart.Position, v19.Position).LookVector
        local v21 = v20.X
        local v22 = v20.Y
        local v23 = math.max(0, v22) * 2
        local v24 = v20.Z
        local v25 = Vector3.new(v21, v23, v24) * (10 + 10 * math.random())
        v19.CanCollide = true
        v19.CanTouch = false
        v19.Anchored = false
        v19.RotVelocity = v18:NextUnitVector() * 25 * math.random()
        v19.Velocity = v25
        for _, v26 in pairs(v17:GetChildren()) do
            if v26 ~= v19 then
                local v27 = Instance.new("NoCollisionConstraint")
                v27.Part0 = v19
                v27.Part1 = v26
                v27.Parent = v19
            end
        end
    end
    if not p15 then
        v_u_3:CreateSound(p14._shatter_sound_id, 0.625 + 0.25 * math.random(), 1.5 + 0.5 * math.random(), v16.Position, true, 10)
    end
    if p14._visual then
        p14._visual:Destroy()
        p14._visual = nil
    end
end
function v_u_8._CheckDead(p28, p29)
    if p28:IsAlive() then
        return
    elseif p28.Model.Name == "Explosive Barrel" then
        p28:_ExplosiveBarrelDeathEffect(p29)
    else
        p28:_ShatterEffect(p29)
    end
end
function v_u_8._Setup(p30)
    local v31 = v_u_6:FindFirstChild(p30.Model.Name)
    if v31 then
        p30._visual = v31:Clone()
        p30._visual.CanCollide = false
        p30._visual.CanQuery = false
        p30._visual.CanTouch = false
        p30._visual.Anchored = true
        p30._visual.Parent = p30.Model
    end
end
function v_u_8._Init(p_u_32)
    p_u_32.Died:Connect(function()
        p_u_32:_CheckDead()
    end)
    p_u_32:_Setup()
    task.defer(p_u_32._CheckDead, p_u_32, true)
end
return v_u_8