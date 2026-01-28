local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("RunService")
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
    p8:_AnchorModel(0)
    wait(1)
    p8:_AnchorModel(0, false)
    p8:_Ragdoll()
    p8:_AnchorModel()
end
function v_u_4.PlayClient(p9, ...)
    local v_u_10 = {}
    for _, v11 in pairs(p9:_GetObjects(true)) do
        if v11:IsA("BasePart") and v11.Transparency < 0.99 then
            v_u_10[v11] = v11.CFrame
            if v11.Name == "Head" then
                v11.Transparency = 1
            else
                v11:SetAttribute("WrapGroup", 1)
                v11:SetAttribute("IgnoreObject", true)
                v11:AddTag("Wrappable")
            end
        elseif v11:IsA("Texture") or v11:IsA("Decal") then
            v11:Destroy()
        end
    end
    local v12 = p9._is_humanoid and p9._subject.Parent or p9._subject
    v12:SetAttribute("WrapName", "Encroached")
    v12:AddTag("WrapThis")
    local v_u_13 = tick()
    local v20 = v_u_2.RenderStepped:Connect(function(_)
        local v14 = 5 * (1 - (tick() - v_u_13) / 1) ^ 4
        for v15, v16 in pairs(v_u_10) do
            local v17 = math.random() - 0.5
            local v18 = math.random() - 0.5
            local v19 = math.random() - 0.5
            v15.CFrame = v16 + Vector3.new(v17, v18, v19) * v14
        end
    end)
    local v21 = p9._connections
    table.insert(v21, v20)
    p9:CreateSound("rbxassetid://118282338053058", 1.75, 1 + 0.1 * math.random(), nil, true, 5)
    wait(1)
    v20:Disconnect()
    for v22, v23 in pairs(v_u_10) do
        v22.CFrame = v23
    end
    p9:_AnchorModel(0, false)
end
function v_u_4._Init(_) end
return v_u_4