local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("TweenService")
local v_u_3 = game:GetService("Players")
local v_u_4 = require(v1.Modules.CONSTANTS)
local v_u_5 = require(v1.Modules.CosmeticLibrary)
local v_u_6 = require(v1.Modules.ShopLibrary)
local v_u_7 = require(v1.Modules.ItemLibrary)
local v_u_8 = require(v1.Modules.Utility)
local v_u_9 = require(v_u_3.LocalPlayer.PlayerScripts.Controllers.PlayerDataController)
local v_u_10 = require(v_u_3.LocalPlayer.PlayerScripts.Modules.EquipmentButtonSlot)
local v_u_11 = require(v_u_3.LocalPlayer.PlayerScripts.Modules.ButtonEffect)
local v_u_12 = require(v_u_3.LocalPlayer.PlayerScripts.Modules.UILibrary)
local v_u_13 = v_u_3.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("EquipmentQuickActionButton")
local v_u_14 = v_u_3.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("EquipmentUnlockMeBubble")
local v_u_15 = v_u_3.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("EquipmentClassSlot")
local v_u_16 = {}
v_u_16.__index = v_u_16
function v_u_16.new(p17)
    local v18 = v_u_16
    local v19 = setmetatable({}, v18)
    v19.Interface = p17
    v19.Frame = v19.Interface.Frame:WaitForChild("Left")
    v19.Background = v19.Frame:WaitForChild("Background")
    v19.List = v19.Frame:WaitForChild("List")
    v19.Container = v19.List:WaitForChild("Container")
    v19.Layout = v19.Container:WaitForChild("Layout")
    v19.TopBufferFrame = v19.Container:WaitForChild("TopBuffer")
    v19._generate_deferred = false
    v19._cleanup = {}
    v19._weapon_slots = {}
    v19._career_slot = nil
    v19._unlock_me_bubbles = {}
    v19._previous_canvas_position = nil
    v19:_Init()
    return v19
end
function v_u_16.SetVisible(p20, p21)
    p20.Frame:TweenPosition(p21 and UDim2.new(0, 0, 0.5, 0) or UDim2.new(-0.375, 0, 0.5, 0), "Out", "Quint", 0.25, true)
end
function v_u_16.ScrollTo(p_u_22, p_u_23, p24)
    task.delay(p24 or 0, function()
        local v25 = p_u_22.List.AbsoluteCanvasSize.Y
        local v26 = p_u_23.AbsolutePosition.Y + v_u_12.MainGui.AbsolutePosition.Y * 2 - p_u_22.Container.AbsolutePosition.Y
        local v27 = math.min(v25, v26)
        v_u_2:Create(p_u_22.List, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            ["CanvasPosition"] = Vector2.new(0, v27)
        }):Play()
    end)
end
function v_u_16.OnStateChanged(p28)
    p28:_UpdateActive()
    p28:_UpdateUnlockMeBubbles()
end
function v_u_16.OnOpen(p29)
    p29:_GenerateDeferred()
end
function v_u_16.Update(p30, _)
    for _, v31 in pairs(p30._unlock_me_bubbles) do
        local v32 = v31.WeaponSlot.Frame.AbsolutePosition.Y + v31.WeaponSlot.Frame.AbsoluteSize.Y / 2 - v31.Bubble.Parent.AbsolutePosition.Y
        local v33 = v31.Bubble.AbsoluteSize.Y
        local v34 = v31.Bubble.Parent.AbsoluteSize.Y - v31.Bubble.AbsoluteSize.Y
        local v35 = math.clamp(v32, v33, v34)
        v31.Bubble.Position = UDim2.new(0.7, 0, 0, v35)
        local v36 = v31.Bubble.Arrow
        local v37
        if v34 <= v35 then
            v37 = UDim2.new(0.5, 0, 1, -2)
        elseif v35 <= v33 then
            v37 = UDim2.new(0.5, 0, 0, 2)
        else
            v37 = UDim2.new(0, 2, 0.5, 0)
        end
        v36.Position = v37
    end
end
function v_u_16._Update(p_u_38)
    if not p_u_38.Interface.Equipment:IsCustomizing() then
        task.defer(function()
            local v39 = p_u_38.TopBufferFrame
            local v40 = UDim2.new
            local v41 = p_u_38.List.AbsoluteSize.Y * 0.375
            local v42 = p_u_38.List.AbsoluteSize.Y - (p_u_38.Layout.AbsoluteContentSize.Y - p_u_38.TopBufferFrame.AbsoluteSize.Y)
            v39.Size = v40(1, 0, 0, (math.max(v41, v42)))
            p_u_38.List.CanvasSize = UDim2.new(0, 0, 0, p_u_38.Layout.AbsoluteContentSize.Y)
            p_u_38.Background.Size = UDim2.new(0.7, 0, 0, p_u_38.Background.AbsolutePosition.Y + p_u_38.Background.AbsoluteSize.Y - (p_u_38.TopBufferFrame.AbsolutePosition.Y + p_u_38.TopBufferFrame.AbsoluteSize.Y))
        end)
    end
end
function v_u_16._UpdateUnlockMeBubbles(p43)
    for _, v44 in pairs(p43._unlock_me_bubbles) do
        v44.Bubble:Destroy()
    end
    p43._unlock_me_bubbles = {}
    if p43.Interface.Equipment.IsOpen and not p43.Interface.Equipment:IsUnlocking() then
        local v45 = p43.Interface.Equipment:GetSelectedWeapon()
        for v46 in pairs(v_u_9:Get("FreeWeaponUnlockCheck")) do
            if v46 ~= v45 and not v_u_9:GetWeaponData(v46) then
                local v47 = p43._weapon_slots[v46]
                if v47 then
                    local v48 = v_u_14:Clone()
                    v48.Parent = p43.Frame
                    local v49 = p43._unlock_me_bubbles
                    table.insert(v49, {
                        ["Bubble"] = v48,
                        ["WeaponSlot"] = v47
                    })
                end
            end
        end
    end
end
function v_u_16._UpdateActive(p50)
    local v51 = p50.Interface.Equipment:IsCareerPageOpen()
    local v52 = p50.Interface.Equipment:GetSelectedWeapon()
    if p50._career_slot then
        p50._career_slot:SetActive(v51)
    end
    for v53, v54 in pairs(p50._weapon_slots) do
        v54:SetActive(v53 == v52)
    end
end
function v_u_16._GetOrder(_)
    local v_u_55 = v_u_9:GetUnlockedWeapons(true)
    local v_u_56 = v_u_9:GetFavoritedWeapons()
    local v57 = {}
    local v58 = {}
    for _, v59 in pairs(v_u_6:GetReleasedOwnableWeapons(v_u_4.WEAPON_REVEAL_TIME_OFFSET, v_u_6.OwnableWeaponsAlphabetized)) do
        table.insert(v57, v59)
        if v_u_6:GetTimeUntilWeaponRelease(v59) > 0 then
            v58[v59] = true
        end
    end
    table.sort(v57, function(p60, p61)
        local v62 = v_u_56[p60]
        if v62 == v_u_56[p61] then
            local v63 = v_u_55[p60]
            if v63 == v_u_55[p61] then
                local v64 = v_u_7.Classes[v_u_7.Items[p60].Class].Slot
                local v65 = v_u_7.Classes[v_u_7.Items[p61].Class].Slot
                if v64 == v65 then
                    local v66 = v_u_7.Statuses[v_u_7.Items[p60].Status].Value
                    local v67 = v_u_7.Statuses[v_u_7.Items[p61].Status].Value
                    if v66 == v67 then
                        return v_u_8:StringLessThan(p60, p61)
                    else
                        return v66 < v67
                    end
                else
                    return v64 < v65
                end
            else
                return v63
            end
        else
            return v62
        end
    end)
    return v57, v_u_55, v_u_56, v58
end
function v_u_16._Generate(p_u_68)
    for _, v69 in pairs(p_u_68._weapon_slots) do
        v69:Destroy()
    end
    for _, v70 in pairs(p_u_68._cleanup) do
        v70:Destroy()
    end
    p_u_68._weapon_slots = {}
    p_u_68._cleanup = {}
    if p_u_68._career_slot then
        p_u_68._career_slot:Destroy()
        p_u_68._career_slot = nil
    end
    p_u_68._previous_canvas_position = p_u_68._previous_canvas_position or p_u_68.List.CanvasPosition
    if p_u_68.Interface.Equipment.IsOpen and not p_u_68.Interface.Equipment:IsCustomizing() then
        local v71 = v_u_9:Get("CosmeticNotifications")
        local v_u_72 = v_u_5:CountNotifications(v71)
        local v73 = v_u_5:CountNotificationsByCosmeticType(v71, "Emote")
        local v74, v75, v76, v77 = p_u_68:_GetOrder()
        local v_u_78 = {}
        local v_u_79 = {}
        local function v_u_86(p80, p81, p82, p83)
            local v84 = v_u_78.___career
            if v84 and not v_u_79[p80] then
                local v85 = v_u_13:Clone()
                v85.LayoutOrder = p81
                v85.Icon.Image = p82
                v85.Parent = v84.Container.QuickActions.Container
                v_u_11:Add(v85)
                v85.MouseButton1Click:Connect(p83)
                v_u_79[p80] = v85
            end
        end
        local function v107(p87, p88, p89, p90, p91)
            if not v_u_78[p87] then
                local v92 = v_u_7.Classes[p87]
                local v93 = p88 or (v92 and (v92.Slot or -999999) or -999999)
                local v94 = p89 or (v92 and (v92.Name or "") or "")
                local v95 = p90 or (v92 and (v92.ImageDiagonalLeft or "") or "")
                local v96 = p91 or (v92 and v92.ImageDiagonalRight or "")
                local v_u_97 = v_u_15:Clone()
                v_u_97.Container.Footer.Visible = false
                v_u_97.Container.QuickActions.Visible = false
                v_u_97.Container.DismissNotifications.Visible = false
                local v98 = v_u_97.Container.Header
                local v99
                if v94 then
                    v99 = v94 ~= ""
                else
                    v99 = v94
                end
                v98.Visible = v99
                v_u_97.Container.Header.Title.Left.Image = v95
                v_u_97.Container.Header.Title.Right.Image = v96
                v_u_97.Container.Header.Title.Text = v94
                v_u_97.LayoutOrder = v93
                v_u_97.ZIndex = v_u_97.LayoutOrder
                v_u_97.Parent = p_u_68.Container
                local v100 = p_u_68._cleanup
                table.insert(v100, v_u_97)
                v_u_78[p87] = v_u_97
                local v101 = v_u_97.Container.Header
                local v_u_102 = v_u_97.Container.Layout
                local v_u_103 = v_u_97.Container.Header.Title
                local v_u_104 = v_u_97.Container.Header.Title.Left
                local v_u_105 = v_u_97.Container.Header.Title.Right
                local function v106()
                    v_u_97.Size = UDim2.new(1, 0, 0, v_u_102.AbsoluteContentSize.Y)
                    v_u_104.Position = UDim2.new(0.5, -v_u_103.TextBounds.X / 2, 0.5, 0)
                    v_u_105.Position = UDim2.new(0.5, v_u_103.TextBounds.X / 2, 0.5, 0)
                end
                v_u_102:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(v106)
                v101:GetPropertyChangedSignal("AbsoluteSize"):Connect(v106)
                v_u_103:GetPropertyChangedSignal("TextBounds"):Connect(v106)
                v106()
                if p87 == "___career" then
                    v_u_97.Container.QuickActions.Visible = true
                    v_u_97.Container.DismissNotifications.Visible = v_u_72 > 0
                    v_u_97.Container.DismissNotifications.Button.Title.Text = string.format("Dismiss <font weight=\"800\">%s</font> Notification%s", v_u_8:PrettyNumber(v_u_72), v_u_72 == 1 and "" or "s")
                    v_u_11:Add(v_u_97.Container.DismissNotifications.Button, nil, {
                        ["HoverRatio"] = UDim2.new(0, 10, 0, 10),
                        ["ReleaseRatio"] = UDim2.new(0, 10, 0, 10)
                    })
                    v_u_97.Container.DismissNotifications.Button.MouseButton1Click:Connect(function()
                        v_u_9:SilenceCosmeticNotification(nil, nil)
                    end)
                    v_u_86("___career", -1, "rbxassetid://130882808226687", function()
                        p_u_68.Interface.Equipment:StartCustomizing("Emote")
                    end)
                end
            end
            return v_u_78[p87].Container
        end
        local v108 = string.format(v_u_4.HEADSHOT_IMAGE, v_u_3.LocalPlayer.UserId)
        local v109 = v107("___career", -3)
        p_u_68._career_slot = v_u_10.new("___career", -999998, true, "Career", v108, nil, v73)
        p_u_68._career_slot:SetCareerIcon()
        p_u_68._career_slot:SetParent(v109)
        p_u_68._career_slot.Button.MouseButton1Click:Connect(function()
            p_u_68.Interface.Equipment:OpenCareerPage(true)
        end)
        local v_u_110 = {}
        local v111 = false
        for v112, v_u_113 in pairs(v74) do
            local v_u_114 = v_u_7.Items[v_u_113]
            local v_u_115 = v_u_7.Classes[v_u_114.Class]
            local v116 = v_u_9:GetWeaponData(v_u_113)
            local v117 = v75[v_u_113]
            local v118 = not v117
            if v118 then
                v118 = v77[v_u_113]
            end
            local v119 = v76[v_u_113]
            local v120 = v118 and "___comingsoon" or (v119 and "___favorited" or v_u_114.Class)
            local v121
            if v118 then
                v121 = v107(v120, -2, "Coming Soon", "rbxassetid://18195730712", "rbxassetid://18195730712")
            elseif v119 then
                v121 = v107(v120, -1)
            else
                v121 = v107(v120)
            end
            local v122 = v118 and "???" or v_u_113
            local v123 = v116 and v_u_7:GetViewModelImageFromWeaponData(v116) or (v_u_7:GetViewModelImage(v_u_113) or "")
            local v124
            if v117 then
                v124 = v_u_5:CountNotificationsByWeapon(v71, v_u_113)
            else
                v124 = v117
            end
            local v125 = v_u_10.new(v_u_113, v112, v117, v122, v123, v_u_114.Status, v124)
            v125:SetParent(v121)
            p_u_68._weapon_slots[v_u_113] = v125
            v_u_110[v120] = v_u_110[v120] or {}
            local v126 = v_u_110[v120]
            table.insert(v126, v125)
            v125.Button.MouseButton1Click:Connect(function()
                p_u_68.Interface.Equipment:SelectWeapon(v_u_113)
            end)
            v_u_86(v_u_114.Class, v_u_115.Slot, v_u_115.ImageDiagonalRight, function()
                local v127
                if v_u_110[v_u_114.Class] then
                    v127 = v_u_110[v_u_114.Class][1].Name
                else
                    v127 = v_u_4.DEFAULT_WEAPONS[v_u_115.Slot]
                end
                p_u_68.Interface.Equipment:SelectWeapon(v127)
                p_u_68:ScrollTo(p_u_68._weapon_slots[v127].Frame)
            end)
            v111 = v111 or v118
        end
        local v128 = #v_u_6.OwnableWeapons - #v74
        local v129 = v_u_78.___comingsoon
        if v129 then
            local v130 = v129.Container.Footer
            if v111 then
                v111 = v128 > 0
            end
            v130.Visible = v111
            v129.Container.Footer.Title.Text = "+" .. v128 .. " more weapon" .. (v128 == 1 and "" or "s") .. "!"
        end
        p_u_68.List.CanvasPosition = p_u_68._previous_canvas_position or p_u_68.List.CanvasPosition
        p_u_68._previous_canvas_position = nil
        p_u_68:_UpdateActive()
        p_u_68:_UpdateUnlockMeBubbles()
    end
end
function v_u_16._GenerateDeferred(p_u_131)
    if not p_u_131._generate_deferred then
        p_u_131._generate_deferred = true
        task.defer(function()
            p_u_131._generate_deferred = false
            p_u_131:_Generate()
        end)
    end
end
function v_u_16._Setup(p132)
    p132.Frame.Visible = true
end
function v_u_16._Init(p_u_133)
    p_u_133.Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        p_u_133:_Update()
    end)
    p_u_133.Background:GetPropertyChangedSignal("AbsolutePosition"):Connect(function()
        p_u_133:_Update()
    end)
    p_u_133.Background:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        p_u_133:_Update()
    end)
    p_u_133.TopBufferFrame:GetPropertyChangedSignal("AbsolutePosition"):Connect(function()
        p_u_133:_Update()
    end)
    p_u_133.TopBufferFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        p_u_133:_Update()
    end)
    p_u_133.Interface.Equipment.UnlockingChanged:Connect(function()
        p_u_133:_UpdateUnlockMeBubbles()
    end)
    p_u_133.Interface.Equipment.CustomizingChanged:Connect(function()
        p_u_133:_GenerateDeferred()
    end)
    v_u_9:GetDataChangedSignal("FreeWeaponUnlockCheck"):Connect(function()
        p_u_133:_UpdateUnlockMeBubbles()
    end)
    v_u_9:GetDataChangedSignal("WeaponInventory"):Connect(function()
        p_u_133:_GenerateDeferred()
    end)
    v_u_9:GetDataChangedSignal("CosmeticNotifications"):Connect(function()
        p_u_133:_GenerateDeferred()
    end)
    v_u_9.StatisticsUpdated:Connect(function()
        p_u_133:_GenerateDeferred()
    end)
    p_u_133:_Setup()
    p_u_133:_Update()
    p_u_133:_GenerateDeferred()
end
return v_u_16