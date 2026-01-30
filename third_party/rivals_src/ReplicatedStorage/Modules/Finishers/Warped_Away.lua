local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = require(v1.Modules.BetterDebris)
local v_u_3 = require(v1.Modules.Finisher)
local v_u_4 = setmetatable({}, v_u_3)
v_u_4.__index = v_u_4
function v_u_4.new(...)
    local v5 = v_u_3.new(...)
    local v6 = v_u_4
    local v7 = setmetatable(v5, v6)
    v7:_Init()
    return v7
end
function v_u_4.PlayServer(p8)
    if p8._is_humanoid then
        local v9 = Instance.new("Animation")
        v9.AnimationId = "rbxassetid://78200878063567"
        local v10, v11 = pcall(p8._subject.LoadAnimation, p8._subject, v9)
        if v10 then
            v11:Play(0)
        end
        wait(2.2)
        p8:_HideBody()
    end
end
function v_u_4.PlayClient(p12)
    if p12._is_humanoid then
        local v13 = Instance.new("Animation")
        v13.AnimationId = "rbxassetid://78200878063567"
        local v14 = script.Model:Clone()
        v14.PrimaryPart = v14.HumanoidRootPart
        v14:PivotTo(p12._subject.RootPart.CFrame)
        v14.Parent = workspace
        local v15 = p12._destroy_these
        table.insert(v15, v14)
        v_u_2:AddItem(v14, 2.2)
        for _, v16 in pairs(v14:GetDescendants()) do
            if v16:IsA("BasePart") then
                v16.CollisionGroup = "Noclip"
            end
        end
        local v17, v18 = pcall(v14.AnimationController.LoadAnimation, v14.AnimationController, v13)
        if v17 then
            v18:Play(0)
        end
        wait(0.9)
        p12:CreateSound("rbxassetid://7127702569", 1, 1.2, nil, true, 5)
        wait(1.3)
        p12:CreateSound("rbxassetid://7127702569", 1, 0.8, nil, true, 5)
    end
end
function v_u_4._Init(_) end
return v_u_4