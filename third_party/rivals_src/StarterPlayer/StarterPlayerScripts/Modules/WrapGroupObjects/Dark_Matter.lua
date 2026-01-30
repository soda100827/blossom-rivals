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
        v8.OffsetStudsU = tick() * v9.Speed * v9.Direction.X % v8.StudsPerTileU
        v8.OffsetStudsV = tick() * v9.Speed * v9.Direction.Y % v8.StudsPerTileV
    end
end
function v_u_3._Setup(p10)
    for _, v11 in pairs(p10.ExtraObjects) do
        local v12 = v11:GetAttribute("Speed")
        local v13 = v11:GetAttribute("Direction")
        if v12 and v13 then
            p10._moving_textures[v11] = {
                ["Speed"] = v12,
                ["Direction"] = v13
            }
        end
    end
end
function v_u_3._Init(p14)
    p14:_Setup()
end
return v_u_3