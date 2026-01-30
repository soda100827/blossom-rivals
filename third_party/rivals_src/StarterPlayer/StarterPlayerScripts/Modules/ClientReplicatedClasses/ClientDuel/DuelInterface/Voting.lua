local v_u_1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("GamepadService")
local v_u_3 = game:GetService("TweenService")
game:GetService("Lighting")
local v_u_4 = game:GetService("Players")
local v_u_5 = require(v_u_1.Modules.DuelLibrary)
local v_u_6 = require(v_u_1.Modules.ItemLibrary)
local v_u_7 = require(v_u_1.Modules.Utility)
local v_u_8 = require(v_u_1.Modules.Signal)
local v_u_9 = require(v_u_4.LocalPlayer.PlayerScripts.Controllers.ControlsController)
require(v_u_4.LocalPlayer.PlayerScripts.Modules.VoteBanFrame)
local v_u_10 = require(v_u_4.LocalPlayer.PlayerScripts.Modules.ButtonEffect)
local v_u_11 = require(v_u_4.LocalPlayer.PlayerScripts.Modules.WeaponSlot)
local v_u_12 = require(v_u_4.LocalPlayer.PlayerScripts.Modules.MapSlot)
local v_u_13 = v_u_4.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("VoteWeaponTabButton")
local v_u_14 = v_u_4.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("BanIcon")
local v_u_15 = {}
v_u_15.__index = v_u_15
function v_u_15.new(p16)
    local v17 = v_u_15
    local v18 = setmetatable({}, v17)
    v18.VisibilityChanged = v_u_8.new()
    v18.DuelInterface = p16
    v18.Frame = v18.DuelInterface.Frame:WaitForChild("Voting")
    v18.MapsFrame = v18.Frame:WaitForChild("Maps")
    v18.MapsCenter = v18.MapsFrame:WaitForChild("MapsCenter")
    v18.MapsCenterLayout = v18.MapsCenter:WaitForChild("Layout")
    v18.MapsList = v18.MapsFrame:WaitForChild("MapsList")
    v18.MapsListContainer = v18.MapsList:WaitForChild("Container")
    v18.MapsListLayout = v18.MapsListContainer:WaitForChild("Layout")
    v18.MapsChosenEffectFrame = v18.MapsFrame:WaitForChild("ChosenEffect")
    v18.MapsArcadeModeFrame = v18.MapsFrame:WaitForChild("ArcadeMode")
    v18.MapsArcadeModeTitle = v18.MapsArcadeModeFrame:WaitForChild("Container"):WaitForChild("Title")
    v18.WeaponsFrame = v18.Frame:WaitForChild("Weapons")
    v18.WeaponsMapFrame = v18.WeaponsFrame:WaitForChild("Map")
    v18.WeaponsMapContainer = v18.WeaponsMapFrame:WaitForChild("Container")
    v18.WeaponsMapTitle = v18.WeaponsMapContainer:WaitForChild("Title")
    v18.WeaponsContainer = v18.WeaponsFrame:WaitForChild("Container")
    v18.WeaponsTabsFrame = v18.WeaponsContainer:WaitForChild("Tabs")
    v18.WeaponsList = v18.WeaponsContainer:WaitForChild("List")
    v18.WeaponsListContainer = v18.WeaponsList:WaitForChild("Container")
    v18.WeaponsListLayout = v18.WeaponsListContainer:WaitForChild("Layout")
    v18.RemainingBansFrame = v18.Frame:WaitForChild("RemainingBans")
    v18.RemainingBansContainer = v18.RemainingBansFrame:WaitForChild("Container")
    v18.RemainingBansStart = v18.RemainingBansFrame:WaitForChild("Start")
    v18.RemainingBansFinish = v18.RemainingBansFrame:WaitForChild("Finish")
    v18._destroyed = false
    v18._generate_hash = 0
    v18._last_vote_options_type = nil
    v18._remaining_ban_icons_generated = false
    v18._remaining_ban_icons_generate_hash = 0
    v18._remaining_ban_icons = {}
    v18._map_slots = {}
    v18._map_chosen_slot = nil
    v18._map_chosen_hash = 0
    v18._weapon_class_selected = nil
    v18._weapon_tab_buttons = {}
    v18._weapon_slots = {}
    v18._weapon_slots_banned = {}
    v18._weapon_ban_icons = {}
    v18._last_map_chosen_result = nil
    v18._ban_sound_debounce = {}
    v18:_Init()
    return v18
end
function v_u_15.IsOpen(p19)
    local v20 = not p19._destroyed
    if v20 then
        v20 = p19.Frame.Visible
    end
    return v20
end
function v_u_15.PlayMapChosenEffect(p21, p22)
    local v23 = UDim2.new(0, 0, 0, 0)
    local v24 = UDim2.new(0.5, 0, 3, 0)
    for _, v25 in pairs(p21._map_slots) do
        if v25.Name == p22.Name then
            local v26 = v25.Frame.AbsolutePosition + v25.Frame.AbsoluteSize * 0.5 - p21.MapsChosenEffectFrame.AbsolutePosition
            v24 = UDim2.new(0, v26.X, 0, v26.Y)
            v23 = UDim2.new(0, v25.Frame.AbsoluteSize.X, 0, v25.Frame.AbsoluteSize.Y)
        end
    end
    p21:_ClearMaps()
    p21:_ClearMapChosenEffect()
    p21._last_map_chosen_result = p22
    p21._map_chosen_hash = p21._map_chosen_hash + 1
    local v27 = p21._map_chosen_hash
    p21._map_chosen_slot = v_u_12.new(p22.Name, true)
    p21._map_chosen_slot.Frame.SizeConstraint = Enum.SizeConstraint.RelativeXY
    p21._map_chosen_slot.Frame.Size = v23
    p21._map_chosen_slot.Frame.Position = v24
    p21._map_chosen_slot:SetParent(p21.MapsChosenEffectFrame)
    p21._map_chosen_slot.Frame:TweenSizeAndPosition(UDim2.new(1, 0, 1, 0), UDim2.new(0.5, 0, 0.5, 0), "Out", "Quint", 0.75, true)
    p21.WeaponsMapTitle.Text = "Map: " .. p22.Name
    p21.DuelInterface:CreateSound("rbxassetid://103035811146294", 1, 1, script, true, 5)
    wait(1.25)
    if v27 == p21._map_chosen_hash then
        p21._map_chosen_slot.Frame:TweenSize(UDim2.new(0, 0, 0, 0), "In", "Quint", 0.75, true)
        wait(0.75)
        if v27 == p21._map_chosen_hash then
            p21._map_chosen_slot:Destroy()
            p21._map_chosen_slot = nil
        end
    else
        return
    end
end
function v_u_15.Generate(p_u_28)
    p_u_28._generate_hash = p_u_28._generate_hash + 1
    local v29 = p_u_28.DuelInterface.ClientDuel:Get("VoteOptions")
    if v29 then
        v29 = not p_u_28.DuelInterface:IsPageOpen()
    end
    p_u_28.Frame.Visible = v29
    p_u_28.VisibilityChanged:Fire()
    if v29 then
        if not v_u_2.GamepadCursorEnabled and v_u_9.CurrentControls == "Gamepad" then
            v_u_2:EnableGamepadCursor(p_u_28.Frame)
        end
        task.spawn(function()
            local v30 = p_u_28.DuelInterface.ClientDuel:Get("VoteOptionsType")
            if p_u_28._last_vote_options_type ~= v30 then
                p_u_28._last_vote_options_type = v30
                p_u_28._remaining_ban_icons_generated = false
                local v31 = p_u_28
                v31._remaining_ban_icons_generate_hash = v31._remaining_ban_icons_generate_hash + 0
            end
            if v30 == "Maps" then
                p_u_28:_ClearWeapons()
                p_u_28:_GenerateMaps()
            elseif v30 == "Weapons" then
                p_u_28:_ClearMaps()
                p_u_28:_GenerateWeapons()
            end
        end)
    else
        v_u_2:DisableGamepadCursor()
        p_u_28._remaining_ban_icons_generated = false
        p_u_28._remaining_ban_icons_generate_hash = p_u_28._remaining_ban_icons_generate_hash + 0
        p_u_28:_ClearMaps()
        p_u_28:_ClearWeapons()
    end
end
function v_u_15.Destroy(p32)
    p32._destroyed = true
    p32.VisibilityChanged:Destroy()
    p32:_ClearMaps()
    p32:_ClearMapChosenEffect()
    p32:_ClearWeapons()
end
function v_u_15._PlayBanSound(p_u_33, p_u_34, ...)
    if not p_u_33._ban_sound_debounce[p_u_34] then
        p_u_33._ban_sound_debounce[p_u_34] = true
        task.defer(function(...)
            p_u_33._ban_sound_debounce[p_u_34] = nil
            p_u_33.DuelInterface:CreateSound(p_u_34, ...)
        end, ...)
    end
end
function v_u_15._ClearMapChosenEffect(p35)
    p35._map_chosen_hash = p35._map_chosen_hash + 1
    if p35._map_chosen_slot then
        p35._map_chosen_slot:Destroy()
        p35._map_chosen_slot = nil
    end
end
function v_u_15._SetWeaponClassSelected(p36, p37)
    p36._weapon_class_selected = p37
    p36:_UpdateWeapons()
end
function v_u_15._UpdateWeapons(p38)
    for v39, _ in pairs(v_u_6.Classes) do
        local v40 = v39 == p38._weapon_class_selected
        local v41 = p38._weapon_tab_buttons[v39]
        v41.Title.TextColor3 = v40 and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(255, 255, 255)
        v41.Title.Icon.ImageColor3 = v40 and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(255, 255, 255)
        v41.Background.ImageColor3 = v40 and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(0, 0, 0)
        v41.Background.ImageTransparency = v40 and 0 or 0.25
        v41.Background.UIGradient.Enabled = not v40
    end
    for v42, v43 in pairs(p38._weapon_slots) do
        v43.Frame.Visible = v_u_6.Items[v42].Class == p38._weapon_class_selected
    end
end
function v_u_15._GenerateRemainingBans(p_u_44)
    for _, v45 in pairs(p_u_44._weapon_ban_icons) do
        v45:Destroy()
    end
    p_u_44._weapon_ban_icons = {}
    local v46 = p_u_44.DuelInterface.ClientDuel:Get("VoteOptions")
    local v47 = p_u_44.DuelInterface.ClientDuel:Get("VoteOptionsType")
    local v48
    if v47 == "Weapons" then
        v48 = p_u_44.DuelInterface.ClientDuel:Get("MaxWeaponBansPerTeam")
    else
        v48 = p_u_44.DuelInterface.ClientDuel:Get("MaxMapBansPerTeam")
    end
    local v49 = v48 or 0
    local v50 = p_u_44.DuelInterface.ClientDuel:Get("VoteBansRemaining") or {}
    local v51 = false
    if not p_u_44._remaining_ban_icons_generated then
        for _, v52 in pairs(p_u_44._remaining_ban_icons) do
            for _, v53 in pairs(v52) do
                v53:Destroy()
            end
        end
        p_u_44._remaining_ban_icons = {}
        p_u_44._remaining_ban_icons_generated = true
        p_u_44._remaining_ban_icons_generate_hash = p_u_44._remaining_ban_icons_generate_hash + 1
        local v_u_54 = p_u_44._remaining_ban_icons_generate_hash
        local v55 = {}
        for _, v56 in pairs(p_u_44.DuelInterface.ClientDuel.Duelers) do
            local v57 = v56:Get("TeamID")
            if v57 then
                v55[v57] = true
            end
        end
        local v58 = p_u_44.DuelInterface.ClientDuel:GetDueler(v_u_4.LocalPlayer)
        local v_u_59 = 1
        for v60 in pairs(v55) do
            if v58 then
                local _ = v60 == v58:Get("TeamID")
            end
            local v61 = v_u_5:GetTeamColor(v60)
            for _ = 1, v49 - (v50[v60] or 0) do
                local v62 = 1 - (v_u_59 - 1) * 0.1
                local v_u_63 = v_u_14:Clone()
                v_u_63.ImageColor3 = v_u_7:DarkenColor(v61, v62 * 0.5)
                v_u_63.Icon.ImageColor3 = v_u_7:DarkenColor(v61, v62)
                v_u_63.LayoutOrder = v_u_59
                v_u_63.ZIndex = -v_u_59
                p_u_44._remaining_ban_icons[v60] = p_u_44._remaining_ban_icons[v60] or {}
                local v64 = p_u_44._remaining_ban_icons[v60]
                table.insert(v64, v_u_63)
                task.delay((v_u_59 - 1) * 0.25 + 0.125, function()
                    if v_u_54 == p_u_44._remaining_ban_icons_generate_hash then
                        v_u_63.UIScale.Scale = 0.25
                        v_u_63.Parent = p_u_44.RemainingBansContainer
                        v_u_3:Create(v_u_63.UIScale, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                            ["Scale"] = 1
                        }):Play()
                        p_u_44.DuelInterface:CreateSound("rbxassetid://92837039207579", 1.25, v_u_59 * 0.075 + 0.75, script, true, 5)
                    end
                end)
                local v65 = v_u_59 + 1
                v_u_59 = v65
                v51 = true
            end
        end
        p_u_44.RemainingBansContainer.Position = p_u_44.RemainingBansStart.Position
        p_u_44.RemainingBansContainer:TweenPosition(p_u_44.RemainingBansContainer.Position, "Out", "Linear", 0, true)
        p_u_44.RemainingBansContainer.Size = p_u_44.RemainingBansStart.Size
        p_u_44.RemainingBansContainer:TweenSize(p_u_44.RemainingBansContainer.Size, "Out", "Linear", 0, true)
        task.spawn(function()
            local v66 = p_u_44._remaining_ban_icons_generate_hash
            wait(1)
            if p_u_44._remaining_ban_icons_generate_hash == v66 then
                if p_u_44.RemainingBansContainer:IsDescendantOf(v_u_4) then
                    p_u_44.RemainingBansContainer:TweenPosition(p_u_44.RemainingBansFinish.Position, "InOut", "Quint", 0.5, true)
                    p_u_44.RemainingBansContainer:TweenSize(p_u_44.RemainingBansFinish.Size, "InOut", "Quint", 0.5, true)
                else
                    p_u_44.RemainingBansContainer.Position = p_u_44.RemainingBansFinish.Position
                    p_u_44.RemainingBansContainer.Size = p_u_44.RemainingBansFinish.Size
                end
            else
                return
            end
        end)
        p_u_44:_SetWeaponClassSelected("Primary")
    end
    for v67, v68 in pairs(p_u_44._remaining_ban_icons) do
        local v69 = v49 - (v50[v67] or 0)
        for v70, v71 in pairs(v68) do
            v71.Visible = v70 <= v69
        end
    end
    if v47 == "Weapons" then
        local v72 = {}
        for _, v73 in pairs(v46) do
            local v74 = v73.IsBanned
            if v74 then
                local v75 = v_u_5:GetTeamColor(v74)
                local v76 = v_u_6.Items[v73.Name]
                v72[v76.Class] = (v72[v76.Class] or 0) + 1
                local v77 = v72[v76.Class]
                local v78 = v_u_14:Clone()
                v78.ImageColor3 = v_u_7:DarkenColor(v75, 0.5)
                v78.Icon.ImageColor3 = v_u_7:DarkenColor(v75, 1)
                v78.LayoutOrder = v77
                v78.ZIndex = -v77
                v78.Parent = p_u_44._weapon_tab_buttons[v76.Class].Bans
                local v79 = p_u_44._weapon_ban_icons
                table.insert(v79, v78)
                v78.Weapon.Icon.Image = v_u_6.ViewModels[v73.Name].ImageCentered or v76.Image
                v78.Weapon.ZIndex = 10
                v78.Weapon.Visible = true
            end
        end
    end
    if v51 then
        wait(1.25)
    end
end
function v_u_15._ClearWeapons(p80)
    for _, v81 in pairs(p80._weapon_slots) do
        v81:Destroy()
    end
    p80._weapon_slots = {}
    p80._weapon_slots_banned = {}
    p80.WeaponsFrame.Visible = false
end
function v_u_15._GenerateWeapons(p_u_82)
    p_u_82.WeaponsFrame.Visible = true
    local v83 = p_u_82._generate_hash
    p_u_82:_GenerateRemainingBans()
    if v83 == p_u_82._generate_hash then
        local v84 = p_u_82.DuelInterface.ClientDuel:Get("VoteOptions")
        local v85 = p_u_82.DuelInterface.ClientDuel:GetDueler(v_u_4.LocalPlayer)
        for v86, v87 in pairs(v84) do
            local v_u_88 = v87.Name
            if not p_u_82._weapon_slots[v_u_88] then
                local v89 = v_u_11.new(v_u_88)
                v89.Frame.LayoutOrder = v86
                v89.Frame.Parent = p_u_82.WeaponsListContainer
                if v85 then
                    v89.Frame.Button.MouseButton1Click:Connect(function()
                        v_u_1.Remotes.Duels.Vote:FireServer(v_u_88)
                    end)
                else
                    v89:DisableButton()
                end
                v89.PlayBanFrameSound:Connect(function(...)
                    p_u_82:_PlayBanSound(...)
                end)
                p_u_82._weapon_slots[v_u_88] = v89
                local v90 = Instance.new("UIScale")
                v90.Scale = 0.25
                v90.Parent = v89.Frame
                v_u_3:Create(v90, TweenInfo.new(math.sqrt(v86) * 0.1 + 0.1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                    ["Scale"] = 1
                }):Play()
            end
        end
        for _, v91 in pairs(v84) do
            local v92 = v91.Name
            local v93 = p_u_82._weapon_slots[v92]
            if v93 and (v91.IsBanned and not p_u_82._weapon_slots_banned[v92]) then
                p_u_82._weapon_slots_banned[v92] = true
                v93:ToggleBanned(0, v91.IsBanned)
            end
        end
        p_u_82:_UpdateWeapons()
    end
end
function v_u_15._ClearMaps(p94)
    for _, v95 in pairs(p94._map_slots) do
        v95:Destroy()
    end
    p94._map_slots = {}
    p94.MapsCenter.Visible = false
    p94.MapsList.Visible = false
end
function v_u_15._GenerateMaps(p_u_96)
    if p_u_96._map_chosen_slot then
        return
    else
        local v97 = p_u_96.DuelInterface.ClientDuel:Get("VoteSelectionMode")
        local v98 = p_u_96.DuelInterface.ClientDuel:Get("VoteOptions")
        local v99 = #v98 <= 6
        local v100 = v99 and p_u_96.MapsCenter or p_u_96.MapsListContainer
        p_u_96.MapsList.Visible = not v99
        p_u_96.MapsCenter.Visible = v99
        p_u_96.MapsCenterLayout.FillDirectionMaxCells = #v98 == 4 and 2 or 0
        local v101 = p_u_96._generate_hash
        p_u_96:_GenerateRemainingBans()
        if v101 == p_u_96._generate_hash then
            local v102 = p_u_96.DuelInterface.ClientDuel:GetDueler(v_u_4.LocalPlayer)
            local v103 = 0
            for v104, v_u_105 in pairs(v98) do
                v103 = v103 + v_u_105.Votes
                if not p_u_96._map_slots[v_u_105.Name] then
                    local v106 = v_u_12.new(v_u_105.Name, not v102)
                    v106.Frame.LayoutOrder = v104
                    v106:SetParent(v100)
                    p_u_96._map_slots[v_u_105.Name] = v106
                    v106.CreateSound:Connect(function(...)
                        p_u_96:_PlayBanSound(...)
                    end)
                    if v102 then
                        v106.Frame.Button.MouseButton1Click:Connect(function()
                            v_u_1.Remotes.Duels.Vote:FireServer(v_u_105.Name)
                        end)
                    end
                    local v107 = Instance.new("UIScale")
                    v107.Scale = 0.25
                    v107.Parent = v106.Frame
                    v_u_3:Create(v107, TweenInfo.new(math.sqrt(v104) * 0.1 + 0.1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                        ["Scale"] = 1
                    }):Play()
                end
            end
            local v108 = {}
            local v109 = {}
            local v110 = nil
            for _, v111 in pairs(p_u_96.DuelInterface.ClientDuel.Duelers) do
                local v112 = v111:Get("LastVote")
                if v112 then
                    v108[v112] = v108[v112] or {}
                    local v113 = v108[v112]
                    local v114 = v111.Player.UserId
                    table.insert(v113, v114)
                end
                if v111.Player ~= v_u_4.LocalPlayer then
                    v112 = v110
                end
                local v115 = v111.Player.UserId
                v109[tostring(v115)] = v111:Get("TeamID")
                v110 = v112
            end
            for _, v116 in pairs(v98) do
                local v117 = p_u_96._map_slots[v116.Name]
                if v117 then
                    if v116.IsBanned then
                        v117.VoteBanFrame:Play(v116.IsBanned, true)
                    else
                        v117:UpdateVotes(v116.Votes, v103, v108[v116.Name], v109, v116.Name == v110, v97)
                    end
                end
            end
        end
    end
end
function v_u_15._UpdateLists(p118)
    p118.MapsList.CanvasSize = UDim2.new(0, 0, 0, p118.MapsListLayout.AbsoluteContentSize.Y)
    p118.MapsList.ClipsDescendants = p118.MapsList.CanvasPosition.Y > 5
    p118.WeaponsList.CanvasSize = UDim2.new(0, 0, 0, p118.WeaponsListLayout.AbsoluteContentSize.Y)
    p118.WeaponsList.ClipsDescendants = p118.WeaponsList.CanvasPosition.Y > 5
    p118.WeaponsTabsFrame.Visible = p118.WeaponsListLayout.AbsoluteContentSize.Y > 0
    local v119 = p118.WeaponsMapFrame
    local v120 = p118._last_map_chosen_result
    if v120 then
        v120 = p118.WeaponsTabsFrame.Visible
    end
    v119.Visible = v120
end
function v_u_15._Setup(p_u_121)
    for v_u_122, v123 in pairs(v_u_6.Classes) do
        local v124 = v_u_13:Clone()
        v124.Title.Text = v_u_122
        v124.Title.Icon.Image = v123.ImageDiagonalLeft
        v124.LayoutOrder = v123.Slot
        v124.Parent = p_u_121.WeaponsTabsFrame
        p_u_121._weapon_tab_buttons[v_u_122] = v124
        v124.MouseButton1Click:Connect(function()
            p_u_121:_SetWeaponClassSelected(v_u_122)
        end)
        v_u_10:Add(v124)
        local v_u_125 = v124.Title
        local v_u_126 = v_u_125.Icon
        v_u_125:GetPropertyChangedSignal("TextBounds"):Connect(function()
            v_u_126.Position = UDim2.new(0.5, -v_u_125.TextBounds.X / 2, 0.5, 0)
        end)
        v_u_126.Position = UDim2.new(0.5, -v_u_125.TextBounds.X / 2, 0.5, 0)
    end
    local v127 = p_u_121.DuelInterface.ClientDuel:Get("ArcadeMode")
    p_u_121.MapsArcadeModeTitle.Text = v127 and ("Gamemode: " .. v_u_5.ArcadeModes[v127].DisplayName or "") or ""
    p_u_121.MapsArcadeModeFrame.Visible = v127
end
function v_u_15._Init(p_u_128)
    p_u_128.MapsListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        p_u_128:_UpdateLists()
    end)
    p_u_128.MapsList:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
        p_u_128:_UpdateLists()
    end)
    p_u_128.WeaponsListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        p_u_128:_UpdateLists()
    end)
    p_u_128.WeaponsList:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
        p_u_128:_UpdateLists()
    end)
    p_u_128:_Setup()
    p_u_128:_UpdateLists()
end
return v_u_15