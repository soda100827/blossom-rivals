local v1 = game:GetService("Players")
local v_u_2 = require(v1.LocalPlayer.PlayerScripts.Modules.WrapGroupObject)
local v_u_3 = setmetatable({}, v_u_2)
v_u_3.__index = v_u_3
function v_u_3.new(...)
    local v4 = v_u_2.new(...)
    local v5 = v_u_3
    local v6 = setmetatable(v4, v5)
    v6._moving_textures = {}
    v6._shift = 0
    v6:_Init()
    return v6
end
function v_u_3.Update(p7, p8)
    local v9 = tick() * 1
    local v10 = math.sin(v9) ^ 20 * 0.75 + 0.25
    p7._shift = (p7._shift + p8 * v10) % 0.2
    for v11, v12 in pairs(p7._moving_textures) do
        v11.OffsetStudsU = p7._shift * v12
    end
end
function v_u_3._Setup(p13)
    for _, v14 in pairs(p13.ExtraObjects) do
        p13._moving_textures[v14] = v14.Name == "Left" and 1 or -1
    end
end
function v_u_3._Init(p15)
    p15:_Setup()
end
return v_u_3