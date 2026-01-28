local v_u_1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("GamepadService")
local v_u_3 = game:GetService("RunService")
local v_u_4 = game:GetService("StarterGui")
game:GetService("Lighting")
local v5 = game:GetService("Players")
local v_u_6 = require(v_u_1.Modules.LootLibrary)
local v_u_7 = require(v_u_1.Modules.ShopLibrary)
local v_u_8 = require(v_u_1.Modules.Utility)
local v_u_9 = require(v_u_1.Modules.Signal)
local v_u_10 = require(v5.LocalPlayer.PlayerScripts.Controllers.ShootingRangeController)
local v_u_11 = require(v5.LocalPlayer.PlayerScripts.Controllers.MonetizationController)
local v_u_12 = require(v5.LocalPlayer.PlayerScripts.Controllers.PlayerDataController)
local v_u_13 = require(v5.LocalPlayer.PlayerScripts.Controllers.FighterController)
local v_u_14 = require(v5.LocalPlayer.PlayerScripts.Controllers.CameraController)
local v_u_15 = require(v5.LocalPlayer.PlayerScripts.Modules.UserInterface.MobileButtons)
local v_u_16 = require(v5.LocalPlayer.PlayerScripts.Modules.UserInterface.Teleporting)
local v_u_17 = require(v5.LocalPlayer.PlayerScripts.Modules.UserInterface.Queue)
local v_u_18 = require(v5.LocalPlayer.PlayerScripts.Modules.UserInterface.Pages)
local v_u_19 = require(v5.LocalPlayer.PlayerScripts.Modules.UILibrary)
local v_u_20 = require(script:WaitForChild("EquipmentState"))
local v_u_21 = require(script:WaitForChild("FloatingModel"))
local v_u_22 = require(script:WaitForChild("SpinControls"))
local v_u_23 = require(script:WaitForChild("Interface"))
local v_u_24 = require(script:WaitForChild("Camera"))
local v_u_25 = require(script:WaitForChild("Scene"))
local v_u_26 = {}
v_u_26.__index = v_u_26
function v_u_26._new()
    local v27 = v_u_26
    local v28 = setmetatable({}, v27)
    v28.Opened = v_u_9.new()
    v28.SelectedWeaponChanged = v_u_9.new()
    v28.CareerPageOpened = v_u_9.new()
    v28.CustomizingChanged = v_u_9.new()
    v28.CustomizingStateChanged = v_u_9.new()
    v28.CosmeticSearchChanged = v_u_9.new()
    v28.UnlockingChanged = v_u_9.new()
    v28.FinishedOpenEffect = v_u_9.new()
    v28.CharmAttachmentVisibleChanged = v_u_9.new()
    v28.Frame = v_u_19:GetTo("MainFrame", "Equipment")
    v28.IsOpen = false
    v28.EquipmentState = v_u_20.new(v28)
    v28.Camera = v_u_24.new(v28)
    v28.Scene = v_u_25.new(v28)
    v28.FloatingModel = v_u_21.new(v28)
    v28.SpinControls = v_u_22.new(v28)
    v28.Interface = v_u_23.new(v28)
    v28._is_trying_weapon = false
    v28._from_shop = false
    v28._was_chat_active = true
    v28._open_hash = 0
    v28._on_state_changed_queued = false
    v28._on_customizing_state_changed_queued = false
    v28:_Init()
    return v28
end
function v_u_26.IsCareerPageOpen(p29)
    return p29.EquipmentState.IsCareerPageOpen
end
function v_u_26.IsOpenEffectDone(p30, ...)
    return p30.Camera:IsOpenEffectDone(...)
end
function v_u_26.IsUnlocking(p31)
    return p31.Scene.UnlockModel.IsUnlocking
end
function v_u_26.IsCustomizing(p32)
    return p32.EquipmentState.CustomizingType ~= nil
end
function v_u_26.GetStateID(p33, p34)
    p33:IsCustomizing()
    local v35 = p33:IsCareerPageOpen()
    local v36 = p33:GetSelectedWeapon()
    local v37 = v_u_12:GetWeaponData(v36)
    if v35 then
        return "FAKE_CAREER_STATE"
    end
    if not v36 then
        return "nil"
    end
    local v38
    if p34 then
        local v39 = v37 ~= nil
        v38 = tostring(v39) or ""
    else
        v38 = ""
    end
    return v36 .. v38
end
function v_u_26.GetSelectedWeapon(p40)
    return p40.EquipmentState.SelectedWeapon
end
function v_u_26.GetSelectedCosmetic(p41)
    return p41.EquipmentState.SelectedCosmetic
end
function v_u_26.GetCosmeticSearchQuery(p42)
    return p42.EquipmentState.CosmeticSearchQuery
end
function v_u_26.GetCustomizingType(p43)
    return p43.EquipmentState.CustomizingType
end
function v_u_26.SetCosmeticSearchQuery(p44, ...)
    return p44.EquipmentState:SetCosmeticSearchQuery(...)
end
function v_u_26.SelectCosmetic(p45, ...)
    return p45.EquipmentState:SelectCosmetic(...)
end
function v_u_26.SelectWeapon(p46, ...)
    return p46.EquipmentState:SelectWeapon(...)
end
function v_u_26.OpenCareerPage(p47, ...)
    return p47.EquipmentState:OpenCareerPage(...)
end
function v_u_26.StartCustomizing(p48, ...)
    return p48.EquipmentState:StartCustomizing(...)
end
function v_u_26.FavoriteWeapon(p49)
    local v50 = p49:GetSelectedWeapon()
    if v50 then
        v_u_1.Remotes.Data.FavoriteWeapon:FireServer(v50)
    end
end
function v_u_26.LevelUpWeapon(p51)
    local v52 = p51:GetSelectedWeapon()
    local v53 = v_u_12:GetWeaponData(v52)
    if v53 then
        local v54 = v_u_6:GetCostToLevelUp(v53.Level, v53.XP)
        if v_u_12:Get("WeaponKeys") < v54 then
            v_u_18.PageSystem:OpenPage("Shop", true)
            v_u_18.PageSystem:WaitForPage("Shop"):SetPage("Currency")
            v_u_11:PromptCurrencyBundlePurchase(v54, "WeaponKeys")
        else
            v_u_8:CreateSound("rbxassetid://18242015218", 1, 1, script, true, 6)
            v_u_1.Remotes.Data.LevelUpWeapon:FireServer(v52)
        end
    else
        return
    end
end
function v_u_26.UnlockWeapon(p55)
    local v56 = p55:GetSelectedWeapon()
    local v57, v58, v59, _ = v_u_7:GetWeaponKeyPriceInfo(v56, v_u_12:Get("UnlockTokens"), v_u_12:Get("FreeWeaponUnlockCheck"))
    if v59 or v_u_7:IsWeaponReleased(v56) then
        if v_u_12:Get("WeaponKeys") < v57 and not v58 then
            v_u_18.PageSystem:OpenPage("Shop", true)
            v_u_18.PageSystem:WaitForPage("Shop"):SetPage("Currency")
            v_u_11:PromptCurrencyBundlePurchase(v57, "WeaponKeys")
        else
            p55.Scene.UnlockModel:PlayAnimation()
            v_u_1.Remotes.Data.UnlockWeapon:FireServer(v56)
        end
    else
        return
    end
end
function v_u_26.TryWeapon(p60)
    local v61 = p60:GetSelectedWeapon()
    if v61 then
        p60._is_trying_weapon = true
        p60._from_shop = false
        p60:Close(nil, true)
        v_u_10:Enter(v61)
    end
end
function v_u_26.Open(p_u_62, p63, p64)
    if p64 or not (v_u_14:GetPublicState() or p_u_62.IsOpen) then
        p_u_62._open_hash = p_u_62._open_hash + 1
        p_u_62:Close(true)
        p_u_62._renderstep_connection = v_u_3.RenderStepped:Connect(function(p65)
            p_u_62:_Update(p65)
        end)
        p_u_62._from_shop = p63
        p_u_62._was_chat_active = v_u_4:GetCore("ChatActive")
        v_u_15:SetEquipmentPageVisible(true)
        v_u_2:EnableGamepadCursor(p_u_62.Frame)
        pcall(v_u_4.SetCore, v_u_4, "ChatActive", false)
        p_u_62.IsOpen = true
        p_u_62.Opened:Fire()
    end
end
function v_u_26.Close(p66, p67, p68)
    if p66.IsOpen or p67 then
        p66._open_hash = p66._open_hash + 1
        if p68 then
            local v69 = p66._open_hash
            p66.Camera:CloseEffect()
            if v69 ~= p66._open_hash then
                return
            end
        end
        if p66._renderstep_connection then
            p66._renderstep_connection:Disconnect()
            p66._renderstep_connection = nil
        end
        v_u_15:SetEquipmentPageVisible(false)
        v_u_2:DisableGamepadCursor()
        pcall(v_u_4.SetCore, v_u_4, "ChatActive", p66._was_chat_active)
        p66.IsOpen = false
        p66.Opened:Fire()
        if p66._from_shop then
            p66._from_shop = false
            v_u_18.PageSystem:OpenPage("Shop", true)
        end
    end
end
function v_u_26.CloseRequest(p70)
    if p70:IsCustomizing() then
        p70:StartCustomizing(nil)
    elseif p70:IsOpenEffectDone() then
        p70:Close(nil, true)
    end
end
function v_u_26._OnCustomizingStateChanged(p_u_71, ...)
    if not p_u_71._on_customizing_state_changed_queued then
        p_u_71._on_customizing_state_changed_queued = true
        task.defer(function(...)
            p_u_71._on_customizing_state_changed_queued = false
            p_u_71.Interface:OnCustomizingStateChanged(...)
            p_u_71.FloatingModel:OnCustomizingStateChanged(...)
            p_u_71.Scene:OnCustomizingStateChanged(...)
        end, ...)
    end
end
function v_u_26._OnStateChanged(p_u_72, ...)
    if not p_u_72._on_state_changed_queued then
        p_u_72._on_state_changed_queued = true
        task.defer(function(...)
            p_u_72._on_state_changed_queued = false
            p_u_72.Scene:OnStateChanged(...)
            p_u_72.Camera:OnStateChanged(...)
            p_u_72.SpinControls:OnStateChanged(...)
            p_u_72.FloatingModel:OnStateChanged(...)
            p_u_72.Interface:OnStateChanged(...)
        end, ...)
    end
end
function v_u_26._OnOpen(p73, ...)
    p73.EquipmentState:OnOpen(...)
    p73.Camera:OnOpen(...)
    p73.Scene:OnOpen(...)
    p73.SpinControls:OnOpen(...)
    p73.FloatingModel:OnOpen(...)
    p73.Interface:OnOpen(...)
end
function v_u_26._Update(p74, ...)
    p74.Camera:Update(...)
    p74.SpinControls:Update(...)
    p74.FloatingModel:Update(...)
    p74.Interface:Update(...)
end
function v_u_26._UpdateVisibility(p75)
    local v76 = p75.Frame
    local v77 = p75.IsOpen
    if v77 then
        v77 = not v_u_12:Get("Settings Hide HUD")
    end
    v76.Visible = v77
end
function v_u_26._CheckInterruption(p78)
    if v_u_17:IsVisible() or (v_u_16.Enabled or v_u_15.EditorEnabled) then
        p78:Close()
    end
end
function v_u_26._HookLocalFighter(p_u_79)
    local v_u_80 = v_u_13:WaitForLocalFighter()
    v_u_80:GetDataChangedSignal("IsInShootingRange"):Connect(function()
        if v_u_80:Get("IsInShootingRange") then
            p_u_79:Close()
        elseif p_u_79._is_trying_weapon and not v_u_80:Get("IsInShootingRange") then
            p_u_79._is_trying_weapon = false
            p_u_79:Open(nil, true)
        end
    end)
    v_u_80:GetDataChangedSignal("IsInDuel"):Connect(function()
        if v_u_80:Get("IsInDuel") then
            p_u_79:Close()
        end
    end)
end
function v_u_26._Init(p_u_81)
    p_u_81.Opened:Connect(function(...)
        p_u_81:_UpdateVisibility()
        p_u_81:_OnOpen(...)
    end)
    p_u_81.SelectedWeaponChanged:Connect(function(...)
        p_u_81:_OnStateChanged(...)
    end)
    p_u_81.CareerPageOpened:Connect(function(...)
        p_u_81:_OnStateChanged(...)
    end)
    p_u_81.CustomizingChanged:Connect(function(...)
        p_u_81:_OnStateChanged(...)
        p_u_81:_OnCustomizingStateChanged()
    end)
    p_u_81.CustomizingStateChanged:Connect(function(...)
        p_u_81:_OnCustomizingStateChanged(...)
    end)
    p_u_81.EquipmentState.SelectedWeaponChanged:Connect(function(...)
        p_u_81.SelectedWeaponChanged:Fire(...)
    end)
    p_u_81.EquipmentState.CareerPageOpened:Connect(function(...)
        p_u_81.CareerPageOpened:Fire(...)
    end)
    p_u_81.EquipmentState.CustomizingChanged:Connect(function(...)
        p_u_81.CustomizingChanged:Fire(...)
    end)
    p_u_81.EquipmentState.CustomizingStateChanged:Connect(function(...)
        p_u_81.CustomizingStateChanged:Fire(...)
    end)
    p_u_81.EquipmentState.CosmeticSearchChanged:Connect(function(...)
        p_u_81.CosmeticSearchChanged:Fire(...)
    end)
    p_u_81.Scene.UnlockModel.UnlockingChanged:Connect(function(...)
        p_u_81.UnlockingChanged:Fire(...)
    end)
    p_u_81.Camera.FinishedOpenEffect:Connect(function(...)
        p_u_81.FinishedOpenEffect:Fire(...)
    end)
    p_u_81.FloatingModel.CharmAttachmentVisibleChanged:Connect(function(...)
        p_u_81.CharmAttachmentVisibleChanged:Fire(...)
    end)
    v_u_17.VisibilityChanged:Connect(function()
        p_u_81:_CheckInterruption()
    end)
    v_u_16.EnabledChanged:Connect(function()
        p_u_81:_CheckInterruption()
    end)
    v_u_15.EditorEnabledChanged:Connect(function()
        p_u_81:_CheckInterruption()
    end)
    v_u_12:GetDataChangedSignal("Settings Hide HUD"):Connect(function()
        p_u_81:_UpdateVisibility()
    end)
    p_u_81:Close()
    p_u_81:_UpdateVisibility()
    task.spawn(p_u_81._HookLocalFighter, p_u_81)
end
return v_u_26._new()