local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("UserInputService")
local v_u_3 = game:GetService("HttpService")
local v_u_4 = game:GetService("RunService")
local v_u_5 = game:GetService("Players")
local v_u_6 = require(v1.Modules.GameplayUtility)
local v_u_7 = require(v1.Modules.Utility)
local v_u_8 = require(v1.Modules.Spring)
local v_u_9 = {}
v_u_9.__index = v_u_9
function v_u_9.new(p10)
    local v11
    if typeof(p10) == "Instance" then
        v11 = p10:IsA("BasePart")
    else
        v11 = false
    end
    local v12 = "Argument 1 invalid, expected a BasePart, got " .. tostring(p10)
    assert(v11, v12)
    local v13 = v_u_9
    local v14 = setmetatable({}, v13)
    v14.Part = p10
    v14.Active = false
    v14.Character = nil
    v14.Spring = v_u_8.new(0)
    v14._id = v_u_3:GenerateGUID(false)
    v14._destroying_connection = {}
    v14._active_connections = {}
    v14._align_position = Instance.new("AlignPosition")
    v14._original_cframe = v14.Part.CFrame
    v14._c0 = v14.Part.CFrame * CFrame.new(0, -v14.Part.Size.Y / 2, 0)
    v14._c1 = v14.Part.CFrame * CFrame.new(0, v14.Part.Size.Y / 2, 0)
    v14._projection_length = ((v14._c0.Position - v14._c1.Position) * Vector3.new(1, 0, 1)).Magnitude
    v14._cooldown = 0
    v14._platform = Instance.new("Part")
    v14._visuals = {}
    v14._beam0 = nil
    v14._beam1 = nil
    v14._start_time = 0
    v14._touched_cooldowns = {}
    v14:_Init()
    return v14
end
function v_u_9.JumpOff(p15)
    if p15.Active then
        local v16 = p15.Spring.Velocity
        local v17 = math.max(0, v16) ^ 2 * 0.25
        local v18 = math.min(25, v17)
        local v19 = p15.Character.HumanoidRootPart
        local v20 = v18 + 25
        v19.Velocity = Vector3.new(0, v20, 0)
        p15._cooldown = tick() + 0.5
        p15:Disable()
    end
end
function v_u_9.Enable(p_u_21)
    if not p_u_21.Active then
        p_u_21.Active = true
        p_u_21.Character = v_u_5.LocalPlayer.Character
        p_u_21.Spring.Value = p_u_21.Character.HumanoidRootPart.Velocity.Y / 20
        p_u_21.Character.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
        p_u_21._platform.CanCollide = true
        p_u_21._platform.CFrame = p_u_21.Character.HumanoidRootPart.CFrame - Vector3.new(0, 3, 0)
        p_u_21._beam0.Width1 = p_u_21._beam0.Width0 * 0.25
        p_u_21._beam1.Width1 = p_u_21._beam1.Width0 * 0.25
        p_u_21._start_time = tick()
        local v22 = p_u_21._active_connections
        local v23 = v_u_2.JumpRequest
        table.insert(v22, v23:Connect(function()
            p_u_21:JumpOff()
        end))
        local v24 = p_u_21._active_connections
        local v25 = p_u_21.Character.Humanoid.Died
        table.insert(v24, v25:Connect(function()
            p_u_21:Disable()
        end))
        local v26 = p_u_21._active_connections
        local v27 = p_u_21.Character.AncestryChanged
        table.insert(v26, v27:Connect(function()
            if not p_u_21.Character:IsDescendantOf(workspace) then
                p_u_21:Disable()
            end
        end))
        v_u_4:BindToRenderStep("Tightrope - " .. p_u_21._id, Enum.RenderPriority.Camera.Value - 1, function(_)
            local v28 = p_u_21.Spring.Value - 2
            local v29 = p_u_21.Character.HumanoidRootPart.CFrame
            local v30 = ((v29.Position - p_u_21._c0.Position) * Vector3.new(1, 0, 1)).Magnitude / p_u_21._projection_length
            local v31 = p_u_21._c0.Position:Lerp(p_u_21._c1.Position, v30)
            local v32 = 0.25 / p_u_21._projection_length
            local v33 = CFrame.new(v31) * (p_u_21._original_cframe - p_u_21._original_cframe.Position) + Vector3.new(0, v28, 0)
            local v34 = p_u_21._platform.CFrame:Lerp(v33, 0.1)
            if v30 < v32 or 1 - v32 < v30 then
                p_u_21:Disable()
                return
            else
                local v35 = CFrame.new
                local v36 = v29.Position
                local v37 = 2 * (tick() - p_u_21._start_time)
                local v38 = v35(v36:Lerp(v31, (math.min(1, v37))) * Vector3.new(1, 0, 1)) * CFrame.new(0, v34.Y + 3, 0) * (v29 - v29.Position)
                if (v38.Position - p_u_21.Character.HumanoidRootPart.CFrame.Position).Magnitude > 32 then
                    p_u_21:Disable()
                else
                    p_u_21.Character.HumanoidRootPart.CFrame = v38
                    p_u_21._platform.CFrame = CFrame.new(v31.X, v34.Y, v31.Z) * (p_u_21._original_cframe - p_u_21._original_cframe.Position)
                end
            end
        end)
    end
end
function v_u_9.Disable(p39)
    if p39.Active then
        p39.Active = false
        p39.Character = nil
        p39._platform.CFrame = p39._original_cframe
        p39._platform.CanCollide = false
        p39._beam0.Width1 = p39._beam0.Width0
        p39._beam1.Width1 = p39._beam1.Width0
        for _, v40 in pairs(p39._active_connections) do
            v40:Disconnect()
        end
        p39._active_connections = {}
        v_u_4:UnbindFromRenderStep("Tightrope - " .. p39._id)
    end
end
function v_u_9.Destroy(p41)
    p41:Disable()
    p41.Part.CFrame = p41._original_cframe
    p41._platform:Destroy()
    for _, v42 in pairs(p41._visuals) do
        v42:Destroy()
    end
    p41._visuals = {}
    p41._destroying_connection:Disconnect()
    p41._destroying_connection = nil
end
function v_u_9._GetPositionAlongTightrope(p43, p44)
    local v45 = p43._c0.Position
    local v46 = p43._c1.Position - v45
    local v47 = Ray.new(p43._c0.Position, v46.Unit):ClosestPoint(p44)
    local v48 = v46.Unit
    local v49 = v46.Magnitude
    local v50 = (v47 - v45).Magnitude
    return v45 + v48 * math.min(v49, v50)
end
function v_u_9._Touched(p_u_51, p52)
    local v_u_53 = p52.AssemblyRootPart or p52
    if p_u_51.Active or (p_u_51._touched_cooldowns[v_u_53] or tick() < p_u_51._cooldown) then
        return
    else
        p_u_51._touched_cooldowns[v_u_53] = true
        task.delay(0.25, function()
            p_u_51._touched_cooldowns[v_u_53] = nil
        end)
        if v_u_5:GetPlayerFromCharacter(v_u_53.Parent) == v_u_5.LocalPlayer and (v_u_53.Parent:FindFirstChild("Humanoid") and v_u_53.Parent.Humanoid.Health > 0) then
            local v54 = p_u_51:_GetPositionAlongTightrope(v_u_53.Position)
            local v55 = v_u_6:GetRaycastWhitelist(v_u_53.Parent:GetAttribute("EnvironmentID"))
            local v56 = v_u_7:Raycast(v_u_53.Position, v54, (v54 - v_u_53.Position).Magnitude, v55, Enum.RaycastFilterType.Include)
            if not v56.Instance or (v56.Instance == p_u_51.Part or v56.Instance == p_u_51._platform) then
                p_u_51:Enable()
            end
        end
    end
end
function v_u_9._Setup(p57)
    p57.Part.Transparency = 1
    p57.Part.CanCollide = false
    p57.Part.Anchored = true
    p57._platform.Color = Color3.fromRGB(200, 200, 200)
    p57._platform.Transparency = 1
    p57._platform.Anchored = true
    p57._platform.CanCollide = false
    p57._platform.Size = Vector3.new(0.1, 1, 1)
    p57._platform.CFrame = p57._original_cframe
    p57._platform.Parent = p57.Part
    p57.Spring.Damper = 0.25
    p57.Spring.Speed = 8
    p57.Spring.Target = 0
    local v58 = Instance.new("Attachment")
    v58.Parent = p57.Part
    v58.WorldPosition = p57._c0.Position
    local v59 = p57._visuals
    table.insert(v59, v58)
    local v60 = Instance.new("Attachment")
    v60.Parent = p57.Part
    v60.WorldPosition = p57._c1.Position
    local v61 = p57._visuals
    table.insert(v61, v60)
    local v62 = Instance.new("Attachment")
    v62.Parent = p57._platform
    local v63 = p57._visuals
    table.insert(v63, v62)
    local v64 = Instance.new("Beam")
    v64.Width0 = p57.Part.Size.X
    v64.Width1 = p57.Part.Size.X
    v64.FaceCamera = true
    v64.Transparency = NumberSequence.new(0)
    v64.Color = ColorSequence.new(p57.Part.Color)
    v64.LightInfluence = 1
    v64.Attachment0 = v58
    v64.Attachment1 = v62
    v64.Parent = p57._platform
    local v65 = p57._visuals
    table.insert(v65, v64)
    local v66 = v64:Clone()
    v66.Attachment0 = v60
    v66.Parent = p57._platform
    local v67 = p57._visuals
    table.insert(v67, v66)
    p57._beam0 = v64
    p57._beam1 = v66
end
function v_u_9._Init(p_u_68)
    p_u_68._destroying_connection = p_u_68.Part.Destroying:Connect(function()
        p_u_68:Destroy()
    end)
    p_u_68.Part.Touched:Connect(function(p69)
        p_u_68:_Touched(p69)
    end)
    p_u_68:_Setup()
end
return v_u_9