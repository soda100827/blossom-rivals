local v1 = game:GetService("Players")
local v_u_2 = require(v1.LocalPlayer.PlayerScripts.Modules.WrapGroupObject)
local v_u_3 = setmetatable({}, v_u_2)
v_u_3.__index = v_u_3
function v_u_3.new(...)
    local v4 = v_u_2.new(...)
    local v5 = v_u_3
    local v6 = setmetatable(v4, v5)
    v6._gradient1 = {}
    v6._gradient2 = {}
    v6:_Init()
    return v6
end
function v_u_3.Update(p7, _)
    local v8 = workspace:GetServerTimeNow() / 4
    for _, v9 in pairs(p7._gradient1) do
        local v10 = v8 / 2.5 % v9.StudsPerTileU
        if v9.Face == Enum.NormalId.Top or v9.Face == Enum.NormalId.Front then
            v10 = -v10
        end
        v9.OffsetStudsU = v10
        local v11 = v8 * 4
        v9.OffsetStudsV = math.sin(v11) / 14
    end
end
function v_u_3._Setup(p12)
    for _, v13 in pairs(p12.ExtraObjects) do
        if v13.Name == "Gradient" then
            local v14 = p12._gradient1
            table.insert(v14, v13)
        elseif v13.Name == "Gradient2" then
            local v15 = p12._gradient2
            table.insert(v15, v13)
        end
    end
end
function v_u_3._Init(p16)
    p16:_Setup()
end
return v_u_3