local v_u_1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v_u_1.Modules.CosmeticLibrary)
local v_u_4 = require(v2.LocalPlayer.PlayerScripts.Controllers.PlayerDataController)
local v_u_5 = require(v2.LocalPlayer.PlayerScripts.Modules.ButtonEffect)
local v_u_6 = {}
v_u_6.__index = v_u_6
function v_u_6.new(p7)
    local v8 = v_u_6
    local v9 = setmetatable({}, v8)
    v9.Customize = p7
    v9.Frame = v9.Customize.BottomContainer:WaitForChild("Options")
    v9.Background = v9.Frame:WaitForChild("Background")
    v9.Container = v9.Frame:WaitForChild("Container")
    v9.Layout = v9.Container:WaitForChild("Layout")
    v9:_Init()
    return v9
end
function v_u_6.OnCustomizingStateChanged(p10)
    p10:_Update()
end
function v_u_6.OnStateChanged(p11)
    p11:_Update()
end
function v_u_6._UpdateBackground(p12)
    p12.Background.Size = UDim2.new(0, p12.Layout.AbsoluteContentSize.X, 1, 0)
    p12.Background.Visible = p12.Layout.AbsoluteContentSize.X > 1
end
function v_u_6._OnOptionClicked(p13, p14, p15)
    local v16 = p13.Container:WaitForChild(p14):WaitForChild("Container"):WaitForChild("Button")
    v16.MouseButton1Click:Connect(p15)
    v_u_5:Add(v16)
end
function v_u_6._SetOption(p17, p18, p19, p20)
    local v21 = p17.Container:WaitForChild(p18)
    local v22 = v21:WaitForChild("Container"):WaitForChild("Button")
    local v23 = v22:WaitForChild("Empty")
    local v24 = v22:WaitForChild("Filled")
    v21.Visible = p19
    v24.Visible = p20
    v23.Visible = not p20
end
function v_u_6._Update(p25)
    if p25.Customize.Interface.Equipment.IsOpen then
        local v26 = p25.Customize.Interface.Equipment:GetSelectedWeapon()
        local v27 = p25.Customize.Interface.Equipment:GetSelectedCosmetic()
        local v28 = p25.Customize.Interface.Equipment:GetCustomizingType()
        local v29 = v_u_4:GetWeaponData(v26)
        local v30
        if v29 then
            if v27 then
                v30 = v_u_3:OwnsCosmetic(v_u_4:Get("CosmeticInventory"), v27, v26)
            else
                v30 = v27
            end
        else
            v30 = v29
        end
        local v31 = v_u_4:Get("FavoritedCosmetics")
        local v32 = v27 or "NONE_COSMETIC"
        local v33 = v30 or v32 == "NONE_COSMETIC"
        local v34 = v33 and v31[v26]
        if v34 then
            v34 = v31[v26][v32]
        end
        p25:_SetOption("Favorited", v33, v34)
        local v35
        if v28 == "Wrap" then
            if v27 then
                v35 = v27 ~= "RANDOM_COSMETIC"
            else
                v35 = v27
            end
        else
            v35 = false
        end
        local v36
        if p25.Customize.Interface.Equipment.EquipmentState.CosmeticInverted == nil then
            v36 = v29 and v29.Wrap
            if v36 then
                v36 = v29.Wrap.Inverted
            end
        else
            v36 = p25.Customize.Interface.Equipment.EquipmentState.CosmeticInverted
        end
        p25:_SetOption("Inverted", v35, v36)
        local v37 = v27 == "RANDOM_COSMETIC"
        local v38 = v37 and (v29 and v29[v28])
        if v38 then
            v38 = v29[v28].OnlyUseFavorites
        end
        p25:_SetOption("OnlyUseFavorites", v37, v38)
    end
end
function v_u_6._Init(p_u_39)
    p_u_39.Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        p_u_39:_UpdateBackground()
    end)
    p_u_39:_OnOptionClicked("Favorited", function()
        local v40 = p_u_39.Customize.Interface.Equipment:GetSelectedWeapon()
        local v41 = p_u_39.Customize.Interface.Equipment:GetSelectedCosmetic()
        local v42 = v_u_4:Get("FavoritedCosmetics")
        local v43 = v41 or "NONE_COSMETIC"
        local v44 = v42[v40]
        if v44 then
            v44 = v42[v40][v43]
        end
        v_u_1.Remotes.Data.FavoriteCosmetic:FireServer(v40, v43, not v44)
    end)
    p_u_39:_OnOptionClicked("Inverted", function()
        local v45 = p_u_39.Customize.Interface.Equipment:GetSelectedWeapon()
        local v46 = p_u_39.Customize.Interface.Equipment:GetSelectedCosmetic()
        local v47 = p_u_39.Customize.Interface.Equipment:GetCustomizingType()
        local v48 = v_u_4:GetWeaponData(v45)
        if v48 then
            if v46 then
                v46 = v_u_3:OwnsCosmetic(v_u_4:Get("CosmeticInventory"), v46, v45)
            end
        else
            v46 = v48
        end
        local v49
        if p_u_39.Customize.Interface.Equipment.EquipmentState.CosmeticInverted == nil then
            v49 = v48 and v48.Wrap
            if v49 then
                v49 = v48.Wrap.Inverted
            end
        else
            v49 = p_u_39.Customize.Interface.Equipment.EquipmentState.CosmeticInverted
        end
        local v50 = not v49
        p_u_39.Customize.Interface.Equipment.EquipmentState:SetCosmeticInvertedState(v50)
        if v46 then
            v_u_1.Remotes.Data.EquipCosmetic:FireServer(v45, v47, v48.Wrap.Name, {
                ["IsInverted"] = v50
            })
        end
    end)
    p_u_39:_OnOptionClicked("OnlyUseFavorites", function()
        local v51 = p_u_39.Customize.Interface.Equipment:GetSelectedWeapon()
        local v52 = p_u_39.Customize.Interface.Equipment:GetCustomizingType()
        local v53 = v_u_4:GetWeaponData(v51)
        local v54 = {
            ["OnlyUseFavorites"] = not v53[v52].OnlyUseFavorites
        }
        v_u_1.Remotes.Data.EquipCosmetic:FireServer(v51, v52, v53[v52].Name, v54)
    end)
    v_u_4:GetDataChangedSignal("WeaponInventory"):Connect(function()
        p_u_39:_Update()
    end)
    v_u_4:GetDataChangedSignal("CosmeticInventory"):Connect(function()
        p_u_39:_Update()
    end)
    v_u_4:GetDataChangedSignal("FavoritedCosmetics"):Connect(function()
        p_u_39:_Update()
    end)
    p_u_39:_UpdateBackground()
end
return v_u_6