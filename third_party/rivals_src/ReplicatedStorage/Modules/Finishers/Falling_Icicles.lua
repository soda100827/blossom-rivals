local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("TweenService")
local v_u_3 = game:GetService("RunService")
local v_u_4 = require(v1.Modules.Finishers.Ragdoll)
require(v1.Modules.BetterDebris)
require(v1.Modules.Utility)
local v_u_5 = TweenInfo.new(0.1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
local v_u_6 = setmetatable({}, v_u_4)
v_u_6.__index = v_u_6
function v_u_6.new(...)
    local v7 = v_u_4.new(...)
    local v8 = v_u_6
    local v9 = setmetatable(v7, v8)
    v9:_Init()
    return v9
end
function v_u_6.PlayClient(p10, ...)
    v_u_4.PlayClient(p10, ...)
    local v_u_11 = p10._is_humanoid and p10._subject.RootPart or p10._subject
    local v_u_12 = CFrame.Angles(0, math.random() * 3.141592653589793 * 2, 0)
    local v_u_13 = script.Model:Clone()
    v_u_13.Parent = workspace
    local v14 = p10._destroy_these
    table.insert(v14, v_u_13)
    local v15 = v_u_3.RenderStepped:Connect(function()
        v_u_13:PivotTo(CFrame.new(v_u_11.Position) * v_u_12)
    end)
    local v16 = p10._connections
    table.insert(v16, v15)
    local v17, v18 = pcall(v_u_13.AnimationController.LoadAnimation, v_u_13.AnimationController, v_u_13.Animation)
    if v17 then
        v18:Play(0)
        v18:AdjustSpeed(2)
        p10:_InternalThread(task.defer, function()
            local v19 = {}
            for v20 = 1, 16 do
                local v21 = v_u_13["Icicles" .. v20]
                table.insert(v19, v21)
            end
            local v22 = {}
            for _, v23 in pairs(v19) do
                v22[v23] = v23.Size
                v23.Size = Vector3.new(0, 0, 0)
            end
            for _, v24 in pairs(v19) do
                v_u_2:Create(v24, v_u_5, {
                    ["Size"] = v22[v24]
                }):Play()
                wait(0.05)
            end
        end)
        p10:CreateSound("rbxassetid://93583856628897", 1, 1.5 + 0.2 * math.random(), nil, true, 5)
        wait(0.55)
        for _ = 1, 6 do
            p10:CreateSound("rbxassetid://99261833097954", 0.8 + 0.2 * math.random(), 1 + 0.2 * math.random(), nil, true, 10)
            wait(0.05 + 0.1 * math.random())
        end
        if v18.IsPlaying then
            v18.Stopped:Wait()
        end
    end
    v_u_13:Destroy()
    v15:Disconnect()
end
function v_u_6._Init(_) end
return v_u_6