local v_u_1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("GamepadService")
local v_u_3 = game:GetService("Players")
require(v_u_1.Modules.CONSTANTS)
local v_u_4 = require(v_u_1.Modules.ItemLibrary)
require(v_u_1.Modules.ShopLibrary)
local v_u_5 = require(v_u_1.Modules.Utility)
local v_u_6 = require(v_u_3.LocalPlayer.PlayerScripts.Controllers:WaitForChild("PlayerDataController"))
local v_u_7 = require(v_u_3.LocalPlayer.PlayerScripts.Controllers:WaitForChild("ControlsController"))
local v_u_8 = require(v_u_3.LocalPlayer.PlayerScripts.Controllers:WaitForChild("FighterController"))
local v_u_9 = require(v_u_3.LocalPlayer.PlayerScripts.Controllers:WaitForChild("FFlagController"))
local v_u_10 = require(v_u_3.LocalPlayer.PlayerScripts.Controllers:WaitForChild("DuelController"))
local v_u_11 = require(v_u_3.LocalPlayer.PlayerScripts.Modules:WaitForChild("WeaponStatusHandler"))
local v_u_12 = require(v_u_3.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect"))
local v_u_13 = require(v_u_3.LocalPlayer.PlayerScripts.Modules:WaitForChild("VoteBanFrame"))
local v_u_14 = require(v_u_3.LocalPlayer.PlayerScripts.Modules:WaitForChild("Page"))
local v_u_15 = v_u_3.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("PickWeaponRandomListSlot")
local v_u_16 = v_u_3.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("PickWeaponListChosenSlot")
local v_u_17 = v_u_3.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("PickWeaponListSlot")
local v_u_18 = setmetatable({}, v_u_14)
v_u_18.__index = v_u_18
function v_u_18._new()
    local v19 = v_u_14.new(script.Name)
    local v20 = v_u_18
    local v21 = setmetatable(v19, v20)
    v21.ChosenWeaponsFrame = v21.PageFrame:WaitForChild("ChosenWeapons")
    v21.HeaderFrame = v21.PageFrame:WaitForChild("Header")
    v21.FreeWeaponsFrame = v21.HeaderFrame:WaitForChild("FreeWeapons")
    v21.MapFrame = v21.HeaderFrame:WaitForChild("Map")
    v21.MapTitle = v21.MapFrame:WaitForChild("Title")
    v21.ListContainer = v21.PageFrame:WaitForChild("ListContainer")
    v21.List = v21.ListContainer:WaitForChild("List")
    v21.Container = v21.List:WaitForChild("Container")
    v21.Layout = v21.Container:WaitForChild("Layout")
    v21.LastPickedDivider = v21.Container:WaitForChild("LastPickedDivider")
    v21.CantBeClosedFromInputs = true
    v21._current_slot = 1
    v21._chosen_weapons = {}
    v21._chosen_weapon_slots = {}
    v21._pick_weapon_slots = {}
    v21._ban_frames = {}
    v21:_Init()
    return v21
end
function v_u_18.SetCurrentSlot(p_u_22, p23)
    p_u_22._chosen_weapon_slots[p_u_22._current_slot].Button.Hover.Visible = false
    p_u_22._current_slot = p23
    p_u_22.ChosenWeaponsFrame:TweenPosition(UDim2.new(0.5 - 0.125 * (p_u_22._current_slot - 1), 0, 0.1, 0), "Out", "Quint", 0.25, true)
    p_u_22._chosen_weapon_slots[p_u_22._current_slot].Button.Hover.Visible = true
    p_u_22._chosen_weapon_slots[p_u_22._current_slot].Button.Background.ImageTransparency = 0
    p_u_22._chosen_weapon_slots[p_u_22._current_slot].Button.Hover.Size = UDim2.new(1.5, 0, 1.5, 0)
    p_u_22._chosen_weapon_slots[p_u_22._current_slot].Button.Hover:TweenSize(UDim2.new(1, 8, 1, 8), "Out", "Back", 0.25, true)
    for _, v24 in pairs(p_u_22._pick_weapon_slots) do
        v24:Destroy()
    end
    p_u_22._pick_weapon_slots = {}
    p_u_22.LastPickedDivider.Visible = false
    local v25 = {}
    for _, v26 in pairs(v_u_4.ItemsAlphabetized) do
        local v27 = v_u_4.Items[v26]
        if v27.Class == v_u_4.SlotToClass[p_u_22._current_slot].Name or v_u_8.LocalFighter:Get("WeaponClassRestrictionDisabled") then
            table.insert(v25, v27)
        end
    end
    table.sort(v25, function(p28, p29)
        local v30 = v_u_4.Items[p28.Name]
        local v31 = v_u_4.Items[p29.Name]
        if v30.Class == v31.Class then
            if v30.Status == v31.Status then
                return v_u_5:StringLessThan(p28.Name, p29.Name)
            else
                return v_u_4.Statuses[v30.Status].Value > v_u_4.Statuses[v31.Status].Value
            end
        else
            return v_u_4.Classes[v30.Class].Slot < v_u_4.Classes[v31.Class].Slot
        end
    end)
    local v32 = v_u_8.LocalFighter
    if v32 then
        v32 = v_u_8.LocalFighter:Get("LastPickedWeapons")
    end
    local v_u_33 = {}
    local v34 = 0
    for v35, v_u_36 in pairs(v25) do
        if v_u_8.LocalFighter then
            local v37 = v_u_8.LocalFighter:Get("WeaponPool")
            local v38
            if v_u_8.LocalFighter:Get("WeaponPoolFilterType") == "Blacklist" then
                v38 = table.find(v37, v_u_36.Name)
            else
                v38 = false
            end
            if v_u_8.LocalFighter and (v_u_8.LocalFighter:CanUseWeapon(v_u_36.Name) or v38) then
                local v39 = v_u_6:GetWeaponData(v_u_36.Name)
                local v40
                if v32 then
                    v40 = table.find(v32, v_u_36.Name) ~= nil
                else
                    v40 = v32
                end
                local v41 = v_u_17:Clone()
                v41.LayoutOrder = v40 and -3 or v35 * 2
                v41.ZIndex = v41.LayoutOrder
                v41.Button.Icon.Picture.Image = v39 and v_u_4:GetViewModelImageFromWeaponData(v39) or (v_u_4:GetViewModelImage(v_u_36.Name) or "")
                v41.Button.Title.Text = v_u_36.Name
                v41.Parent = p_u_22.Container
                v_u_12:Add(v41.Button, nil, {
                    ["HoverRatio"] = 1.025,
                    ["ReleaseRatio"] = 1.025
                })
                local v42 = p_u_22._pick_weapon_slots
                table.insert(v42, v41)
                v_u_11:ApplyItemStatusToText(v41.Button.Title, v_u_36.Status)
                if v38 then
                    v41.Button.Icon.ClipsDescendants = true
                    v41.Button.Title.Visible = false
                    local v43 = v_u_13.new(v41.Button, UDim2.new(1, 0, 0.9, 0))
                    local v44 = p_u_22._ban_frames
                    table.insert(v44, v43)
                    v43.CreateSound:Connect(function(...)
                        v_u_5:CreateSound(...)
                    end)
                    task.delay(v34 * 0.125, v43.Play, v43, nil, true)
                    v34 = v34 + 1
                else
                    v41.Button.MouseButton1Click:Connect(function()
                        p_u_22:_InputPickWeapon(v_u_36.Name)
                    end)
                    local v45 = v_u_36.Name
                    table.insert(v_u_33, v45)
                end
                p_u_22.LastPickedDivider.Visible = p_u_22.LastPickedDivider.Visible or v40
            end
        end
    end
    if #v_u_33 > 1 then
        local v46 = v_u_15:Clone()
        v46.LayoutOrder = -1
        v46.Parent = p_u_22.Container
        v_u_12:Add(v46.Button, nil, {
            ["HoverRatio"] = 1.025,
            ["ReleaseRatio"] = 1.025
        })
        local v47 = p_u_22._pick_weapon_slots
        table.insert(v47, v46)
        v46.Button.MouseButton1Click:Connect(function()
            p_u_22:_InputPickWeapon(v_u_33[math.random(#v_u_33)])
        end)
    end
    table.sort(p_u_22._pick_weapon_slots, function(p48, p49)
        return p48.LayoutOrder < p49.LayoutOrder
    end)
    for v50, v51 in pairs(p_u_22._pick_weapon_slots) do
        v51.Button.Size = UDim2.new(0.75, 0, 1, 0)
        v51.Button:TweenSize(UDim2.new(1, 0, 1, 0), "Out", "Back", 0.05 * v50, true)
    end
    local v52 = p_u_22.List
    local v53
    if v_u_8.LocalFighter:Get("WeaponClassRestrictionDisabled") then
        v53 = p_u_22.List.CanvasPosition
    else
        v53 = Vector2.new(0, 0)
    end
    v52.CanvasPosition = v53
end
function v_u_18.PickWeapon(p54, p55, p56)
    local v57 = v_u_6:GetWeaponData(p56)
    p54._chosen_weapons[p55] = p56
    p54._chosen_weapon_slots[p55].Button.Picture.Image = v57 and v_u_4:GetViewModelImageFromWeaponData(v57) or (v_u_4:GetViewModelImage(p56) or "")
end
function v_u_18.Finish(p58)
    local v59 = v_u_10:GetDuel(v_u_3.LocalPlayer)
    if v59 and (v59.LocalDueler and v59.LocalDueler:GetStaggeredSpawnsTurn()) then
        v_u_1.Remotes.Duels.PickWeaponsAheadOfTime:FireServer(p58._chosen_weapons)
    else
        v_u_1.Remotes.Replication.Fighter.PickWeapons:FireServer(p58._chosen_weapons)
    end
    p58.Closed:Fire()
    if v_u_7.CurrentControls == "Gamepad" then
        v_u_2:DisableGamepadCursor()
    end
end
function v_u_18.Start(p_u_60)
    p_u_60:Clear()
    for v_u_61 = 1, v_u_8.LocalFighter:GetMaxEquippableWeapons() do
        local v62 = v_u_16:Clone()
        v62.LayoutOrder = v_u_61
        v62.Parent = p_u_60.ChosenWeaponsFrame
        v_u_12:Add(v62.Button)
        p_u_60._chosen_weapon_slots[v_u_61] = v62
        v62.Button.MouseButton1Click:Connect(function()
            if v_u_61 == 1 or p_u_60._chosen_weapons[v_u_61 - 1] then
                p_u_60:SetCurrentSlot(v_u_61)
            end
        end)
    end
    p_u_60:SetCurrentSlot(1)
    if v_u_7.CurrentControls == "Gamepad" then
        v_u_2:EnableGamepadCursor(p_u_60.ChosenWeaponsFrame)
    end
    p_u_60:_UpdateMap()
    p_u_60:_UpdateFreeWeapons()
end
function v_u_18.Clear(p63)
    for _, v64 in pairs(p63._chosen_weapon_slots) do
        v64:Destroy()
    end
    for _, v65 in pairs(p63._pick_weapon_slots) do
        v65:Destroy()
    end
    for _, v66 in pairs(p63._ban_frames) do
        v66:Destroy()
    end
    p63._current_slot = 1
    p63._chosen_weapons = {}
    p63._chosen_weapon_slots = {}
    p63._pick_weapon_slots = {}
    p63._ban_frames = {}
end
function v_u_18.Open(p67, ...)
    v_u_14.Open(p67, ...)
    p67:Start()
end
function v_u_18._InputPickWeapon(p68, p69)
    p68:PickWeapon(p68._current_slot, p69)
    if p68._current_slot == v_u_8.LocalFighter:GetMaxEquippableWeapons() then
        p68:Finish()
    else
        p68:SetCurrentSlot(p68._current_slot + 1)
    end
end
function v_u_18._UpdateFreeWeapons(p70)
    p70.FreeWeaponsFrame.Visible = v_u_9:IsFreeWeaponsActive()
    p70.MapFrame.Size = p70.FreeWeaponsFrame.Visible and UDim2.new(1, 0, 1.5, 0) or UDim2.new(1, 0, 1, 0)
    p70.MapTitle.Size = p70.FreeWeaponsFrame.Visible and UDim2.new(0.875, 0, 0.467, 0) or UDim2.new(0.875, 0, 0.7, 0)
end
function v_u_18._UpdateMap(p71)
    local v72 = v_u_10:GetDuel(v_u_3.LocalPlayer)
    local v73 = v72 and v72.Map
    if v73 then
        v73 = v72.Map.Name
    end
    local v74 = v_u_8.LocalFighter
    if v74 then
        v74 = v_u_8.LocalFighter:Get("IsInShootingRange")
    end
    p71.MapFrame.Visible = v73 or v74
    p71.MapTitle.Text = v73 and "Map: " .. v73 or (v74 and "Try out any weapon here for free!" or "")
end
function v_u_18._Init(p_u_75)
    p_u_75.Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        p_u_75.List.CanvasSize = UDim2.new(0, 0, 0, p_u_75.Layout.AbsoluteContentSize.Y)
    end)
    p_u_75.List:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
        p_u_75.ListContainer.ClipsDescendants = p_u_75.List.CanvasPosition.Y > 5
    end)
end
return v_u_18._new()