local v1 = game:GetService("Players")
local v_u_2 = require(v1.LocalPlayer.PlayerScripts.Modules.WrapGroupObject)
local v_u_3 = setmetatable({}, v_u_2)
v_u_3.__index = v_u_3
function v_u_3.new(...)
    local v4 = v_u_2.new(...)
    local v5 = v_u_3
    local v6 = setmetatable(v4, v5)
    v6._clouds1 = {}
    v6._clouds2 = {}
    v6._snow1 = {}
    v6._snow2 = {}
    v6:_Init()
    return v6
end
function v_u_3.Update(p7, _)
    local v8 = workspace:GetServerTimeNow()
    for _, v9 in pairs(p7._clouds1) do
        v9.OffsetStudsU = v9.StudsPerTileU - v8 / 2 % v9.StudsPerTileU
        v9.OffsetStudsV = v9.StudsPerTileV - v8 % v9.StudsPerTileV
    end
    for _, v10 in pairs(p7._clouds2) do
        v10.OffsetStudsU = v8 / 2 % v10.StudsPerTileU
        v10.OffsetStudsV = v10.StudsPerTileV - v8 % v10.StudsPerTileV
    end
    for _, v11 in pairs(p7._snow1) do
        v11.OffsetStudsU = v11.StudsPerTileU - v8 % v11.StudsPerTileU
        v11.OffsetStudsV = v11.StudsPerTileV - v8 / 2 % v11.StudsPerTileV
    end
    for _, v12 in pairs(p7._snow2) do
        v12.OffsetStudsU = v8 % v12.StudsPerTileU
        v12.OffsetStudsV = v12.StudsPerTileV - v8 / 2 % v12.StudsPerTileV
    end
end
function v_u_3._Setup(p13)
    for _, v14 in pairs(p13.ExtraObjects) do
        if v14.Name == "Clouds1" then
            local v15 = p13._clouds1
            table.insert(v15, v14)
        elseif v14.Name == "Clouds2" then
            local v16 = p13._clouds2
            table.insert(v16, v14)
        elseif v14.Name == "Snow1" then
            local v17 = p13._snow1
            table.insert(v17, v14)
        elseif v14.Name == "Snow2" then
            local v18 = p13._snow2
            table.insert(v18, v14)
        end
    end
end
function v_u_3._Init(p19)
    p19:_Setup()
end
return v_u_3