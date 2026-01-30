local v_u_1 = game:GetService("CollectionService")
local v2 = game:GetService("Players")
local v_u_3 = require(v2.LocalPlayer.PlayerScripts.Modules.SkinHologram)
local v_u_4 = require(v2.LocalPlayer.PlayerScripts.Modules.LobbyElement)
local v_u_5 = setmetatable({}, v_u_4)
v_u_5.__index = v_u_5
function v_u_5._new(...)
    local v6 = v_u_4.new(...)
    local v7 = v_u_5
    local v8 = setmetatable(v6, v7)
    v8.Holograms = {}
    v8:_Init()
    return v8
end
function v_u_5.Update(p9, p10)
    for _, v11 in pairs(p9.Holograms) do
        v11:Update(p10)
    end
end
function v_u_5._ObjectAdded(p12, p13)
    local v14 = v_u_3.new(p13)
    local v15 = p12.Holograms
    table.insert(v15, v14)
end
function v_u_5._Init(p_u_16)
    v_u_1:GetInstanceAddedSignal("LobbyDailyShopSkinHologram"):Connect(function(p17)
        p_u_16:_ObjectAdded(p17)
    end)
    for _, v18 in pairs(v_u_1:GetTagged("LobbyDailyShopSkinHologram")) do
        task.defer(p_u_16._ObjectAdded, p_u_16, v18)
    end
end
return v_u_5._new()