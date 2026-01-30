local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("TweenService")
local v_u_3 = game:GetService("RunService")
local v_u_4 = require(v1.Modules.BetterDebris)
local v_u_5 = require(v1.Modules.Finisher)
local v_u_6 = setmetatable({}, v_u_5)
v_u_6.__index = v_u_6
function v_u_6.new(...)
    local v7 = v_u_5.new(...)
    local v8 = v_u_6
    local v9 = setmetatable(v7, v8)
    v9:_Init()
    return v9
end
function v_u_6.PlayServer(p10)
    if p10._is_humanoid then
        p10._subject.RootPart.Anchored = true
        local v11 = p10._subject.RootPart
        v11.CFrame = v11.CFrame * CFrame.Angles(0, math.random() * 3.141592653589793 * 2, 0)
        v_u_2:Create(p10._subject.RootPart, TweenInfo.new(1.6, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
            ["CFrame"] = p10._subject.RootPart.CFrame * CFrame.Angles(0, 3.141592653589793, 0) * CFrame.new(0, 0, -10)
        }):Play()
        local v12 = Instance.new("Animation")
        v12.AnimationId = "rbxassetid://84375821263857"
        local v13, v14 = pcall(p10._subject.LoadAnimation, p10._subject, v12)
        if v13 then
            v14:Play(0)
        end
        wait(1.6)
        p10:_HideBody()
    end
end
function v_u_6.PlayClient(p_u_15)
    if p_u_15._is_humanoid then
        local v16 = Instance.new("Animation")
        v16.AnimationId = "rbxassetid://84375821263857"
        local v_u_17 = script.Model:Clone()
        v_u_17.PrimaryPart = v_u_17.HumanoidRootPart
        v_u_17:PivotTo(p_u_15._subject.RootPart.CFrame)
        v_u_17.Parent = workspace
        local v18 = p_u_15._destroy_these
        table.insert(v18, v_u_17)
        v_u_4:AddItem(v_u_17, 1.6)
        for _, v19 in pairs(v_u_17:GetDescendants()) do
            if v19:IsA("BasePart") then
                v19.CollisionGroup = "Noclip"
            end
        end
        local v20, v21 = pcall(v_u_17.AnimationController.LoadAnimation, v_u_17.AnimationController, v16)
        if v20 then
            v21:Play(0)
        end
        p_u_15:_InternalThread(task.spawn, function()
            p_u_15:CreateSound("rbxassetid://86826830376840", 0.75, 1, nil, true, 5)
            wait(0.15)
            p_u_15:CreateSound("rbxassetid://7127702569", 1, 1.2, nil, true, 5)
            wait(1.4500000000000002)
            p_u_15:CreateSound("rbxassetid://7127702569", 1, 0.8, nil, true, 5)
        end)
        local v22 = v_u_3.RenderStepped:Connect(function()
            v_u_17:PivotTo(p_u_15._subject.RootPart.CFrame)
        end)
        local v23 = p_u_15._connections
        table.insert(v23, v22)
        wait(1.6)
        v22:Disconnect()
    end
end
function v_u_6._Init(_) end
return v_u_6