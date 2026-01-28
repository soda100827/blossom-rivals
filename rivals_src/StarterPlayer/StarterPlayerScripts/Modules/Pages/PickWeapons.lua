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
local v_u_11 = require(v_u_3.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect"))
local v_u_12 = require(v_u_3.LocalPlayer.PlayerScripts.Modules:WaitForChild("WeaponSlot"))
local v_u_13 = require(v_u_3.LocalPlayer.PlayerScripts.Modules:WaitForChild("UILibrary"))
local v_u_14 = require(v_u_3.LocalPlayer.PlayerScripts.Modules:WaitForChild("Page"))
local v_u_15 = v_u_3.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("PickWeaponRandomSlot")
local v_u_16 = v_u_3.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("PickWeaponChosenSlot")
local v_u_17 = setmetatable({}, v_u_14)
v_u_17.__index = v_u_17
function v_u_17._new()
    local v18 = v_u_14.new(script.Name)
    local v19 = v_u_17
    local v20 = setmetatable(v18, v19)
    v20.ChosenWeaponsFrame = v20.PageFrame:WaitForChild("ChosenWeapons")
    v20.HeaderFrame = v20.PageFrame:WaitForChild("Header")
    v20.FreeWeaponsFrame = v20.HeaderFrame:WaitForChild("FreeWeapons")
    v20.MapFrame = v20.HeaderFrame:WaitForChild("Map")
    v20.MapTitle = v20.MapFrame:WaitForChild("Title")
    v20.List = v20.PageFrame:WaitForChild("List")
    v20.Container = v20.List:WaitForChild("Container")
    v20.Layout = v20.Container:WaitForChild("Layout")
    v20.CantBeClosedFromInputs = true
    v20._current_slot = 1
    v20._chosen_weapons = {}
    v20._chosen_weapon_slots = {}
    v20._weapon_slot_cleanup = {}
    v20._ban_frames = {}
    v20._mainframe = v_u_13:GetTo("MainFrame")
    v20:_Init()
    return v20
end
function v_u_17.SetCurrentSlot(p_u_21, p22)
    p_u_21._chosen_weapon_slots[p_u_21._current_slot].Button.Hover.Visible = false
    p_u_21._current_slot = p22
    p_u_21._chosen_weapon_slots[p_u_21._current_slot].Button.Hover.Visible = true
    p_u_21._chosen_weapon_slots[p_u_21._current_slot].Button.Background.ImageTransparency = 0
    p_u_21._chosen_weapon_slots[p_u_21._current_slot].Button.Hover.Size = UDim2.new(1.5, 0, 1.5, 0)
    p_u_21._chosen_weapon_slots[p_u_21._current_slot].Button.Hover:TweenSize(UDim2.new(1, 8, 1, 8), "Out", "Back", 0.25, true)
    for _, v23 in pairs(p_u_21._weapon_slot_cleanup) do
        v23:Destroy()
    end
    p_u_21._weapon_slot_cleanup = {}
    local v24 = {}
    for _, v25 in pairs(v_u_4.ItemsAlphabetized) do
        local v26 = v_u_4.Items[v25]
        if v26.Class == v_u_4.SlotToClass[p_u_21._current_slot].Name or v_u_8.LocalFighter:Get("WeaponClassRestrictionDisabled") then
            table.insert(v24, v26)
        end
    end
    table.sort(v24, function(p27, p28)
        local v29 = v_u_4.Items[p27.Name]
        local v30 = v_u_4.Items[p28.Name]
        if v29.Class == v30.Class then
            if v29.Status == v30.Status then
                return v_u_5:StringLessThan(p27.Name, p28.Name)
            else
                return v_u_4.Statuses[v29.Status].Value > v_u_4.Statuses[v30.Status].Value
            end
        else
            return v_u_4.Classes[v29.Class].Slot < v_u_4.Classes[v30.Class].Slot
        end
    end)
    local v31 = v_u_8.LocalFighter
    if v31 then
        v31 = v_u_8.LocalFighter:Get("LastPickedWeapons")
    end
    local v32 = 0
    local v_u_33 = {}
    for v34, v_u_35 in pairs(v24) do
        if v_u_8.LocalFighter then
            local v36 = v_u_8.LocalFighter:Get("WeaponPool")
            local v37
            if v_u_8.LocalFighter:Get("WeaponPoolFilterType") == "Blacklist" then
                v37 = table.find(v36, v_u_35.Name)
            else
                v37 = false
            end
            if v_u_8.LocalFighter and (v_u_8.LocalFighter:CanUseWeapon(v_u_35.Name) or v37) then
                local v38 = v_u_6:GetWeaponData(v_u_35.Name)
                local v39
                if v31 then
                    v39 = table.find(v31, v_u_35.Name) ~= nil
                else
                    v39 = v31
                end
                local v40 = v_u_12.new(v_u_35.Name, v38)
                v40.Frame.LayoutOrder = v39 and -999999998 or v34
                v40.Frame.Parent = p_u_21.Container
                local v41 = p_u_21._weapon_slot_cleanup
                table.insert(v41, v40)
                v40.PlayBanFrameSound:Connect(function(...)
                    v_u_5:CreateSound(...)
                end)
                if v37 then
                    v40:ToggleBanned(v32 * 0.125, nil)
                    v32 = v32 + 1
                else
                    v40.Frame.Button.MouseButton1Click:Connect(function()
                        p_u_21:_InputPickWeapon(v_u_35.Name)
                    end)
                    local v42 = v_u_35.Name
                    table.insert(v_u_33, v42)
                end
            end
        end
    end
    if #v_u_33 > 1 then
        local v43 = v_u_15:Clone()
        v43.LayoutOrder = -9999999999
        v43.Parent = p_u_21.Container
        v_u_11:Add(v43.Button)
        local v44 = p_u_21._weapon_slot_cleanup
        table.insert(v44, v43)
        v43.Button.MouseButton1Click:Connect(function()
            p_u_21:_InputPickWeapon(v_u_33[math.random(#v_u_33)])
        end)
    end
    local v45 = p_u_21.List
    local v46
    if v_u_8.LocalFighter:Get("WeaponClassRestrictionDisabled") then
        v46 = p_u_21.List.CanvasPosition
    else
        v46 = Vector2.new(0, 0)
    end
    v45.CanvasPosition = v46
end
function v_u_17.PickWeapon(p47, p48, p49)
    local v50 = v_u_6:GetWeaponData(p49)
    p47._chosen_weapons[p48] = p49
    p47._chosen_weapon_slots[p48].Button.Picture.Image = v50 and v_u_4:GetViewModelImageFromWeaponData(v50) or (v_u_4:GetViewModelImage(p49) or "")
end
function v_u_17.Finish(p51)
    local v52 = v_u_10:GetDuel(v_u_3.LocalPlayer)
    if v52 and (v52.LocalDueler and v52.LocalDueler:GetStaggeredSpawnsTurn()) then
        v_u_1.Remotes.Duels.PickWeaponsAheadOfTime:FireServer(p51._chosen_weapons)
    else
        v_u_1.Remotes.Replication.Fighter.PickWeapons:FireServer(p51._chosen_weapons)
    end
    p51.Closed:Fire()
    if v_u_7.CurrentControls == "Gamepad" then
        v_u_2:DisableGamepadCursor()
    end
end
function v_u_17.Start(p_u_53)
    p_u_53:Clear()
    for v_u_54 = 1, v_u_8.LocalFighter:GetMaxEquippableWeapons() do
        local v55 = v_u_16:Clone()
        v55.LayoutOrder = v_u_54
        v55.Parent = p_u_53.ChosenWeaponsFrame
        v_u_11:Add(v55.Button)
        p_u_53._chosen_weapon_slots[v_u_54] = v55
        v55.Button.MouseButton1Click:Connect(function()
            if v_u_54 == 1 or p_u_53._chosen_weapons[v_u_54 - 1] then
                p_u_53:SetCurrentSlot(v_u_54)
            end
        end)
    end
    p_u_53:SetCurrentSlot(1)
    if v_u_7.CurrentControls == "Gamepad" then
        v_u_2:EnableGamepadCursor(p_u_53.ChosenWeaponsFrame)
    end
    p_u_53:_UpdateMap()
    p_u_53:_UpdateFreeWeapons()
end
function v_u_17.Clear(p56)
    for _, v57 in pairs(p56._chosen_weapon_slots) do
        v57:Destroy()
    end
    for _, v58 in pairs(p56._weapon_slot_cleanup) do
        v58:Destroy()
    end
    for _, v59 in pairs(p56._ban_frames) do
        v59:Destroy()
    end
    p56._current_slot = 1
    p56._chosen_weapons = {}
    p56._chosen_weapon_slots = {}
    p56._weapon_slot_cleanup = {}
    p56._ban_frames = {}
end
function v_u_17.Open(p60, ...)
    v_u_14.Open(p60, ...)
    p60:Start()
end
function v_u_17._UpdateList(p61)
    p61.List.CanvasSize = UDim2.new(0, 0, 0, p61.Layout.AbsoluteContentSize.Y)
    p61.List.ClipsDescendants = p61.List.CanvasPosition.Y > 5
    p61.List.Size = UDim2.new(1, 0, 0, p61._mainframe.AbsolutePosition.Y + p61._mainframe.AbsoluteSize.Y - p61.List.AbsolutePosition.Y)
end
function v_u_17._InputPickWeapon(p62, p63)
    p62:PickWeapon(p62._current_slot, p63)
    if p62._current_slot == v_u_8.LocalFighter:GetMaxEquippableWeapons() then
        p62:Finish()
    else
        p62:SetCurrentSlot(p62._current_slot + 1)
    end
end
function v_u_17._UpdateFreeWeapons(p64)
    p64.FreeWeaponsFrame.Visible = v_u_9:IsFreeWeaponsActive()
end
function v_u_17._UpdateMap(p65)
    local v66 = v_u_10:GetDuel(v_u_3.LocalPlayer)
    local v67 = v66 and v66.Map
    if v67 then
        v67 = v66.Map.Name
    end
    local v68 = v_u_8.LocalFighter
    if v68 then
        v68 = v_u_8.LocalFighter:Get("IsInShootingRange")
    end
    p65.MapFrame.Visible = v67 or v68
    p65.MapTitle.Text = v67 and "Map: " .. v67 or (v68 and "Try out any weapon here for free!" or "")
end
function v_u_17._Init(p_u_69)
    p_u_69.Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        p_u_69:_UpdateList()
    end)
    p_u_69.List:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
        p_u_69:_UpdateList()
    end)
    p_u_69:_UpdateList()
end
return v_u_17._new()