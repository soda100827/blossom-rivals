local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.CosmeticLibrary)
local v_u_4 = require(v1.Modules.SoundLibrary)
local v_u_5 = require(v1.Modules.Utility)
local v_u_6 = require(v1.Modules.Spring)
local v_u_7 = require(v1.Modules.Signal)
local v_u_8 = require(v_u_2.LocalPlayer.PlayerScripts.Controllers.PlayerDataController)
local v_u_9 = require(v_u_2.LocalPlayer.PlayerScripts.Modules.StaticModel.StaticCharacterModel)
local v_u_10 = require(v_u_2.LocalPlayer.PlayerScripts.Modules.StaticModel.StaticViewModel)
local v_u_11 = CFrame.new(0, 0, 30)
local v_u_12 = CFrame.new(0, -6, -6) * CFrame.Angles(0, 1.5707963267948966, 0) * CFrame.Angles(0.17453292519943295, 0, 0)
local v_u_13 = CFrame.new(0, 0, -6) * CFrame.Angles(0, 2.356194490192345, 0) * CFrame.Angles(0.3490658503988659, 0, 0)
local v_u_14 = CFrame.new(0, -10, -10) * CFrame.Angles(0, 2.356194490192345, 0) * CFrame.Angles(-0.7853981633974483, 0, 0)
local v_u_15 = CFrame.new(0, 0, -10) * CFrame.Angles(0, 3.490658503988659, 0)
local v_u_16 = {}
v_u_16.__index = v_u_16
function v_u_16.new(p17)
    local v18 = v_u_16
    local v19 = setmetatable({}, v18)
    v19.CharmAttachmentVisibleChanged = v_u_7.new()
    v19.Equipment = p17
    v19._last_generate_state = nil
    v19._last_offset_state = nil
    v19._static_viewmodel = nil
    v19._static_charactermodel = nil
    v19._last_equip_sound = nil
    v19._offset_alpha_spring = v_u_6.new(1, 0.875, 10)
    v19:_Init()
    return v19
end
function v_u_16.GetBoundingBox(p20)
    if p20._static_viewmodel then
        return p20._static_viewmodel:GetBoundingBox()
    end
end
function v_u_16.GetCharmPivotAttachment(p21)
    local v22 = p21._static_viewmodel
    if v22 then
        v22 = p21._static_viewmodel:GetCharmPivotAttachment()
    end
    return v22
end
function v_u_16.Update(p23, p24)
    p23:_UpdateStaticModel(p24, p23._static_viewmodel, v_u_12, v_u_13)
    p23:_UpdateStaticModel(p24, p23._static_charactermodel, v_u_14, v_u_15)
end
function v_u_16.OnOpen(p25)
    p25:_Generate()
end
function v_u_16.OnCustomizingStateChanged(p26)
    p26:_Generate()
    p26:_UpdateViewModel()
end
function v_u_16.OnStateChanged(p27)
    p27:_CheckOffsetAnimation()
    p27:_Generate()
end
function v_u_16._GetSelectedCosmeticOverride(p28, p29)
    local v30 = p28.Equipment:GetSelectedCosmetic()
    local v31 = v_u_3.Cosmetics[v30]
    if v31 and v31.Type == p29 then
        local v32 = p28.Equipment.EquipmentState.CosmeticInverted
        local v33 = v_u_8:GetWeaponData(p28.Equipment:GetSelectedWeapon())
        if v33 then
            v33 = v33[p29]
        end
        local v34 = v_u_5:CloneTable(v33 or {})
        v34.Name = v30
        if p29 ~= "Wrap" or v32 == nil then
            v32 = v34.Inverted
        end
        v34.Inverted = v32
        return v34
    end
end
function v_u_16._GetViewModelName(p35)
    local v36 = p35.Equipment:GetSelectedWeapon()
    local v37 = v_u_8:GetWeaponData(v36)
    local v38 = p35:_GetSelectedCosmeticOverride("Skin")
    local v39 = v38 and v38.Name
    if v39 then
        v36 = v39
    elseif v37 and (v37.Skin and v37.Skin.Name ~= "RANDOM_COSMETIC") then
        v36 = v37.Skin.Name or v36
    end
    return v36
end
function v_u_16._CheckOffsetAnimation(p40)
    local v41 = p40.Equipment:GetStateID(true)
    if v41 ~= p40._last_offset_state then
        p40._last_offset_state = v41
        p40._offset_alpha_spring.Value = 0
    end
end
function v_u_16._UpdateStaticModel(p42, p43, p44, p45, p46)
    if p44 then
        local v47 = p45:Lerp(p46, p42._offset_alpha_spring.Value)
        local v48 = p42.Equipment.Scene:GetCFrame() * v_u_11 * v47
        local v49 = p42.Equipment:GetCustomizingType()
        local v50 = (v49 == "Finisher" and true or v49 == "Emote") and Vector3.new(0, -10, 0) or Vector3.new(0, 0, 0)
        p44:PivotTo(CFrame.new(v48.Position) * p42.Equipment.SpinControls:GetCFrame() * v48.Rotation + v50)
        p44:Update(p43)
    end
end
function v_u_16._PlayEquipSound(p_u_51)
    task.defer(function()
        if p_u_51.Equipment.IsOpen and p_u_51.Equipment.Camera:IsOpenEffectDone() then
            if p_u_51._last_equip_sound then
                p_u_51._last_equip_sound:Destroy()
                p_u_51._last_equip_sound = nil
            end
            p_u_51._last_equip_sound = v_u_5:CreateSound(v_u_4.EquipSounds[math.random(#v_u_4.EquipSounds)], 0.5, 0.9 + 0.2 * math.random(), script, true, 5)
        end
    end)
end
function v_u_16._UpdateViewModel(p52)
    if p52._static_viewmodel and p52.Equipment.IsOpen then
        local v53 = v_u_8:GetWeaponData(p52._static_viewmodel.WeaponName)
        local v54 = p52:_GetSelectedCosmeticOverride("Charm")
        local v55 = p52:_GetSelectedCosmeticOverride("Wrap")
        p52._static_viewmodel:SetLocked(not v53)
        local v56 = p52._static_viewmodel
        if not v54 then
            if v53 and (v53.Charm and v53.Charm.Name ~= "RANDOM_COSMETIC") then
                v54 = v53.Charm or nil
            else
                v54 = nil
            end
        end
        v56:SetCharm(v54)
        local v57 = p52._static_viewmodel
        if not v55 then
            if v53 and (v53.Wrap and v53.Wrap.Name ~= "RANDOM_COSMETIC") then
                v55 = v53.Wrap or nil
            else
                v55 = nil
            end
        end
        v57:SetWrap(v55)
    end
end
function v_u_16._GenerateViewModel(p58)
    if p58._static_viewmodel then
        p58._static_viewmodel:Destroy()
        p58._static_viewmodel = nil
    end
    local v59 = p58:_GetViewModelName()
    if v59 and p58.Equipment.IsOpen then
        p58._static_viewmodel = v_u_10.new(v59)
        p58._static_viewmodel:DeleteAnimationContextSubModels("ShowInEquipment")
        p58._static_viewmodel:SetParent(workspace)
        p58:_UpdateForcedVisibleCharmAttachment()
        p58:_UpdateViewModel()
        p58:_PlayEquipSound()
    end
end
function v_u_16._GenerateCharacterModel(p60)
    if p60._static_charactermodel then
        p60._static_charactermodel:Destroy()
        p60._static_charactermodel = nil
    end
    if p60.Equipment:IsCareerPageOpen() and p60.Equipment.IsOpen then
        p60._static_charactermodel = v_u_9.new(v_u_2.LocalPlayer.UserId)
        p60._static_charactermodel:SetParent(workspace)
        p60:_PlayEquipSound()
    end
end
function v_u_16._Generate(p61)
    if p61.Equipment.IsOpen then
        local v62 = p61:_GetViewModelName()
        local v63 = p61.Equipment:GetStateID(true) .. tostring(v62)
        if v63 ~= p61._last_generate_state then
            p61._last_generate_state = v63
            p61:_GenerateViewModel()
            p61:_GenerateCharacterModel()
            p61:Update(0)
        end
    else
        return
    end
end
function v_u_16._UpdateForcedVisibleCharmAttachment(p64)
    if p64._static_viewmodel then
        p64._static_viewmodel:ForceCharmAttachmentModelVisible(p64.Equipment:GetCustomizingType() == "Charm")
        p64.CharmAttachmentVisibleChanged:Fire()
    end
end
function v_u_16._Init(p_u_65)
    p_u_65.Equipment.CustomizingChanged:Connect(function()
        p_u_65:_UpdateForcedVisibleCharmAttachment()
    end)
    v_u_8:GetDataChangedSignal("WeaponInventory"):Connect(function()
        p_u_65:_Generate()
        p_u_65:_UpdateViewModel()
    end)
    p_u_65:_Generate()
    p_u_65:_UpdateForcedVisibleCharmAttachment()
end
return v_u_16