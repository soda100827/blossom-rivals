local v_u_1 = game:GetService("CollectionService")
local v_u_2 = game:GetService("Players")
local v_u_3 = require(v_u_2.LocalPlayer.PlayerScripts.Controllers.DuelController)
local v_u_4 = require(v_u_2.LocalPlayer.PlayerScripts.Modules.DuelsDisplay)
local v_u_5 = require(v_u_2.LocalPlayer.PlayerScripts.Modules.LobbyElement)
local v_u_6 = setmetatable({}, v_u_5)
v_u_6.__index = v_u_6
function v_u_6._new(...)
    local v7 = v_u_5.new(...)
    local v8 = v_u_6
    local v9 = setmetatable(v7, v8)
    v9.Displays = {}
    v9:_Init()
    return v9
end
function v_u_6._UpdateEnabled(p10)
    local v11 = not v_u_3:GetDuel(v_u_2.LocalPlayer)
    for _, v12 in pairs(p10.Displays) do
        v12:SetEnabled(v11)
    end
end
function v_u_6._DisplayAdded(p13, p14, p15)
    local v16 = p13.Displays
    local v17 = v_u_4.new
    table.insert(v16, v17(p14))
    if not p15 then
        p13:_UpdateEnabled()
    end
end
function v_u_6._Init(p_u_18)
    v_u_3.LocalPlayerJoinedOrLeftDuel:Connect(function()
        p_u_18:_UpdateEnabled()
    end)
    v_u_1:GetInstanceAddedSignal("DuelsDisplay"):Connect(function(p19)
        p_u_18:_DisplayAdded(p19)
    end)
    for _, v20 in pairs(v_u_1:GetTagged("DuelsDisplay")) do
        p_u_18:_DisplayAdded(v20, true)
    end
    p_u_18:_UpdateEnabled()
end
return v_u_6._new()