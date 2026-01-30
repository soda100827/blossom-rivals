local v1 = game:GetService("Players")
local v_u_2 = require(v1.LocalPlayer.PlayerScripts.Modules.WrapGroupObject)
local v_u_3 = setmetatable({}, v_u_2)
v_u_3.__index = v_u_3
function v_u_3.new(...)
    local v4 = v_u_2.new(...)
    local v5 = v_u_3
    local v6 = setmetatable(v4, v5)
    v6._sparkles1 = {}
    v6._sparkles2 = {}
    v6:_Init()
    return v6
end
function v_u_3.Update(p7, _)
    local v8 = workspace:GetServerTimeNow() / 4
    local v9 = v8 * 24
    local v10 = math.sin(v9) / 3 + 0.5
    local v11 = math.clamp(v10, 0, 1)
    local v12 = (v8 + 3.5342917352885173) * 24
    local v13 = math.sin(v12) / 3 + 0.5
    local v14 = math.clamp(v13, 0, 1)
    for _, v15 in pairs(p7._sparkles1) do
        v15.OffsetStudsV = v8 % v15.StudsPerTileV
        v15.Transparency = v11
    end
    for _, v16 in pairs(p7._sparkles2) do
        v16.OffsetStudsV = v8 % v16.StudsPerTileV
        v16.Transparency = v14
    end
end
function v_u_3._Setup(p17)
    for _, v18 in pairs(p17.ExtraObjects) do
        if v18.Name == "Sparkles" then
            local v19 = p17._sparkles1
            table.insert(v19, v18)
        elseif v18.Name == "Sparkles2" then
            local v20 = p17._sparkles2
            table.insert(v20, v18)
        end
    end
end
function v_u_3._Init(p21)
    p21:_Setup()
end
return v_u_3