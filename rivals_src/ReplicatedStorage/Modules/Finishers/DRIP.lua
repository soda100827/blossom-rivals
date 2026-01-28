local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("RunService")
local v_u_3 = game:GetService("Players")
local v_u_4 = require(v1.Modules.Finishers.Ragdoll)
require(v1.Modules.BetterDebris)
require(v1.Modules.Utility)
local v_u_5 = setmetatable({}, v_u_4)
v_u_5.__index = v_u_5
function v_u_5.new(...)
    local v6 = v_u_4.new(...)
    local v7 = v_u_5
    local v8 = setmetatable(v6, v7)
    v8:_Init()
    return v8
end
function v_u_5.PlayClient(p9)
    local v_u_10 = p9._is_humanoid and p9._subject.RootPart or p9._subject
    local v_u_11 = CFrame.Angles(0, math.random() * 3.141592653589793 * 2, 0)
    local v12 = p9._is_humanoid
    if v12 then
        v12 = v_u_3:GetPlayerFromCharacter(p9._subject.Parent)
    end
    local v13 = v12 and v12.DisplayName or ""
    local v_u_14 = script.Model:Clone()
    v_u_14.Tomb.Part.Front.Player.Text = v13
    v_u_14.Tomb.Part.Back.Player.Text = v13
    v_u_14.Parent = workspace
    local v15 = p9._destroy_these
    table.insert(v15, v_u_14)
    local v16 = v_u_2.RenderStepped:Connect(function()
        v_u_14:PivotTo(CFrame.new(v_u_10.Position) * v_u_11 + Vector3.new(0, 2.25, 0))
    end)
    local v17 = p9._connections
    table.insert(v17, v16)
    local v18, v19 = pcall(v_u_14.AnimationController.LoadAnimation, v_u_14.AnimationController, v_u_14.Animation)
    if v18 then
        v19:Play(0)
        p9:CreateSound("rbxassetid://85156927480464", 1.5, 0.75, nil, true, 5)
        wait(0.7)
        for _, v20 in pairs((p9._is_humanoid and p9._subject.Parent or p9._subject):GetDescendants()) do
            if v20:IsA("BasePart") then
                v20.Transparency = 1
            elseif v20:IsA("ParticleEmitter") or (v20:IsA("Beam") or (v20:IsA("Trail") or v20:IsA("Decal"))) then
                v20:Destroy()
            end
        end
        p9:CreateSound("rbxassetid://112796414625817", 2, 0.75, nil, true, 5)
        p9:CreateSound("rbxassetid://75913059184380", 2, 1 + 0.1 * math.random(), nil, true, 10)
        wait(9)
        p9:CreateSound("rbxassetid://125843357117650", 2, 0.75, nil, true, 5)
        if v19.IsPlaying then
            v19.Stopped:Wait()
        end
        v_u_14:Destroy()
        wait(3)
    end
    v16:Disconnect()
end
function v_u_5._Init(_) end
return v_u_5