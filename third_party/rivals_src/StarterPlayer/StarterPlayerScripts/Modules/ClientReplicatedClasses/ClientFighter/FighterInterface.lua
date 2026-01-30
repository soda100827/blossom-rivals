local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.Utility)
local v_u_4 = require(v1.Modules.Signal)
local v_u_5 = require(v2.LocalPlayer.PlayerScripts.Controllers.PlayerDataController)
local v_u_6 = require(v2.LocalPlayer.PlayerScripts.Controllers.ControlsController)
local v_u_7 = require(v2.LocalPlayer.PlayerScripts.Controllers.CameraController)
local v_u_8 = require(v2.LocalPlayer.PlayerScripts.Controllers.EmoteController)
local v_u_9 = require(v2.LocalPlayer.PlayerScripts.Modules.GameComponents.OutOfBoundsParts)
local v_u_10 = require(v2.LocalPlayer.PlayerScripts.Modules.UserInterface.EliminatedEffect)
local v_u_11 = require(v2.LocalPlayer.PlayerScripts.Modules.UserInterface.Pages)
local v_u_12 = require(v2.LocalPlayer.PlayerScripts.Modules.UILibrary)
local v_u_13 = require(script:WaitForChild("AudioVisualizers"))
local v_u_14 = require(script:WaitForChild("DamageIndicators"))
local v_u_15 = require(script:WaitForChild("EliminationSlots"))
local v_u_16 = require(script:WaitForChild("WarningEffect"))
local v_u_17 = require(script:WaitForChild("SmokeScreen"))
local v_u_18 = require(script:WaitForChild("Spectators"))
local v_u_19 = require(script:WaitForChild("SpeedLines"))
local v_u_20 = require(script:WaitForChild("Flashed"))
local v_u_21 = require(script:WaitForChild("Frozen"))
local v_u_22 = require(script:WaitForChild("Health"))
local v_u_23 = require(script:WaitForChild("Hotbar"))
local v_u_24 = require(script:WaitForChild("Splats"))
local v_u_25 = require(script:WaitForChild("Other"))
local v_u_26 = require(script:WaitForChild("ESP"))
local v_u_27 = v2.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("FighterInterface")
local v_u_28 = {}
v_u_28.__index = v_u_28
function v_u_28.new(p29)
    local v30 = v_u_28
    local v31 = setmetatable({}, v30)
    v31.ActiveChanged = v_u_4.new()
    v31.ClientFighter = p29
    v31.Frame = v_u_27:Clone()
    v31.AudioVisualizers = v_u_13.new(v31)
    v31.DamageIndicators = v_u_14.new(v31)
    v31.EliminationSlots = v_u_15.new(v31)
    v31.WarningEffect = v_u_16.new(v31)
    v31.SmokeScreen = v_u_17.new(v31)
    v31.Spectators = v_u_18.new(v31)
    v31.SpeedLines = v_u_19.new(v31)
    v31.Flashed = v_u_20.new(v31)
    v31.Frozen = v_u_21.new(v31)
    v31.Health = v_u_22.new(v31)
    v31.Hotbar = v_u_23.new(v31)
    v31.Splats = v_u_24.new(v31)
    v31.Other = v_u_25.new(v31)
    v31.ESP = v_u_26.new(v31)
    v31._destroyed = false
    v31._connections = {}
    v31._original_sizings = {}
    v31:_Init()
    return v31
end
function v_u_28.RefillAmmoEffect(p32, ...)
    return p32.Other:RefillAmmoEffect(...)
end
function v_u_28.HealEffect(p33, ...)
    return p33.Health:HealEffect(...)
end
function v_u_28.HurtEffect(p34, ...)
    return p34.Health:HurtEffect(...)
end
function v_u_28.DamageIndicator(p35, ...)
    return p35.DamageIndicators:Create(...)
end
function v_u_28.ClearDamageIndicators(p36, ...)
    return p36.DamageIndicators:Clear(...)
end
function v_u_28.SplatEffect(p37, ...)
    return p37.Splats:Create(...)
end
function v_u_28.EliminationEffect(p38, ...)
    return p38.EliminationSlots:Create(...)
end
function v_u_28.IsActive(p39)
    return p39.Frame.Visible
end
function v_u_28.CreateSound(p40, ...)
    if p40:IsActive() then
        return v_u_3:CreateSound(...)
    end
end
function v_u_28.Update(p41, p42, p43)
    if p43.IsSpectating then
        p41.Hotbar:Update(p42, p43)
        p41.AudioVisualizers:Update(p42, p43)
        p41.DamageIndicators:Update(p42, p43)
        p41.SmokeScreen:Update(p42, p43)
        p41.SpeedLines:Update(p42, p43)
        p41.ESP:Update(p42, p43)
        p41:_SetFrameVisible(true)
    else
        p41.SmokeScreen:Hide()
        p41:_SetFrameVisible(false)
    end
end
function v_u_28.Destroy(p44)
    p44._destroyed = true
    for _, v45 in pairs(p44._connections) do
        v45:Disconnect()
    end
    p44._connections = {}
    p44.ActiveChanged:Destroy()
    p44.AudioVisualizers:Destroy()
    p44.DamageIndicators:Destroy()
    p44.EliminationSlots:Destroy()
    p44.WarningEffect:Destroy()
    p44.SmokeScreen:Destroy()
    p44.Spectators:Destroy()
    p44.SpeedLines:Destroy()
    p44.Flashed:Destroy()
    p44.Frozen:Destroy()
    p44.Health:Destroy()
    p44.Splats:Destroy()
    p44.Other:Destroy()
    p44.ESP:Destroy()
    p44.Frame:Destroy()
end
function v_u_28._UpdateSizing(p46)
    local v47 = v_u_12.MainGui.AbsoluteSize.X / p46.Frame.AbsoluteSize.X
    local v48 = v_u_12.MainGui.AbsoluteSize.Y / p46.Frame.AbsoluteSize.Y
    for _, v49 in pairs({
        "ESP",
        "DamageVignette",
        "FrozenVignette",
        "HealVignette",
        "WarningVignette",
        "SpeedLinesThick",
        "SpeedLinesThin",
        "RefillAmmoVignette"
    }) do
        local v50 = p46.Frame[v49]
        p46._original_sizings[v50] = p46._original_sizings[v50] or {
            ["Position"] = v50.Position,
            ["Size"] = v50.Size
        }
        v50.Size = UDim2.new(p46._original_sizings[v50].Size.X.Scale * v47, p46._original_sizings[v50].Size.X.Offset * v47, p46._original_sizings[v50].Size.Y.Scale * v48, p46._original_sizings[v50].Size.Y.Offset * v48)
        v50.Position = UDim2.new(0.5 + (p46._original_sizings[v50].Position.X.Scale - 0.5) * v47, 0, 0.5 + (p46._original_sizings[v50].Position.Y.Scale - 0.5) * v48, 0)
    end
end
function v_u_28._UpdateVisibility(p51)
    local v52 = not v_u_11.PageSystem.CurrentPage
    local v53 = v_u_10:IsVisible()
    local v54 = p51.Hotbar
    local v55
    if v52 then
        v55 = not v53
    else
        v55 = v52
    end
    v54:SetVisible(v55)
    local v56 = p51.EliminationSlots
    local v57
    if v52 then
        v57 = not v53
    else
        v57 = v52
    end
    v56:SetVisible(v57)
    local v58 = p51.Health
    if v52 then
        v52 = #p51.ClientFighter.Items > 0
    end
    v58:SetVisible(v52)
end
function v_u_28._SetFrameVisible(p59, p60)
    if p59.Frame.Visible ~= p60 then
        p59.Frame.Visible = p60
        p59.ActiveChanged:Fire()
    end
end
function v_u_28._EntityRemoved(p61)
    p61.Frozen:Refresh()
end
function v_u_28._EntityAdded(p_u_62)
    p_u_62.EliminationSlots:Clear()
    p_u_62.DamageIndicators:Clear()
    p_u_62.SmokeScreen:Clear()
    if p_u_62.ClientFighter.Entity then
        local v63 = p_u_62._connections
        local v64 = p_u_62.ClientFighter.Entity.HealthChanged
        table.insert(v63, v64:Connect(function()
            p_u_62.Health:Refresh()
        end))
        local v65 = p_u_62._connections
        local v66 = p_u_62.ClientFighter.Entity:GetDataChangedSignal("IsFrozen")
        table.insert(v65, v66:Connect(function()
            p_u_62.Frozen:Refresh()
        end))
        local v67 = p_u_62._connections
        local v68 = p_u_62.ClientFighter.Entity.Died
        table.insert(v67, v68:Connect(function()
            p_u_62.Frozen:Refresh()
            p_u_62.Hotbar.Keybinds:UpdateVisuals()
        end))
        p_u_62.Health:Refresh()
        p_u_62.Frozen:Refresh()
        p_u_62.Hotbar.Keybinds:UpdateVisuals()
    else
        p_u_62.Health:Refresh()
        p_u_62.Frozen:Refresh()
    end
end
function v_u_28._Setup(p69)
    p69:_SetFrameVisible(false)
    p69.Frame.Name = p69.ClientFighter.Player.Name
    p69.Frame.Parent = v_u_12:GetTo("MainFrame", "FighterInterfaces")
end
function v_u_28._Init(p_u_70)
    p_u_70.Frame:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        p_u_70:_UpdateSizing()
    end)
    local v71 = p_u_70._connections
    local v72 = p_u_70.ClientFighter.EntityAdded
    table.insert(v71, v72:Connect(function()
        p_u_70:_EntityAdded()
    end))
    local v73 = p_u_70._connections
    local v74 = p_u_70.ClientFighter.EntityRemoved
    table.insert(v73, v74:Connect(function()
        p_u_70:_EntityRemoved()
    end))
    local v75 = p_u_70._connections
    local v76 = p_u_70.ClientFighter.EquippedItemChanged
    table.insert(v75, v76:Connect(function()
        p_u_70.Hotbar.Keybinds:UpdateVisuals()
        p_u_70.Hotbar:UpdateVisuals()
        p_u_70.Hotbar:EquipEffect(p_u_70.Hotbar.FighterInterface.ClientFighter.EquippedItem)
        p_u_70.Hotbar.AmmoDisplays:UpdateVisuals()
    end))
    local v77 = p_u_70._connections
    local v78 = p_u_70.ClientFighter.ItemAdded
    table.insert(v77, v78:Connect(function(p79)
        p_u_70.Hotbar:ItemAdded(p79)
        p_u_70.Hotbar.Keybinds:UpdateVisuals()
        p_u_70:_UpdateVisibility()
    end))
    local v80 = p_u_70._connections
    local v81 = p_u_70.ClientFighter.ItemRemoved
    table.insert(v80, v81:Connect(function(p82)
        p_u_70.Hotbar:ItemRemoved(p82)
        p_u_70.Hotbar.Keybinds:UpdateVisuals()
        p_u_70:_UpdateVisibility()
    end))
    local v83 = p_u_70._connections
    local v84 = p_u_70.ClientFighter:GetDataChangedSignal("NumSpectators")
    table.insert(v83, v84:Connect(function()
        p_u_70.Spectators:Refresh()
    end))
    local v85 = p_u_70._connections
    local v86 = p_u_70.ClientFighter:GetDataChangedSignal("IsInDuel")
    table.insert(v85, v86:Connect(function()
        p_u_70.Hotbar.Keybinds:UpdateVisuals()
    end))
    local v87 = p_u_70._connections
    local v88 = p_u_70.ClientFighter:GetDataChangedSignal("QuickAttackOverrides")
    table.insert(v87, v88:Connect(function()
        p_u_70.Hotbar.Keybinds:UpdateVisuals()
    end))
    local v89 = p_u_70._connections
    local v90 = p_u_70.ClientFighter:GetDataChangedSignal("CheaterMode")
    table.insert(v89, v90:Connect(function()
        p_u_70.ESP:Refresh()
    end))
    local v91 = p_u_70._connections
    local v92 = p_u_70.ClientFighter:GetDataChangedSignal("IsAprilFools")
    table.insert(v91, v92:Connect(function()
        p_u_70.Health:Refresh()
    end))
    local v93 = p_u_70._connections
    local v94 = p_u_70.ClientFighter:GetDataChangedSignal("InfiniteAmmo")
    table.insert(v93, v94:Connect(function()
        p_u_70.Hotbar.AmmoDisplays:UpdateAmmo()
    end))
    local v95 = p_u_70._connections
    local v96 = p_u_70.ClientFighter:GetDataChangedSignal("InfiniteAmmoReserve")
    table.insert(v95, v96:Connect(function()
        p_u_70.Hotbar.AmmoDisplays:UpdateAmmo()
    end))
    local v97 = p_u_70._connections
    local v98 = p_u_70.ClientFighter:GetDataChangedSignal("EquippedItemID")
    table.insert(v97, v98:Connect(function()
        p_u_70.Hotbar.AmmoDisplays:UpdateLayouts()
    end))
    local v99 = p_u_70._connections
    local v100 = v_u_7.StateChanged
    table.insert(v99, v100:Connect(function()
        p_u_70.Hotbar.Keybinds:UpdateVisuals()
    end))
    local v101 = p_u_70._connections
    local v102 = v_u_6.ControlsChanged
    table.insert(v101, v102:Connect(function()
        p_u_70.Hotbar.Keybinds:UpdateVisuals()
        p_u_70.Hotbar:UpdateVisibility()
    end))
    local v103 = p_u_70._connections
    local v104 = v_u_8.CanEmoteChanged
    table.insert(v103, v104:Connect(function()
        p_u_70.Hotbar.Keybinds:UpdateVisuals()
    end))
    local v105 = p_u_70._connections
    local v106 = v_u_11.PageSystem.PageOpened
    table.insert(v105, v106:Connect(function()
        p_u_70:_UpdateVisibility()
    end))
    local v107 = p_u_70._connections
    local v108 = v_u_11.PageSystem.PageClosed
    table.insert(v107, v108:Connect(function()
        p_u_70:_UpdateVisibility()
    end))
    local v109 = p_u_70._connections
    local v110 = v_u_10.VisibilityChanged
    table.insert(v109, v110:Connect(function()
        p_u_70:_UpdateVisibility()
    end))
    local v111 = p_u_70._connections
    local v112 = v_u_5:GetDataChangedSignal("Settings Keybinds Interface")
    table.insert(v111, v112:Connect(function()
        p_u_70.Hotbar.Keybinds:UpdateVisuals()
    end))
    if p_u_70.ClientFighter.IsLocalPlayer then
        local v113 = p_u_70._connections
        local v114 = v_u_9.Warning
        table.insert(v113, v114:Connect(function(p115)
            p_u_70.WarningEffect:SetEnabled(true, p115)
        end))
        local v116 = p_u_70._connections
        local v117 = v_u_9.SteppedOut
        table.insert(v116, v117:Connect(function()
            p_u_70.WarningEffect:SetEnabled(false)
        end))
    end
    p_u_70:_Setup()
    p_u_70:_UpdateVisibility()
    p_u_70:_UpdateSizing()
    task.defer(p_u_70._EntityAdded, p_u_70)
    p_u_70.ESP:Refresh()
    p_u_70.Hotbar.Keybinds:UpdateVisuals()
    p_u_70.Spectators:Refresh()
    p_u_70.EliminationSlots:Refresh()
end
return v_u_28