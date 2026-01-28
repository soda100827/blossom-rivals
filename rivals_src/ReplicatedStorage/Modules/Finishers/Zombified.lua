local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("TweenService")
local v_u_3 = require(v1.Modules.Finishers.Ragdoll)
local v_u_4 = require(v1.Modules.Utility)
local v_u_5 = TweenInfo.new(2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)
local v_u_6 = {
    ["Color"] = Color3.fromRGB(45, 117, 0)
}
local v_u_7 = { "rbxassetid://76551122205423", "rbxassetid://121329175458153", "rbxassetid://86178802108357" }
local v_u_8 = setmetatable({}, v_u_3)
v_u_8.__index = v_u_8
function v_u_8.new(...)
    local v9 = v_u_3.new(...)
    local v10 = v_u_8
    local v11 = setmetatable(v9, v10)
    v11:_Init()
    return v11
end
function v_u_8.PlayServer(p12, ...)
    local v13 = p12._is_humanoid and p12._subject.RootPart or p12._subject
    v13.Anchored = true
    wait(9.9)
    v13.Anchored = false
    v_u_3.PlayServer(p12, ...)
end
function v_u_8.PlayClient(p14)
    for _, v15 in pairs(p14:_GetObjects()) do
        if v15:IsA("BasePart") then
            v_u_2:Create(v15, v_u_5, v_u_6):Play()
        end
    end
    if p14._is_humanoid then
        local v16 = Instance.new("Animation")
        v16.AnimationId = "rbxassetid://84937348544434"
        local v17, v18 = pcall(p14._subject.LoadAnimation, p14._subject, v16)
        if v17 then
            v18:Play(0)
        end
    end
    p14:CreateSound("rbxassetid://113907213192044", 1.5, 1, nil, true, 15)
    p14:CreateSound("rbxassetid://103180063975943", 0.25, 0.5 + 0.1 * math.random(), nil, true, 15)
    p14:CreateSound("rbxassetid://84523504613156", 1, 1, nil, true, 15)
    wait(0.8)
    p14:CreateSound("rbxassetid://99312045046993", 1, 1, nil, true, 15)
    wait(0.8)
    p14:CreateSound("rbxassetid://109142509049932", 1, 1, nil, true, 15)
    wait(2.4)
    local v19 = v_u_4:CloneTable(v_u_7)
    for _ = 1, #v_u_7 do
        p14:CreateSound(table.remove(v19, math.random(#v19)), 0.5, 0.5 + 0.1 * math.random(), nil, true, 5)
        wait(5.7 / #v_u_7)
    end
    p14:CreateSound("rbxassetid://126800102156089", 0.5, 0.75, nil, true, 5)
end
function v_u_8._Init(_) end
return v_u_8