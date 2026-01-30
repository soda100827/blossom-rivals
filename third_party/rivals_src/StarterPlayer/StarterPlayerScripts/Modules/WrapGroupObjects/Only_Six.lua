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
    v6:_Init()
    return v6
end
function v_u_3.Update(p7, _)
    local v8 = workspace:GetServerTimeNow() / 8
    local v9 = v8 * 24
    local v10 = math.sin(v9) / 2 + 0.25
    local v11 = math.clamp(v10, 0, 1)
    local v12 = (v8 + 3.5342917352885173) * 24
    local v13 = math.sin(v12) / 2 + 0.25
    local v14 = math.clamp(v13, 0, 1)
    local v15 = (math.sin(v8) + 4) / 2
    for _, v16 in pairs(p7._textures1) do
        v16.StudsPerTileU = v15
        v16.StudsPerTileV = v15
        v16.Transparency = v11
    end
    for _, v17 in pairs(p7._textures2) do
        v17.StudsPerTileU = v15
        v17.StudsPerTileV = v15
        v17.Transparency = v14
    end
end
function v_u_3._Setup(p18)
    for _, v19 in pairs(p18.ExtraObjects) do
        if v19.Name == "RedStars" or v19.Name == "BlueStars2" then
            local v20 = p18._textures1
            table.insert(v20, v19)
        elseif v19.Name == "BlueStars" or v19.Name == "RedStars2" then
            local v21 = p18._textures2
            table.insert(v21, v19)
        end
    end
end
function v_u_3._Init(p22)
    p22:_Setup()
end
return v_u_3