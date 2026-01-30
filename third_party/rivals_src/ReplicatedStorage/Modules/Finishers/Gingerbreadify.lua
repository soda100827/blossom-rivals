local v1 = game:GetService("ReplicatedStorage")
require(v1.Modules.CosmeticLibrary)
local v_u_2 = require(v1.Modules.Finishers.Ragdoll)
require(v1.Modules.Utility)
local v_u_3 = {
    { "RightUpperArm", "RightLowerArm", "RightHand" },
    { "LeftUpperArm", "LeftLowerArm", "LeftHand" },
    { "RightUpperLeg", "RightLowerLeg", "RightFoot" },
    { "LeftUpperLeg", "LeftLowerLeg", "LeftFoot" },
    { "UpperTorso", "LowerTorso", "Head" }
}
local v_u_4 = setmetatable({}, v_u_2)
v_u_4.__index = v_u_4
function v_u_4.new(...)
    local v5 = v_u_2.new(...)
    local v6 = v_u_4
    local v7 = setmetatable(v5, v6)
    v7:_Init()
    return v7
end
function v_u_4.PlayServer(p8, ...)
    v_u_2.PlayServer(p8, ...)
    wait(#v_u_3 * 0.2 + 1)
    p8:_HideBody()
end
function v_u_4.PlayClient(p9, ...)
    v_u_2.PlayClient(p9, ...)
    for _, v10 in pairs(p9:_GetObjects(true)) do
        if v10:IsA("BasePart") then
            if v10.Transparency < 0.99 then
                v10.Color = Color3.fromRGB(106, 73, 50)
                v10.Material = Enum.Material.Slate
                if v10.Name == "Head" then
                    script.Head:Clone().Parent = v10
                elseif v10.Name == "UpperTorso" then
                    script.UpperTorso:Clone().Parent = v10
                elseif v10.Name ~= "LowerTorso" then
                    for _, v11 in pairs(script.Textures:GetChildren()) do
                        v11:Clone().Parent = v10
                    end
                end
            end
        elseif v10:IsA("ParticleEmitter") or (v10:IsA("Beam") or (v10:IsA("Trail") or (v10:IsA("Decal") or (v10:IsA("Clothing") or v10:IsA("Texture"))))) then
            v10:Destroy()
        end
    end
    if p9._is_humanoid then
        local v12 = {}
        for v13 in pairs(v_u_3) do
            table.insert(v12, v13)
        end
        wait(1)
        for _ = 1, #v12 do
            local v14 = table.remove(v12, math.random(#v12))
            for _, v15 in pairs(v_u_3[v14]) do
                p9._subject.Parent[v15]:Destroy()
            end
            p9:CreateSound("rbxassetid://18128896162", 1, 1 + 0.1 * math.random(), nil, true, 5)
            wait(0.2)
        end
        p9:CreateSound("rbxassetid://18128949754", 1, 1 + 0.1 * math.random(), nil, true, 10)
    end
end
function v_u_4._Init(_) end
return v_u_4