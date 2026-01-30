local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = require(v1.Modules.Finisher)
local v_u_3 = setmetatable({}, v_u_2)
v_u_3.__index = v_u_3
function v_u_3.new(...)
    local v4 = v_u_2.new(...)
    local v5 = v_u_3
    local v6 = setmetatable(v4, v5)
    v6:_Init()
    return v6
end
function v_u_3.PlayServer(p7)
    p7:_AnchorModel(0)
end
function v_u_3.PlayClient(p8)
    local v9 = (p8._is_humanoid and p8._subject.RootPart or p8._subject).Position
    local v10 = p8._is_humanoid and p8._subject.Parent or p8._subject
    local v11 = v10.Parent
    p8:CreateSound("rbxassetid://111721022295307", 1.25, 0.95 + 0.1 * math.random(), v9, true, 10)
    for _ = 1, 6 do
        v10.Parent = v11
        wait(0.07)
        v10.Parent = nil
        wait(0.07)
    end
    p8:CreateSound("rbxassetid://122871435090543", 1.5, 0.9 + 0.2 * math.random(), v9, true, 10)
    p8:CreateSound("rbxassetid://11188024605", 1, 0.9 + 0.2 * math.random(), v9, true, 10)
    local v12 = script.Model:Clone()
    v12:PivotTo(CFrame.new(v9) * CFrame.Angles(0, math.random() * 3.141592653589793 * 2, 0))
    v12.Parent = workspace
    local v13 = p8._destroy_these
    table.insert(v13, v12)
    local v14, v15 = pcall(v12.AnimationController.LoadAnimation, v12.AnimationController, v12.Animation)
    if v14 then
        v15:Play(0)
        if v15.IsPlaying then
            v15.Stopped:Wait()
        end
    end
    v12:Destroy()
end
function v_u_3._Init(_) end
return v_u_3