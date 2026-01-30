local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = require(v1.Modules.Finishers.Ragdoll)
local v_u_3 = require(v1.Modules.Utility)
local v_u_4 = {
    Color3.fromRGB(255, 50, 50),
    Color3.fromRGB(255, 127, 0),
    Color3.fromRGB(255, 215, 0),
    Color3.fromRGB(100, 255, 50),
    Color3.fromRGB(0, 190, 255),
    Color3.fromRGB(122, 56, 255)
}
local v_u_5 = { "rbxassetid://14796313307", "rbxassetid://14796313578" }
local v_u_6 = { "rbxassetid://14796313153", "rbxassetid://14796313025" }
local v_u_7 = setmetatable({}, v_u_2)
v_u_7.__index = v_u_7
function v_u_7.new(...)
    local v8 = v_u_2.new(...)
    local v9 = v_u_7
    local v10 = setmetatable(v8, v9)
    v10:_Init()
    return v10
end
function v_u_7.PlayClient(p11, ...)
    v_u_2.PlayClient(p11, ...)
    local v12 = v_u_4[math.random(#v_u_4)]:ToHSV()
    for _, v13 in pairs(p11:_GetObjects(true)) do
        if v13:IsA("BasePart") then
            v13.Color = Color3.fromHSV((v12 + 0.1 * (math.random() - 0.5)) % 1, 1, 1)
            local v14 = {}
            for _, v15 in pairs(script.Particles:GetChildren()) do
                local v16 = v15:Clone()
                v16.Color = ColorSequence.new(v13.Color)
                v16.Parent = v13
                local v17 = p11._destroy_these
                table.insert(v17, v16)
                table.insert(v14, v16)
            end
            v_u_3:PlayParticles(v14)
            p11:CreateSound(v_u_5[math.random(#v_u_5)], 1, 1 + 0.2 * math.random(), nil, true, 5)
            p11:CreateSound(v_u_6[math.random(#v_u_6)], 1, 1 + 0.2 * math.random(), nil, true, 5)
            wait(0.025 + 0.05 * math.random())
        end
    end
end
function v_u_7._Init(_) end
return v_u_7