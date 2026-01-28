local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("TweenService")
local v3 = game:GetService("Players")
require(v1.Modules.CONSTANTS)
local v_u_4 = require(v1.Modules.CosmeticLibrary)
local v_u_5 = require(v1.Modules.BetterDebris)
local v_u_6 = require(v1.Modules.ShopLibrary)
local v_u_7 = require(v1.Modules.ItemLibrary)
local v_u_8 = require(v3.LocalPlayer.PlayerScripts.Controllers.PlayerDataController)
local v_u_9 = require(v3.LocalPlayer.PlayerScripts.Modules.WeaponStatusHandler)
local v_u_10 = require(v3.LocalPlayer.PlayerScripts.Modules.DropdownSlot)
local v_u_11 = require(v3.LocalPlayer.PlayerScripts.Modules.ButtonEffect)
local v_u_12 = TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
local v_u_13 = {
    "loose_glorycharm",
    "loose_glorywrap",
    "loose_gloryfinisher",
    "loose_gloryemote"
}
local v_u_14 = {}
v_u_14.__index = v_u_14
function v_u_14.new(p15)
    local v16 = v_u_14
    local v17 = setmetatable({}, v16)
    v17.Pages = p15
    v17.Frame = v17.Pages.Frame:WaitForChild("Ranked")
    v17.LooseFrame = v17.Frame:WaitForChild("Loose")
    v17.LooseSlotsFrame = v17.LooseFrame:WaitForChild("Slots")
    v17.WeaponFrame = v17.Frame:WaitForChild("Weapon")
    v17.WeaponSlotsFrame = v17.WeaponFrame:WaitForChild("Slots")
    v17.WeaponHeaderFrame = v17.WeaponFrame:WaitForChild("Header")
    v17.WeaponIcon = v17.WeaponHeaderFrame:WaitForChild("Icon")
    v17.WeaponDropdownFrame = v17.WeaponHeaderFrame:WaitForChild("Dropdown")
    v17.WeaponDropdownButton = v17.WeaponDropdownFrame:WaitForChild("Button")
    v17.WeaponDropdownTitle = v17.WeaponDropdownButton:WaitForChild("Title")
    v17._shop_slots = {}
    v17._selected_weapon_name = v17:_GetWeaponsWithGloriousCosmetics()[1]
    v17._dropdown_slot = nil
    v17._play_glorious_cosmetic_animation = false
    v17._update_cleanup = {}
    v17:_Init()
    return v17
end
function v_u_14.SetSelectedWeaponName(p18, p19)
    p18._selected_weapon_name = p19
    p18:_Update()
end
function v_u_14.Open(p20)
    p20:_Update()
end
function v_u_14.Close(p21)
    p21:_Update()
    p21:_StopDropdown()
end
function v_u_14.Setup(_) end
function v_u_14._GetWeaponsWithGloriousCosmetics(_)
    local v22 = v_u_8:GetUnlockedWeapons()
    local v23 = {}
    for _, v24 in pairs(v_u_6.OwnableWeaponsAlphabetized) do
        if v22[v24] and v_u_4.Cosmetics["Glorious " .. v24] then
            table.insert(v23, v24)
        end
    end
    return v23
end
function v_u_14._StopDropdown(p25)
    if p25._dropdown_slot then
        p25._dropdown_slot:Cancel()
        p25._dropdown_slot = nil
    end
    p25.WeaponDropdownButton.Visible = true
end
function v_u_14._StartDropdown(p_u_26)
    p_u_26:_StopDropdown()
    p_u_26.WeaponDropdownButton.Visible = false
    p_u_26._dropdown_slot = v_u_10.new(p_u_26.WeaponDropdownFrame, p_u_26:_GetWeaponsWithGloriousCosmetics(), 9)
    p_u_26._dropdown_slot.Selected:Connect(function(p27)
        if p27 then
            p_u_26._play_glorious_cosmetic_animation = true
            p_u_26:SetSelectedWeaponName(p27)
        end
        p_u_26:_StopDropdown()
    end)
end
function v_u_14._Update(p28)
    for _, v29 in pairs(p28._shop_slots) do
        v29:Destroy()
    end
    for _, v30 in pairs(p28._update_cleanup) do
        v30:Destroy()
    end
    p28._shop_slots = {}
    p28._update_cleanup = {}
    v_u_9:ClearStatusElements(p28.WeaponDropdownTitle)
    if p28.Pages.Shop:IsOpen() then
        p28.WeaponIcon.Image = v_u_7.Items[p28._selected_weapon_name] and (v_u_7.Items[p28._selected_weapon_name].Image or "") or ""
        p28.WeaponDropdownTitle.Text = p28._selected_weapon_name
        local v31 = v_u_9
        local v32 = p28.WeaponDropdownTitle
        local v33 = v_u_7.Items[p28._selected_weapon_name]
        if v33 then
            v33 = v_u_7.Items[p28._selected_weapon_name].Status
        end
        v31:ApplyItemStatusToText(v32, v33)
        for _, v34 in pairs(v_u_13) do
            local v35 = p28.Pages.Shop:CreateShopSlot(nil, p28.LooseSlotsFrame:WaitForChild(v34), v34)
            if v35 then
                local v36 = p28._shop_slots
                table.insert(v36, v35)
            end
        end
        local v37 = v_u_6.NUM_GLORIOUS_COSMETICS[p28._selected_weapon_name] or 0
        local v38 = true
        for v39 = 1, (1 / 0) do
            local v40 = p28.WeaponSlotsFrame:FindFirstChild(v39)
            local v41 = p28.WeaponSlotsFrame:FindFirstChild("Arrow" .. v39)
            if v40 then
                v40.Visible = false
            end
            if v41 then
                v41.Visible = false
            end
            if not (v40 or v41) then
                break
            end
        end
        for v42 = 1, v37 do
            local v43 = p28.WeaponSlotsFrame:WaitForChild(v42)
            local v44 = "loose_gloriouscosmetic_" .. v42 .. "_" .. p28._selected_weapon_name
            local v45 = p28.Pages.Shop:CreateShopSlot(nil, v43, v44, not v38)
            if v45 then
                v38 = v45.IsOwned
            else
                v38 = v45
            end
            if v45 then
                v43.Visible = true
                for _, v46 in pairs({ v45.Frame, p28.WeaponSlotsFrame:FindFirstChild("Arrow" .. v42 - 1) }) do
                    v46.Visible = true
                    if p28._play_glorious_cosmetic_animation then
                        local v47 = (v42 - 1) * v_u_12.Time * 0.5
                        local v_u_48 = Instance.new("UIScale")
                        v_u_48.Scale = 0
                        v_u_48.Parent = v46
                        local v49 = p28._update_cleanup
                        table.insert(v49, v_u_48)
                        v_u_5:AddItem(v_u_48, v47 + v_u_12.Time)
                        task.delay(v47, function()
                            v_u_2:Create(v_u_48, v_u_12, {
                                ["Scale"] = 1
                            }):Play()
                        end)
                    end
                end
                local v50 = p28._shop_slots
                table.insert(v50, v45)
            end
        end
    end
end
function v_u_14._Init(p_u_51)
    p_u_51.WeaponDropdownButton.MouseButton1Click:Connect(function()
        p_u_51:_StartDropdown()
    end)
    v_u_8:GetDataChangedSignal("CosmeticInventory"):Connect(function()
        p_u_51:_Update()
    end)
    v_u_8:GetDataChangedSignal("WeaponInventory"):Connect(function()
        p_u_51:_Update()
    end)
    v_u_11:Add(p_u_51.WeaponDropdownButton, nil, {
        ["ReleaseRatio"] = 1.025,
        ["HoverRatio"] = 1.025
    })
end
return v_u_14