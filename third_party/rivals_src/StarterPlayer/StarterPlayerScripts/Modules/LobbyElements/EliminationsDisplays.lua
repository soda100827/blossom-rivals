game:GetService("CollectionService")
local v1 = game:GetService("Players")
require(v1.LocalPlayer.PlayerScripts.Controllers.FighterController)
local v_u_2 = require(v1.LocalPlayer.PlayerScripts.Modules.EliminationsDisplay)
local v_u_3 = require(v1.LocalPlayer.PlayerScripts.Modules.LobbyElement)
local v_u_4 = setmetatable({}, v_u_3)
v_u_4.__index = v_u_4
function v_u_4._new(...)
    local v5 = v_u_3.new(...)
    local v6 = v_u_4
    local v7 = setmetatable(v5, v6)
    v7.Displays = {}
    v7:_Init()
    return v7
end
function v_u_4._DisplayAdded(p8, p9)
    local v10 = p8.Displays
    local v11 = v_u_2.new
    table.insert(v10, v11(p9))
end
function v_u_4._ClientFighterAdded(p_u_12, p13)
    p13.Elimination:Connect(function(...)
        for _, v14 in pairs(p_u_12.Displays) do
            v14:NewElimination(...)
        end
    end)
end
function v_u_4._Init(_) end
return v_u_4._new()