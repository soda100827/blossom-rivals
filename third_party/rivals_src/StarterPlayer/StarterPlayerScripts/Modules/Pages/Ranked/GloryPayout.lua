local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.SeasonLibrary)
local v_u_4 = require(v1.Modules.Utility)
local v_u_5 = require(v2.LocalPlayer.PlayerScripts.Controllers.PlayerDataController)
local v_u_6 = require(v2.LocalPlayer.PlayerScripts.Modules.RewardSlot)
local v_u_7 = {}
v_u_7.__index = v_u_7
function v_u_7.new(p8)
    local v9 = v_u_7
    local v10 = setmetatable({}, v9)
    v10.Page = p8
    v10.Frame = v10.Page.Container:WaitForChild("GloryPayout")
    v10.Container = v10.Frame:WaitForChild("Container")
    v10.Description = v10.Frame:WaitForChild("Description")
    v10.Description2 = v10.Frame:WaitForChild("Description2")
    v10._reward_slot = nil
    v10:_Init()
    return v10
end
function v_u_7.Open(p11)
    p11:_Update()
end
function v_u_7.Close(_) end
function v_u_7._Update(p12)
    if p12._reward_slot then
        p12._reward_slot:Destroy()
        p12._reward_slot = nil
    end
    local v13 = v_u_5:Get("Seasons")[v_u_3.CurrentSeason.Name]
    local v14
    if v13 then
        v14 = v13.RankedPerformances[v_u_3.UNIVERSAL_ELO_NAME]
    else
        v14 = v13
    end
    local v15
    if v14 then
        v15 = v14.CurrentELO ~= nil
    else
        v15 = v14
    end
    p12.Frame.Visible = v15
    if p12.Frame.Visible then
        local v16 = v_u_3:GetGloryPayout(v_u_3.CurrentSeason.Name, v13)
        p12.Description.Text = string.format("You\'ll receive <font transparency=\"0\" weight=\"900\">%s Glory</font> when this season ends!", v16)
        local v17 = p12.Description2
        local v18 = string.format
        local v19 = v_u_4
        local v20 = v14.DuelsWon
        local v21 = v_u_3.CurrentSeason.GloryPayoutMaxWins
        local v22 = v19:PrettyNumber((math.min(v20, v21)))
        local v23 = v_u_4:PrettyNumber(v_u_3.CurrentSeason.GloryPayoutMaxWins)
        local v24 = v_u_4
        local v25 = v14.CurrentELO
        local v26 = v_u_3.CurrentSeason.GloryPayoutMaxELO
        v17.Text = v18("Based on your total ranked wins (<font transparency=\"0\" weight=\"900\">%s</font> / %s) and your final ELO (<font transparency=\"0\" weight=\"900\">%s</font> / %s)", v22, v23, v24:PrettyNumber((math.min(v25, v26))), v_u_4:PrettyNumber(v_u_3.CurrentSeason.GloryPayoutMaxELO))
        p12._reward_slot = v_u_6.new({
            ["Name"] = "Glory",
            ["Quantity"] = v16
        })
        p12._reward_slot:SetParent(p12.Container)
    end
end
function v_u_7._Init(_) end
return v_u_7