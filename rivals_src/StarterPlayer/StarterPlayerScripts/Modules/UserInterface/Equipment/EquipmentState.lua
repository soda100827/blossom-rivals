local v1 = game:GetService("ReplicatedStorage")
local v2 = require(v1.Modules.CONSTANTS)
local v_u_3 = require(v1.Modules.CosmeticLibrary)
local v_u_4 = require(v1.Modules.ItemLibrary)
local v_u_5 = require(v1.Modules.Signal)
local v_u_6 = v2.DEFAULT_WEAPONS[1]
local v_u_7 = {}
v_u_7.__index = v_u_7
function v_u_7.new(p8)
    local v9 = v_u_7
    local v10 = setmetatable({}, v9)
    v10.SelectedWeaponChanged = v_u_5.new()
    v10.CareerPageOpened = v_u_5.new()
    v10.CareerPageOpened = v_u_5.new()
    v10.CustomizingChanged = v_u_5.new()
    v10.CustomizingStateChanged = v_u_5.new()
    v10.CosmeticSearchChanged = v_u_5.new()
    v10.Equipment = p8
    v10.SelectedWeapon = nil
    v10.IsCareerPageOpen = false
    v10.CustomizingType = nil
    v10.SelectedCosmetic = nil
    v10.CosmeticInverted = nil
    v10.CosmeticSearchQuery = ""
    v10:_Init()
    return v10
end
function v_u_7.SelectWeapon(p11, p12)
    local v13 = not p12 or v_u_4.Items[p12] ~= nil
    assert(v13, p12)
    if p12 then
        p11:OpenCareerPage(false)
    end
    p11.SelectedWeapon = p12
    p11.SelectedWeaponChanged:Fire()
end
function v_u_7.OpenCareerPage(p14, p15)
    local v16 = typeof(p15) == "boolean"
    assert(v16)
    if p15 then
        p14:SelectWeapon(nil)
    end
    p14.IsCareerPageOpen = p15
    p14.CareerPageOpened:Fire()
end
function v_u_7.StartCustomizing(p17, p18)
    local v19 = v_u_3.Types[p18]
    local v20 = not p18
    if not v20 then
        if v19 then
            v20 = not v19.NotCosmetic
        else
            v20 = v19
        end
    end
    assert(v20)
    if p18 then
        p17:OpenCareerPage(p18 == "Emote")
        p17:SelectWeapon(not v19.IsWeaponCosmetic or p17.SelectedWeapon or (v_u_6 or nil))
    else
        p17:SelectCosmetic(nil)
        p17:SetCosmeticInvertedState(nil)
        p17:SetCosmeticSearchQuery(nil)
    end
    p17.CustomizingType = p18
    p17.CustomizingChanged:Fire()
end
function v_u_7.SelectCosmetic(p21, p22)
    local v23 = not p22 or ((p22 == "NONE_COSMETIC" or p22 == "RANDOM_COSMETIC") and true or v_u_3.Cosmetics[p22] ~= nil)
    assert(v23, p22)
    if p22 == "NONE_COSMETIC" then
        p22 = nil
    end
    p21.SelectedCosmetic = p22
    p21.CustomizingStateChanged:Fire()
end
function v_u_7.SetCosmeticInvertedState(p24, p25)
    p24.CosmeticInverted = p25
    p24.CustomizingStateChanged:Fire()
end
function v_u_7.SetCosmeticSearchQuery(p26, p27)
    p26.CosmeticSearchQuery = p27 and string.lower(p27) or ""
    p26.CosmeticSearchChanged:Fire()
end
function v_u_7.OnOpen(p28)
    if p28.Equipment.IsOpen then
        p28:SelectWeapon(p28.SelectedWeapon or v_u_6)
    end
end
function v_u_7._Init(_) end
return v_u_7