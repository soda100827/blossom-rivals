local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = require(v1.Modules.DuelLibrary)
local v_u_3 = { "rbxassetid://121789380697435", "rbxassetid://131598663318488" }
local v_u_4 = {}
v_u_4.__index = v_u_4
function v_u_4.new(p5)
    local v6 = v_u_4
    local v7 = setmetatable({}, v6)
    v7.ClientDueler = p5
    v7._connections = {}
    v7._honcho_highlight = nil
    v7._bodyguard_highlight = nil
    v7._hide_honcho_highlight_until = 0
    v7._aura_sound = nil
    v7:_Init()
    return v7
end
function v_u_4.Destroy(p8)
    for _, v9 in pairs(p8._connections) do
        v9:Disconnect()
    end
    if p8._honcho_highlight then
        p8._honcho_highlight:Destroy()
        p8._honcho_highlight = nil
    end
    if p8._bodyguard_highlight then
        p8._bodyguard_highlight:Destroy()
        p8._bodyguard_highlight = nil
    end
    if p8._aura_sound then
        p8._aura_sound:Destroy()
        p8._aura_sound = nil
    end
end
function v_u_4._UpdateBodyguardHighlight(p10)
    if p10._bodyguard_highlight then
        p10._bodyguard_highlight:Destroy()
        p10._bodyguard_highlight = nil
    end
    if p10.ClientDueler.ClientDuel:Get("IsSpectating") then
        if p10.ClientDueler:Get("IsHeadHoncho") == false and (p10.ClientDueler.ClientFighter and (not p10.ClientDueler.ClientFighter:Get("IsSpectating") and p10.ClientDueler.ClientFighter.Entity)) then
            if p10.ClientDueler.ClientDuel.LocalDueler and (p10.ClientDueler.ClientDuel.LocalDueler:Get("IsHeadHoncho") == true and p10.ClientDueler.ClientDuel.LocalDueler:Get("TeamID") ~= p10.ClientDueler:Get("TeamID")) then
                local v11 = p10.ClientDueler.ClientFighter.Entity.Model
                p10._bodyguard_highlight = Instance.new("Highlight")
                p10._bodyguard_highlight.FillTransparency = 1
                p10._bodyguard_highlight.OutlineColor = Color3.fromRGB(255, 50, 50)
                p10._bodyguard_highlight.OutlineTransparency = 0.5
                p10._bodyguard_highlight.Adornee = v11
                p10._bodyguard_highlight.Parent = v11
            end
        else
            return
        end
    else
        return
    end
end
function v_u_4._UpdateHonchoHighlight(p12)
    if p12._honcho_highlight then
        p12._honcho_highlight:Destroy()
        p12._honcho_highlight = nil
    end
    if p12._aura_sound then
        p12._aura_sound:Destroy()
        p12._aura_sound = nil
    end
    if p12.ClientDueler.ClientDuel:Get("IsSpectating") then
        if p12.ClientDueler:Get("IsHeadHoncho") == true and (p12.ClientDueler.ClientFighter and p12.ClientDueler.ClientFighter.Entity) then
            p12.ClientDueler.ClientFighter:Get("IsSpectating")
            if not v_u_3[v_u_2.TeamsByID[p12.ClientDueler:Get("TeamID")].TeamIndex] then
                local _ = v_u_3[1]
            end
            if not p12.ClientDueler.ClientFighter:Get("IsSpectating") then
                local v13 = v_u_2:GetTeamColor(p12.ClientDueler:Get("TeamID"))
                local v14 = p12.ClientDueler.ClientFighter.Entity.Model
                p12._honcho_highlight = Instance.new("Highlight")
                p12._honcho_highlight.DepthMode = tick() < p12._hide_honcho_highlight_until and Enum.HighlightDepthMode.Occluded or Enum.HighlightDepthMode.AlwaysOnTop
                p12._honcho_highlight.FillColor = v13
                p12._honcho_highlight.OutlineColor = v13
                p12._honcho_highlight.Adornee = v14
                p12._honcho_highlight.Parent = v14
            end
        else
            return
        end
    else
        return
    end
end
function v_u_4._SetupDamageTakenLogic(p_u_15)
    if p_u_15.ClientDueler.ClientFighter then
        local v16 = p_u_15._connections
        local v17 = p_u_15.ClientDueler.ClientFighter:GetDataChangedSignal("IsSpectating")
        table.insert(v16, v17:Connect(function(...)
            p_u_15:_UpdateHonchoHighlight()
            p_u_15:_UpdateBodyguardHighlight()
        end))
        local v_u_18 = nil
        local v19 = p_u_15._connections
        local v20 = p_u_15.ClientDueler.ClientFighter.HealthChanged
        local function v21(...)
            if v_u_18 and p_u_15.ClientDueler.ClientFighter:GetHealth() < v_u_18 then
                p_u_15._hide_honcho_highlight_until = tick() + 5
                p_u_15:_UpdateHonchoHighlight()
                task.delay(5, p_u_15._UpdateHonchoHighlight, p_u_15)
            end
            v_u_18 = p_u_15.ClientDueler.ClientFighter:GetHealth()
        end
        table.insert(v19, v20:Connect(v21))
    end
end
function v_u_4._Init(p_u_22)
    local v23 = p_u_22._connections
    local v24 = p_u_22.ClientDueler.ClientDuel:GetDataChangedSignal("IsSpectating")
    table.insert(v23, v24:Connect(function()
        p_u_22:_UpdateHonchoHighlight()
        p_u_22:_UpdateBodyguardHighlight()
    end))
    p_u_22.ClientDueler:GetDataChangedSignal("IsHeadHoncho"):Connect(function()
        p_u_22:_UpdateHonchoHighlight()
        p_u_22:_UpdateBodyguardHighlight()
    end)
    p_u_22.ClientDueler:GetDataChangedSignal("TeamID"):Connect(function()
        p_u_22:_UpdateHonchoHighlight()
        p_u_22:_UpdateBodyguardHighlight()
    end)
    p_u_22.ClientDueler.EntityAdded:Connect(function()
        p_u_22:_UpdateHonchoHighlight()
        p_u_22:_UpdateBodyguardHighlight()
    end)
    p_u_22:_SetupDamageTakenLogic()
    p_u_22:_UpdateHonchoHighlight()
    p_u_22:_UpdateBodyguardHighlight()
end
return v_u_4