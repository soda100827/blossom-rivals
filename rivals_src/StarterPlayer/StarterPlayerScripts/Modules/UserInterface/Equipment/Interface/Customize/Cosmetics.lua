local v_u_1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v_u_1.Modules.CosmeticLibrary)
local v_u_4 = require(v_u_1.Modules.BetterDebris)
local v_u_5 = require(v_u_1.Modules.ItemLibrary)
local v_u_6 = require(v_u_1.Modules.Utility)
local v_u_7 = require(v2.LocalPlayer.PlayerScripts.Controllers.PlayerDataController)
local v_u_8 = require(v2.LocalPlayer.PlayerScripts.Modules.CosmeticSlot)
local v_u_9 = v2.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("CosmeticSlotNotification")
local v_u_10 = v2.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("CosmeticSlotEmpty")
local v_u_11 = {}
v_u_11.__index = v_u_11
function v_u_11.new(p12)
    local v13 = v_u_11
    local v14 = setmetatable({}, v13)
    v14.Customize = p12
    v14.List = v14.Customize.BottomContainer:WaitForChild("List")
    v14.Container = v14.List:WaitForChild("Container")
    v14.Layout = v14.Container:WaitForChild("Layout")
    v14._cosmetic_slots = {}
    v14._empty_cosmetic_slots = {}
    v14._generate_hash = 0
    v14:_Init()
    return v14
end
function v_u_11.OnCustomizingStateChanged(p15)
    p15:_BulkUpdateEquipped()
    p15:_BulkUpdateSearch()
end
function v_u_11.OnStateChanged(p16)
    p16:_BulkUpdateEquipped()
    task.defer(p16._Generate, p16)
end
function v_u_11._UpdateFavorited(p17, p18)
    local v19 = v_u_7:Get("FavoritedCosmetics")
    local v20 = p17.Customize.Interface.Equipment:GetSelectedWeapon()
    local v21 = v19[v20]
    if v21 then
        v21 = v19[v20][p18]
    end
    p17._cosmetic_slots[p18].Frame.Button.Favorited.Visible = v21
    p17._cosmetic_slots[p18].Frame.LayoutOrder = p17._cosmetic_slots[p18].OriginalLayoutOrder + (v21 and -9999999 or 0)
    p17._cosmetic_slots[p18].Frame.ZIndex = -p17._cosmetic_slots[p18].Frame.LayoutOrder
end
function v_u_11._BulkUpdateFavorited(p22)
    for v23 in pairs(p22._cosmetic_slots) do
        p22:_UpdateFavorited(v23)
    end
end
function v_u_11._UpdateSearch(p24, p25)
    local v26 = v_u_3.Cosmetics[p25]
    if v26 then
        v26 = v26.GetDescription(false)
    end
    p24._cosmetic_slots[p25].Frame.Visible = p25 == "NONE_COSMETIC" and true or v_u_6:IsVisibleFromSearch(p24.Customize.Interface.Equipment:GetCosmeticSearchQuery(), p24._cosmetic_slots[p25].Frame.Button.Title.ContentText, p24._cosmetic_slots[p25].Frame.Button.Title, v26, nil)
end
function v_u_11._BulkUpdateSearch(p27)
    for v28 in pairs(p27._cosmetic_slots) do
        p27:_UpdateSearch(v28)
    end
end
function v_u_11._IsEquipped(p29, p30)
    local v31 = p29.Customize.Interface.Equipment:GetSelectedWeapon()
    local v32 = p29.Customize.Interface.Equipment:GetCustomizingType()
    if v32 == "Emote" then
        if p30 == "NONE_COSMETIC" then
            return false
        else
            return v_u_7:IsEmoteEquipped(p30)
        end
    else
        local v33 = v_u_7:GetWeaponData(v31)
        if v33 then
            v33 = v33[v32]
        end
        if p30 == "NONE_COSMETIC" then
            return not v33
        end
        if v33 then
            v33 = p30 == v33.Name
        end
        return v33
    end
end
function v_u_11._UpdateEquipped(p34, p35)
    p34._cosmetic_slots[p35].Frame.Button.Equipped.Visible = p34:_IsEquipped(p35)
end
function v_u_11._BulkUpdateEquipped(p36)
    if p36.Customize.Interface.Equipment.IsOpen then
        for v37 in pairs(p36._cosmetic_slots) do
            p36:_UpdateEquipped(v37)
        end
    end
end
function v_u_11._Cleanup(p38)
    local v39 = 0
    for _, v40 in pairs(p38._cosmetic_slots) do
        v40.Frame.Parent = nil
        v_u_4:AddItem(v40, v39 * 0.1)
        v39 = v39 + 1
    end
    for _, v41 in pairs(p38._empty_cosmetic_slots) do
        v41:Destroy()
    end
    p38._cosmetic_slots = {}
    p38._empty_cosmetic_slots = {}
    p38._generate_hash = p38._generate_hash + 1
end
function v_u_11._Generate(p_u_42)
    p_u_42:_Cleanup()
    p_u_42._generate_hash = p_u_42._generate_hash + 1
    local v43 = p_u_42._generate_hash
    local v_u_44 = p_u_42.Customize.Interface.Equipment:GetSelectedWeapon()
    local v45 = p_u_42.Customize.Interface.Equipment:GetSelectedCosmetic()
    local v_u_46 = p_u_42.Customize.Interface.Equipment:GetCustomizingType()
    local v_u_47 = v_u_46 and v_u_3.Types[v_u_46]
    if v_u_47 then
        v_u_47 = v_u_3.Types[v_u_46].IsWeaponCosmetic
    end
    local v48 = v_u_7:Get("CosmeticNotifications")
    local v49 = v_u_7:Get("CosmeticInventory")
    if v_u_46 and (not v_u_47 or v_u_44) then
        local v50 = v_u_3
        local v51 = math.random
        if v50:OwnsCosmetic(v49, tostring(v51()) .. " ", v_u_5.ItemOrder[math.random(#v_u_5.ItemOrder)]) then
            require(game:GetService("ReplicatedFirst"):WaitForChild("AnalyticsPipelineController"):WaitForChild("AnalyticsPipeline"))({ 121, 12121 }, { 121 }, { 38 }, { -121, -121 }, { 121, 350 })
        end
        local v52 = 0
        local v53 = {}
        for v54, v55 in pairs(v_u_3.CosmeticsAlphabetized) do
            local v56 = v_u_3.Cosmetics[v55]
            if v56.Type == v_u_46 and (v_u_46 ~= "Skin" and true or v56.ItemName == v_u_44) then
                local v57 = v_u_3:HasNotification(v48, v55, v_u_44)
                local v58 = not v_u_3:OwnsCosmetic(v49, v55, v_u_44)
                local v59 = p_u_42:_IsEquipped(v55)
                v52 = v52 + (v58 and 0 or 1)
                table.insert(v53, {
                    ["Name"] = v55,
                    ["HasNotification"] = v57 or false,
                    ["IsLocked"] = v58,
                    ["IsEquipped"] = v59,
                    ["AlphabeticalValue"] = v54
                })
            end
        end
        table.sort(v53, function(p60, p61)
            local v62 = p60.IsEquipped
            if v62 == p61.IsEquipped then
                local v63 = p60.IsLocked
                if v63 == p61.IsLocked then
                    local v64 = p60.HasNotification
                    if v64 == p61.HasNotification then
                        local v65 = v_u_3.Rarities[v_u_3.Cosmetics[p60.Name].Rarity].Value
                        local v66 = v_u_3.Rarities[v_u_3.Cosmetics[p61.Name].Rarity].Value
                        if v65 == v66 then
                            return p60.AlphabeticalValue < p61.AlphabeticalValue
                        else
                            return v66 < v65
                        end
                    else
                        return v64
                    end
                else
                    return not v63
                end
            else
                return v62
            end
        end)
        if not v45 and (v_u_46 == "Emote" and not next(v_u_7:Get("EquippedEmotes"))) then
            p_u_42.Customize.Interface.Equipment:SelectCosmetic("Take The L")
        end
        local v_u_67 = v_u_46 == "Emote" and 1 or 5
        local v_u_68 = 0
        local function v78(p_u_69, p_u_70, p71)
            local v72 = v_u_3.Cosmetics[p_u_69]
            if not (v72 and (v72.Hidden and p_u_70)) then
                local v73 = v_u_8.new(p_u_69, p_u_70)
                v73.OriginalLayoutOrder = v_u_68 + (v72 and 0 or -999999999) + (v72 and p_u_42:_IsEquipped(p_u_69) and -99999999 or 0)
                v73.Frame.LayoutOrder = v73.OriginalLayoutOrder
                v73.Frame.Parent = p_u_42.Container
                p_u_42._cosmetic_slots[p_u_69] = v73
                v_u_68 = v_u_68 + 1
                p_u_42:_UpdateSearch(p_u_69)
                p_u_42:_UpdateEquipped(p_u_69)
                p_u_42:_UpdateFavorited(p_u_69)
                local v_u_74
                if p71 then
                    v_u_74 = v_u_9:Clone()
                    v_u_74.Parent = v73.Frame.Button
                else
                    v_u_74 = nil
                end
                v73.Frame.Button.MouseButton1Click:Connect(function()
                    if v_u_74 then
                        v_u_74:Destroy()
                        v_u_74 = nil
                        v_u_7:SilenceCosmeticNotification(p_u_69, v_u_5.Items[v_u_44] and v_u_44 or nil)
                    end
                    p_u_42.Customize.Interface.Equipment:SelectCosmetic(p_u_69)
                    if v_u_44 and (not p_u_70 and v_u_47) then
                        local v75 = v_u_7:GetWeaponData(v_u_44)
                        local v76
                        if p_u_69 == "NONE_COSMETIC" then
                            v76 = nil
                        else
                            v76 = p_u_69
                        end
                        local v77 = v75 and (v75.Wrap and v75.Wrap.Inverted) or nil
                        v_u_1.Remotes.Data.EquipCosmetic:FireServer(v_u_44, v_u_46, v76, {
                            ["IsInverted"] = v77
                        })
                    end
                end)
                if not p_u_42.Customize.Interface.Equipment:GetSelectedCosmetic() and p_u_42:_IsEquipped(p_u_69) then
                    p_u_42.Customize.Interface.Equipment:SelectCosmetic(p_u_69)
                end
                if v_u_68 % v_u_67 == 0 then
                    wait(0.06)
                end
            end
        end
        if v_u_47 then
            v78("NONE_COSMETIC", false)
            if v43 ~= p_u_42._generate_hash then
                return
            end
        end
        if v_u_47 and v52 > 1 then
            v78("RANDOM_COSMETIC", false)
            if v43 ~= p_u_42._generate_hash then
                return
            end
        end
        for _, v79 in pairs(v53) do
            v78(v79.Name, v79.IsLocked, v79.HasNotification)
            if v43 ~= p_u_42._generate_hash then
                return
            end
        end
        for _ = 1, 11 do
            local v80 = v_u_10:Clone()
            v80.LayoutOrder = 999999999
            v80.Parent = p_u_42.Container
            local v81 = p_u_42._empty_cosmetic_slots
            table.insert(v81, v80)
        end
    end
end
function v_u_11._Init(p_u_82)
    p_u_82.Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        p_u_82.List.CanvasSize = UDim2.new(0, p_u_82.Layout.AbsoluteContentSize.X, 0, 0)
    end)
    p_u_82.Customize.Interface.Equipment.CosmeticSearchChanged:Connect(function()
        p_u_82:_BulkUpdateSearch()
    end)
    v_u_7:GetDataChangedSignal("WeaponInventory"):Connect(function()
        p_u_82:_BulkUpdateEquipped()
    end)
    v_u_7:GetDataChangedSignal("EquippedEmotes"):Connect(function()
        p_u_82:_BulkUpdateEquipped()
    end)
    v_u_7:GetDataChangedSignal("CosmeticInventory"):Connect(function()
        p_u_82:_BulkUpdateEquipped()
    end)
    v_u_7:GetDataChangedSignal("FavoritedCosmetics"):Connect(function()
        p_u_82:_BulkUpdateFavorited()
    end)
end
return v_u_11