local v1 = game:GetService("Players")
local v_u_2 = require(v1.LocalPlayer.PlayerScripts.Modules.Charm)
local v_u_3 = { Color3.fromRGB(255, 0, 0), Color3.fromRGB(255, 176, 0), Color3.fromRGB(0, 255, 0) }
local v_u_4 = setmetatable({}, v_u_2)
v_u_4.__index = v_u_4
function v_u_4.new(...)
    local v5 = v_u_2.new(...)
    local v6 = v_u_4
    local v7 = setmetatable(v5, v6)
    v7._light_color_index = 0
    v7._light_part = v7.Model:WaitForChild("Extra"):WaitForChild("Light")
    v7:_Init()
    return v7
end
function v_u_4.Update(p8, p9)
    v_u_2.Update(p8, p9)
    local v10 = tick() * 1
    local v11 = math.floor(v10) % #v_u_3
    if v11 ~= p8._light_color_index then
        p8._light_color_index = v11
        p8._light_part.Color = v_u_3[p8._light_color_index + 1]
    end
end
function v_u_4._Init(_) end
return v_u_4