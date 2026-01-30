local v1 = game:GetService("Players")
local v_u_2 = require(v1.LocalPlayer.PlayerScripts.Modules.WrapGroupObject)
local v_u_3 = setmetatable({}, v_u_2)
v_u_3.__index = v_u_3
function v_u_3.new(...)
    local v4 = v_u_2.new(...)
    local v5 = v_u_3
    local v6 = setmetatable(v4, v5)
    v6._moving_textures = {}
    v6:_Init()
    return v6
end
function v_u_3.Update(p7, _)
    for v8, v9 in pairs(p7._moving_textures) do
        local v10 = (tick() * 0.01 + v9) % 1
        local v11 = 3.141592653589793 * v10 - 1.5707963267948966
        local v12 = math.sin(v11) ^ 20 * 0.75 + 0.25
        local v13 = 0.05 + 1.075 * v10 ^ 2
        v8.Transparency = v12
        v8.StudsPerTileU = v13
        v8.StudsPerTileV = v13
    end
end
function v_u_3._Setup(p14)
    for _, v15 in pairs(p14.ExtraObjects) do
        p14._moving_textures[v15] = v15.Name == "Big" and 0.5 or 0
    end
end
function v_u_3._Init(p16)
    p16:_Setup()
end
return v_u_3