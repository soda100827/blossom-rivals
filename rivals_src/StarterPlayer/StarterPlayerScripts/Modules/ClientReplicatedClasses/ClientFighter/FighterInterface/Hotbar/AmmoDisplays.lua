local v1 = game:GetService("Players")
local v_u_2 = require(v1.LocalPlayer.PlayerScripts.Modules.AmmoDisplay)
local v_u_3 = {}
v_u_3.__index = v_u_3
function v_u_3.new(p4)
    local v5 = v_u_3
    local v6 = setmetatable({}, v5)
    v6.Hotbar = p4
    v6.Frame = v6.Hotbar.Container:WaitForChild("AmmoDisplays")
    v6.Layout = v6.Frame:WaitForChild("Layout")
    v6._ammo_displays = {}
    v6:_Init()
    return v6
end
function v_u_3.UpdateAmmo(p7, ...)
    for _, v8 in pairs(p7._ammo_displays) do
        v8:UpdateAmmo(...)
    end
end
function v_u_3.UpdateVisuals(p9, ...)
    for _, v10 in pairs(p9._ammo_displays) do
        v10:UpdateVisuals(...)
    end
end
function v_u_3.UpdateLayouts(p11)
    local v12 = p11.Layout.VerticalAlignment == Enum.VerticalAlignment.Top and -1 or 1
    local v13 = p11.Hotbar.FighterInterface.ClientFighter:Get("EquippedItemID")
    for v14, v15 in pairs(p11._ammo_displays) do
        v15.Frame.LayoutOrder = v14:Get("ObjectID") == v13 and v12 and v12 or 0
    end
end
function v_u_3.ItemRemoved(p16, p17, p18)
    local v19 = p16._ammo_displays[p17]
    if v19 then
        v19:Destroy()
        p16._ammo_displays[p17] = nil
        if not p18 then
            p16:UpdateLayouts()
        end
    end
end
function v_u_3.ItemAdded(p20, p21, p22)
    p20:ItemRemoved(p21, p22)
    local v23 = v_u_2.new(p20, p21)
    v23.Frame.Parent = p20.Frame
    p20._ammo_displays[p21] = v23
    if not p22 then
        p20:UpdateLayouts()
    end
end
function v_u_3.Update(p24, p25, p26)
    for _, v27 in pairs(p24._ammo_displays) do
        v27:Update(p25, p26)
    end
end
function v_u_3.Destroy(_) end
function v_u_3._Init(p_u_28)
    p_u_28.Layout:GetPropertyChangedSignal("VerticalAlignment"):Connect(function()
        p_u_28:UpdateLayouts()
    end)
end
return v_u_3