local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("RunService")
local v_u_3 = require(v1.Modules.Finisher)
local v_u_4 = require(v1.Modules.Utility)
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
    p9:_AnchorModel(0)
    wait(2)
    p9:_HideBody()
end
function v_u_5.PlayClient(p_u_10)
    local v_u_11 = {}
    for _, v12 in pairs(p_u_10:_GetObjects(true)) do
        if v12:IsA("BasePart") then
            v12.Color = Color3.fromRGB(248, 151, 255)
            v12.Material = Enum.Material.Glass
            if v12:IsA("MeshPart") then
                v12.TextureID = ""
            end
            table.insert(v_u_11, v12)
        end
    end
    local v_u_13
    if p_u_10._is_humanoid then
        v_u_13 = p_u_10._subject.Parent or nil
    else
        v_u_13 = nil
    end
    local v_u_14
    if v_u_13 then
        v_u_14 = v_u_13:GetScale()
    else
        v_u_14 = v_u_13
    end
    local v_u_15 = tick()
    local v22 = v_u_2.RenderStepped:Connect(function()
        local v16 = ((tick() - v_u_15) / 2) ^ 1.5
        local v17 = 15.707963267948966 * v16
        local v18 = ((1 - math.cos(v17)) / 4 + 4 * v16) / 4.5
        local v19 = 0.5 + 2.5 * v18
        if v_u_13 then
            v_u_13:ScaleTo(v_u_14 * v19)
        end
        local v20 = v18 < 0.15 and 0 or (v18 ^ 4 - 0.15) / 0.75 * 0.5
        for _, v21 in pairs(v_u_11) do
            v21.LocalTransparencyModifier = v20
        end
    end)
    local v23 = p_u_10._connections
    table.insert(v23, v22)
    p_u_10:_InternalThread(task.defer, function()
        p_u_10:CreateSound("rbxassetid://135921915396785", 1, 1, nil, true, 5)
        wait(0.78)
        p_u_10:CreateSound("rbxassetid://135921915396785", 1, 1, nil, true, 5)
        wait(0.8)
        p_u_10:CreateSound("rbxassetid://135921915396785", 1, 1, nil, true, 5)
    end)
    wait(2)
    v22:Disconnect()
    local v24 = script.Particles:Clone()
    v24.Parent = workspace
    v24.CFrame = (p_u_10._is_humanoid and p_u_10._subject.RootPart or p_u_10._subject).CFrame
    local v25 = p_u_10._destroy_these
    table.insert(v25, v24)
    v_u_4:PlayParticles(v24)
    p_u_10:CreateSound("rbxassetid://94915446476512", 1, 1, v24, true, 5)
end
function v_u_5._Init(_) end
return v_u_5