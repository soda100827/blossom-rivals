local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.SeasonLibrary)
local v_u_4 = require(v2.LocalPlayer.PlayerScripts.Controllers.PlayerDataController)
local v_u_5 = require(v2.LocalPlayer.PlayerScripts.Modules.BaseContractSlot)
local v_u_6 = {}
v_u_6.__index = v_u_6
function v_u_6.new(p7)
    local v8 = v_u_6
    local v9 = setmetatable({}, v8)
    v9.Page = p7
    v9._base_contract_slot = v_u_5.new()
    v9:_Init()
    return v9
end
function v_u_6.Open(p10)
    p10:_Update()
end
function v_u_6.Close(_) end
function v_u_6._Update(p11)
    local v12 = v_u_4:Get("Seasons")[v_u_3.CurrentSeason.Name]
    if v12 then
        v12 = v12.RankedPerformances[v_u_3.UNIVERSAL_ELO_NAME]
    end
    local v13
    if v12 then
        v13 = v12.CurrentELO ~= nil
    else
        v13 = v12
    end
    p11._base_contract_slot.Frame.Visible = v13
    if p11._base_contract_slot.Frame.Visible then
        local v14 = v12.DuelsWon * v_u_3.CurrentSeason.ParticipationPointsPerWin + v12.DuelsLost * v_u_3.CurrentSeason.ParticipationPointsPerLoss
        p11._base_contract_slot:SetProgress(v14)
    end
end
function v_u_6._Setup(p15)
    local v16 = v_u_3.CurrentSeason.ParticipationPointsPerWin
    local v17 = v_u_3.CurrentSeason.ParticipationPointsPerLoss
    local v18 = string.format("Earn %s point%s from every ranked win", v16, v16 == 1 and "" or "s")
    local v19 = string.format("Earn %s point%s from every ranked loss", v17, v17 == 1 and "" or "s")
    if v16 > 0 and v17 > 0 then
        v18 = v18 .. " \226\128\162 " .. v19
    elseif v16 <= 0 then
        v18 = v17 <= 0 and "???" or v19
    end
    local v20 = v18 .. "   \226\128\162   Only available during Season " .. v_u_3.CurrentSeason.Version
    p15._base_contract_slot:SetImage("rbxassetid://117835427046796")
    p15._base_contract_slot:SetTitle("Ranked Contract")
    p15._base_contract_slot:SetDescription(v20)
    p15._base_contract_slot:SetScale(0.75)
    for _, v21 in pairs(v_u_3.CurrentSeason.ParticipationPrizes) do
        local v22, v23 = table.unpack(v21)
        p15._base_contract_slot:AddMilestone(v22, v23)
    end
    p15._base_contract_slot.Frame.LayoutOrder = 30
    p15._base_contract_slot.Frame.Parent = p15.Page.Container
end
function v_u_6._Init(p24)
    p24:_Setup()
end
return v_u_6