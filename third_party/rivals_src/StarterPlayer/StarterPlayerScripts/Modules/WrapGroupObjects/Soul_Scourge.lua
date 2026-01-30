local v1 = game:GetService("Players")
local v_u_2 = require(v1.LocalPlayer.PlayerScripts.Modules.WrapGroupObject)
local v_u_3 = setmetatable({}, v_u_2)
v_u_3.__index = v_u_3
function v_u_3.new(...)
    local v4 = v_u_2.new(...)
    local v5 = v_u_3
    local v6 = setmetatable(v4, v5)
    v6._textures1 = {}
    v6._textures2 = {}
    v6._random = Random.new()
    v6:_Init()
    return v6
end
function v_u_3.Update(p7, _)
    local v8 = workspace:GetServerTimeNow() / 4
    for _, v9 in pairs(p7._textures1) do
        v9.OffsetStudsV = v8 % 0.6
        local v10 = v8 * 10
        v9.OffsetStudsU = math.sin(v10) / 14 + p7._random:NextNumber(-0.01, 0.01)
    end
    for _, v11 in pairs(p7._textures2) do
        v11.OffsetStudsU = v8 % 0.7
        v11.OffsetStudsV = v8 % 0.5
    end
end
function v_u_3._Setup(p12)
    for _, v13 in pairs(p12.ExtraObjects) do
        if v13.Name == "Souls" then
            local v14 = p12._textures1
            table.insert(v14, v13)
        elseif v13.Name == "Clouds2" then
            local v15 = p12._textures2
            table.insert(v15, v13)
        end
    end
end
function v_u_3._Init(p16)
    p16:_Setup()
end
return v_u_3