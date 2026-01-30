local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = require(v1.Modules.Finishers.Ragdoll)
local v_u_3 = setmetatable({}, v_u_2)
v_u_3.__index = v_u_3
function v_u_3.new(...)
    local v4 = v_u_2.new(...)
    local v5 = v_u_3
    local v6 = setmetatable(v4, v5)
    v6:_Init()
    return v6
end
function v_u_3.PlayClient(p7, ...)
    v_u_2.PlayClient(p7, ...)
    for _, v8 in pairs(p7:_GetObjects(true)) do
        if v8:IsA("BasePart") then
            if v8.Name ~= "Head" and v8.Transparency < 0.99 then
                local v9 = math.random() < 0.5
                v8.Color = v9 and Color3.fromRGB(247, 42, 55) or Color3.fromRGB(14, 150, 57)
                v8.Material = Enum.Material.SmoothPlastic
                v8.MaterialVariant = v9 and "WrappingPearlescent" or "WrappingPaper"
                for _, v10 in pairs(script.Textures:GetChildren()) do
                    v10:Clone().Parent = v8
                end
            end
        elseif v8:IsA("ParticleEmitter") or (v8:IsA("Beam") or v8:IsA("Trail")) then
            v8:Destroy()
        end
    end
    p7:CreateSound("rbxassetid://74885181688460", 1.5, 1 + 0.1 * math.random(), nil, true, 5)
end
function v_u_3._Init(_) end
return v_u_3