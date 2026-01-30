local v_u_1 = game:GetService("CollectionService")
local v2 = game:GetService("Players")
local v_u_3 = require(v2.LocalPlayer.PlayerScripts.Controllers.LeaderboardController)
local v_u_4 = require(v2.LocalPlayer.PlayerScripts.Modules.LeaderboardDisplay)
local v_u_5 = require(v2.LocalPlayer.PlayerScripts.Modules.LobbyElement)
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
function v_u_6._DisplayAdded(p10, p11)
    local v12 = v_u_4.new(p11)
    v12:SetSerial(v_u_3.LeaderboardSerials)
    local v13 = p10.Displays
    table.insert(v13, v12)
end
function v_u_6._Init(p_u_14)
    v_u_3.Refreshed:Connect(function()
        for _, v15 in pairs(p_u_14.Displays) do
            v15:SetSerial(v_u_3.LeaderboardSerials)
        end
    end)
    v_u_1:GetInstanceAddedSignal("LeaderboardDisplay"):Connect(function(p16)
        p_u_14:_DisplayAdded(p16)
    end)
    for _, v17 in pairs(v_u_1:GetTagged("LeaderboardDisplay")) do
        p_u_14:_DisplayAdded(v17)
    end
end
return v_u_6._new()