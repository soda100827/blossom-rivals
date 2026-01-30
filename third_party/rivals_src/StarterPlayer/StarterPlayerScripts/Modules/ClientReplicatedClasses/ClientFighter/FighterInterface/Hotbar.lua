local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.Signal)
local v_u_4 = require(v2.LocalPlayer.PlayerScripts.Modules.HotbarSlot)
local v_u_5 = require(script:WaitForChild("AmmoDisplays"))
local v_u_6 = require(script:WaitForChild("Keybinds"))
local v_u_7 = {}
v_u_7.__index = v_u_7
function v_u_7.new(p8)
    local v9 = v_u_7
    local v10 = setmetatable({}, v9)
    v10.Clicked = v_u_3.new()
    v10.FighterInterface = p8
    v10.Frame = v10.FighterInterface.Frame:WaitForChild("Hotbar")
    v10.Container = v10.Frame:WaitForChild("Container")
    v10.AmmoDisplays = v_u_5.new(v10)
    v10.Keybinds = v_u_6.new(v10)
    v10._hotbar_slots = {}
    v10:_Init()
    return v10
end
function v_u_7.EquipEffect(p11, p12, ...)
    local v13 = p11._hotbar_slots[p12]
    if v13 then
        return v13:EquipEffect(...)
    end
end
function v_u_7.RollEffect(p14, p15, ...)
    local v16 = p14._hotbar_slots[p15]
    if v16 then
        return v16:RollEffect(...)
    end
end
function v_u_7.QuickAttackFailedEffect(p17, p18, ...)
    local v19 = p17._hotbar_slots[p18]
    if v19 then
        return v19:QuickAttackFailedEffect(...)
    end
end
function v_u_7.CooldownEffect(p20, p21, ...)
    local v22 = p20._hotbar_slots[p21]
    if v22 then
        return v22:CooldownEffect(...)
    end
end
function v_u_7.UpdateVisuals(p23, ...)
    for _, v24 in pairs(p23._hotbar_slots) do
        v24:UpdateVisuals(...)
    end
end
function v_u_7.UpdateVisibility(p25, ...)
    for _, v26 in pairs(p25._hotbar_slots) do
        v26:UpdateVisibility(...)
    end
end
function v_u_7.SetVisible(p27, p28)
    p27.Frame.Visible = p28
end
function v_u_7.ItemRemoved(p29, p30, p31)
    p29.AmmoDisplays:ItemRemoved(p30, p31)
    local v32 = p29._hotbar_slots[p30]
    if v32 then
        v32:Destroy()
        p29._hotbar_slots[p30] = nil
        if not p31 then
            p29:UpdateLayouts()
        end
    end
end
function v_u_7.ItemAdded(p_u_33, p34, p35)
    p_u_33:ItemRemoved(p34, p35)
    p_u_33.AmmoDisplays:ItemAdded(p34, p35)
    local v_u_36 = v_u_4.new(p_u_33, p34)
    v_u_36.Frame.Parent = p_u_33.Container
    p_u_33._hotbar_slots[p34] = v_u_36
    v_u_36.Clicked:Connect(function(...)
        p_u_33.Clicked:Fire(v_u_36, ...)
    end)
    if not p35 then
        p_u_33:UpdateLayouts()
    end
end
function v_u_7.UpdateLayouts(p37)
    for v38, v39 in pairs(p37.FighterInterface.ClientFighter.Items) do
        local v40 = p37._hotbar_slots[v39]
        if v40 then
            v40.Frame.LayoutOrder = v38
        end
    end
    p37.AmmoDisplays:UpdateLayouts()
end
function v_u_7.Update(p41, p42, p43)
    for _, v44 in pairs(p41._hotbar_slots) do
        v44:Update(p42, p43)
    end
    p41.AmmoDisplays:Update(p42, p43)
end
function v_u_7.Destroy(p45)
    p45.AmmoDisplays:Destroy()
    p45.Keybinds:Destroy()
    for _, v46 in pairs(p45._hotbar_slots) do
        v46:Destroy()
    end
end
function v_u_7._Init(p47)
    for _, v48 in pairs(p47.FighterInterface.ClientFighter.Items) do
        p47:ItemAdded(v48, true)
    end
    p47:UpdateLayouts()
end
return v_u_7