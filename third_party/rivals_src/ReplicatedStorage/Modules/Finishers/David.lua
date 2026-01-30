local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("RunService")
local v_u_3 = require(v1.Modules.Finishers.Ragdoll)
require(v1.Modules.BetterDebris)
require(v1.Modules.Utility)
local v_u_4 = setmetatable({}, v_u_3)
v_u_4.__index = v_u_4
function v_u_4.new(...)
    local v5 = v_u_3.new(...)
    local v6 = v_u_4
    local v7 = setmetatable(v5, v6)
    v7:_Init()
    return v7
end
function v_u_4.PlayClient(p8, ...)
    v_u_3.PlayClient(p8, ...)
    local v_u_9 = p8._is_humanoid and p8._subject.RootPart or p8._subject
    local v_u_10 = CFrame.Angles(0, math.random() * 3.141592653589793 * 2, 0)
    local v_u_11 = script.Model:Clone()
    v_u_11.Parent = workspace
    local v12 = p8._destroy_these
    table.insert(v12, v_u_11)
    local v13 = v_u_2.RenderStepped:Connect(function()
        v_u_11:PivotTo(CFrame.new(v_u_9.Position) * v_u_10)
    end)
    local v14 = p8._connections
    table.insert(v14, v13)
    local v15, v16 = pcall(v_u_11.AnimationController.LoadAnimation, v_u_11.AnimationController, v_u_11.Animation)
    if v15 then
        v16:Play(0)
        v16:AdjustSpeed(0.5)
        wait(0.266)
        p8:CreateSound("rbxassetid://8970814590", 1, 1, nil, true, 5)
        wait(0.334)
        p8:CreateSound("rbxassetid://8970814590", 1, 1.25, nil, true, 5)
        wait(0.134)
        p8:CreateSound("rbxassetid://8970814590", 1, 1.5, nil, true, 5)
        wait(2)
        v16:AdjustSpeed(0.25)
        if v16.IsPlaying then
            v16.Stopped:Wait()
        end
    end
    v_u_11:Destroy()
    v13:Disconnect()
end
function v_u_4._Init(_) end
return v_u_4