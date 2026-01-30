local v1 = game:GetService("Players")
local v_u_2 = require(v1.LocalPlayer.PlayerScripts.Modules.WrapGroupObject)
local v_u_3 = setmetatable({}, v_u_2)
v_u_3.__index = v_u_3
function v_u_3.new(...)
    local v4 = v_u_2.new(...)
    local v5 = v_u_3
    local v6 = setmetatable(v4, v5)
    v6._shake_these = {}
    v6:_Init()
    return v6
end
function v_u_3.Update(p7, _)
    for _, v8 in pairs(p7._shake_these) do
        v8.OffsetStudsU = (math.random() - 0.5) * 0.01
        v8.OffsetStudsV = (math.random() - 0.5) * 0.01
    end
end
function v_u_3._Setup(p9)
    for _, v10 in pairs(p9.ExtraObjects) do
        if v10.Name == "Wireframe" then
            local v11 = p9._shake_these
            table.insert(v11, v10)
        end
    end
end
function v_u_3._Init(p12)
    p12:_Setup()
end
return v_u_3