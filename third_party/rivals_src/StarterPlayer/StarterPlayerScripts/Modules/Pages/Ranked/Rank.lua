local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.SeasonLibrary)
local v_u_4 = require(v2.LocalPlayer.PlayerScripts.Controllers.PlayerDataController)
local v_u_5 = require(v2.LocalPlayer.PlayerScripts.Modules.ELOBar)
local v_u_6 = {}
v_u_6.__index = v_u_6
function v_u_6.new(p7)
    local v8 = v_u_6
    local v9 = setmetatable({}, v8)
    v9.Page = p7
    v9.Frame = v9.Page.Container:WaitForChild("Rank")
    v9.ELOBar = v_u_5.new()
    v9:_Init()
    return v9
end
function v_u_6.Open(p10)
    p10.ELOBar:Update(true)
    p10:_UpdateLayoutOrder()
end
function v_u_6.Close(p11)
    p11.ELOBar:Update(false)
    p11:_UpdateLayoutOrder()
end
function v_u_6._UpdateLayoutOrder(p12)
    local v13 = v_u_4:Get("Seasons")[v_u_3.CurrentSeason.Name]
    if v13 then
        v13 = v13.RankedPerformances[v_u_3.UNIVERSAL_ELO_NAME]
    end
    if v13 then
        v13 = v13.CurrentELO ~= nil
    end
    p12.Frame.LayoutOrder = v13 and 0 or 20
end
function v_u_6._Setup(p14)
    p14.ELOBar:SetParent(p14.Frame)
end
function v_u_6._Init(p15)
    p15:_Setup()
    p15:_UpdateLayoutOrder()
end
return v_u_6