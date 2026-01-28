local v1 = game:GetService("Players")
local v_u_2 = require(v1.LocalPlayer.PlayerScripts.Modules.WrapGroupObject)
local v_u_3 = setmetatable({}, v_u_2)
v_u_3.__index = v_u_3
function v_u_3.new(...)
    local v4 = v_u_2.new(...)
    local v5 = v_u_3
    local v6 = setmetatable(v4, v5)
    v6._shatter1 = {}
    v6._shatter2 = {}
    v6:_Init()
    return v6
end
function v_u_3.Update(p7, _)
    local v8 = workspace:GetServerTimeNow() * 1.5
    local v9 = math.sin(v8) / 7 + 0.75
    for _, v10 in pairs(p7._shatter1) do
        v10.StudsPerTileU = v9 + 1.574 + Random.new():NextNumber(-0.02, 0.02)
        v10.StudsPerTileV = v9 + 1.574 + Random.new():NextNumber(-0.02, 0.02)
    end
    for _, v11 in pairs(p7._shatter2) do
        v11.StudsPerTileU = v9 / 1.75 + 2.5 + Random.new():NextNumber(-0.01, 0.01)
        v11.StudsPerTileV = v9 / 1.75 + 2.5 + Random.new():NextNumber(-0.01, 0.01)
    end
end
function v_u_3._Setup(p12)
    for _, v13 in pairs(p12.ExtraObjects) do
        if v13.Name == "Shatter" then
            local v14 = p12._shatter1
            table.insert(v14, v13)
        elseif v13.Name == "Shatter2" then
            local v15 = p12._shatter2
            table.insert(v15, v13)
        end
    end
end
function v_u_3._Init(p16)
    p16:_Setup()
end
return v_u_3