local v1 = game:GetService("Players")
local v_u_2 = require(v1.LocalPlayer.PlayerScripts.Modules.WrapGroupObject)
local v_u_3 = setmetatable({}, v_u_2)
v_u_3.__index = v_u_3
function v_u_3.new(...)
    local v4 = v_u_2.new(...)
    local v5 = v_u_3
    local v6 = setmetatable(v4, v5)
    v6._last_remainder = nil
    v6._textures = {
        {},
        {},
        {}
    }
    v6:_Init()
    return v6
end
function v_u_3.Update(p7, _)
    local v8 = tick() * 1
    local v9 = math.floor(v8) % #p7._textures + 1
    if v9 ~= p7._last_remainder then
        p7._last_remainder = v9
        for v10, v11 in pairs(p7._textures) do
            local v12 = v10 == p7._last_remainder and 0 or 1
            for _, v13 in pairs(v11) do
                v13.Transparency = v12
            end
        end
    end
end
function v_u_3._Setup(p14)
    for _, v15 in pairs(p14.ExtraObjects) do
        if v15.Name == "SolidRed" or v15.Name == "RedLightsInner" then
            local v16 = p14._textures[1]
            table.insert(v16, v15)
        elseif v15.Name == "SolidYellow" or v15.Name == "YellowLightsInner" then
            local v17 = p14._textures[2]
            table.insert(v17, v15)
        elseif v15.Name == "SolidGreen" or v15.Name == "GreenLightsInner" then
            local v18 = p14._textures[3]
            table.insert(v18, v15)
        end
    end
end
function v_u_3._Init(p19)
    p19:_Setup()
end
return v_u_3