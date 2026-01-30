local v1 = game:GetService("Players")
local v_u_2 = require(v1.LocalPlayer.PlayerScripts.Modules.WrapGroupObject)
local v_u_3 = setmetatable({}, v_u_2)
v_u_3.__index = v_u_3
function v_u_3.new(...)
    local v4 = v_u_2.new(...)
    local v5 = v_u_3
    local v6 = setmetatable(v4, v5)
    v6._fire1 = {}
    v6._fire2 = {}
    v6._beams = {}
    v6._sparks = {}
    v6:_Init()
    return v6
end
function v_u_3.Update(p7, _)
    local v8 = workspace:GetServerTimeNow() / 4
    local v9 = v8 * 12
    local v10 = math.sin(v9) / 3 + 0.5
    local v11 = math.clamp(v10, 0, 1)
    local v12 = (v8 + 3.5342917352885173) * 12
    local v13 = math.sin(v12) / 3 + 0.5
    local v14 = math.clamp(v13, 0, 1)
    for _, v15 in pairs(p7._fire1) do
        v15.Transparency = v11
    end
    for _, v16 in pairs(p7._fire2) do
        v16.Transparency = v14
    end
    for _, v17 in pairs(p7._beams) do
        local v18 = v8 * 6
        v17.Transparency = math.sin(v18) / 10 + 0.8
    end
    for _, v19 in pairs(p7._sparks) do
        local v20 = v8 / 4 % v19.StudsPerTileU
        local v21 = v8 * 9
        v19.OffsetStudsU = v20 + math.sin(v21) / 64
        v19.OffsetStudsV = v8 / 2 % v19.StudsPerTileV
        local v22 = v8 * 8
        v19.Transparency = math.sin(v22) / 10 + 0.2
    end
end
function v_u_3._Setup(p23)
    for _, v24 in pairs(p23.ExtraObjects) do
        if v24.Name == "Fire1" then
            local v25 = p23._fire1
            table.insert(v25, v24)
        elseif v24.Name == "Fire2" then
            local v26 = p23._fire1
            table.insert(v26, v24)
        elseif v24.Name == "Beam" then
            local v27 = p23._beams
            table.insert(v27, v24)
        elseif v24.Name == "Sparks1" then
            local v28 = p23._sparks
            table.insert(v28, v24)
        end
    end
end
function v_u_3._Init(p29)
    p29:_Setup()
end
return v_u_3