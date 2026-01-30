local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("TweenService")
local v3 = game:GetService("Players")
local v_u_4 = require(v1.Modules.ContractsLibrary)
local v_u_5 = require(v1.Modules.DuelLibrary)
local v_u_6 = require(v1.Modules.Utility)
local v_u_7 = require(v3.LocalPlayer.PlayerScripts.Controllers.MatchmakingController)
local v_u_8 = require(v3.LocalPlayer.PlayerScripts.Controllers.PlayerDataController)
local v_u_9 = require(v3.LocalPlayer.PlayerScripts.Controllers.ArcadeController)
local v_u_10 = require(v3.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("Equipment"))
local v_u_11 = require(v3.LocalPlayer.PlayerScripts.Modules:WaitForChild("BaseContractSlot"):WaitForChild("ContractSlot"))
local v_u_12 = require(v3.LocalPlayer.PlayerScripts.Modules:WaitForChild("StatisticsList"))
local v_u_13 = require(v3.LocalPlayer.PlayerScripts.Modules:WaitForChild("LockedMapSlot"))
local v_u_14 = require(v3.LocalPlayer.PlayerScripts.Modules:WaitForChild("PromptSystem"))
local v_u_15 = require(v3.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect"))
local v_u_16 = require(v3.LocalPlayer.PlayerScripts.Modules:WaitForChild("MapSlot"))
local v_u_17 = require(v3.LocalPlayer.PlayerScripts.Modules:WaitForChild("Page"))
local v_u_18 = v3.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("ContractDivider")
v3.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("LockedMapSlot")
local v_u_19 = v3.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("PlaySourceLabel")
local v_u_20 = v3.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("EmptySlot")
local v_u_21 = setmetatable({}, v_u_17)
v_u_21.__index = v_u_21
function v_u_21._new()
    local v22 = v_u_17.new(script.Name)
    local v23 = v_u_21
    local v24 = setmetatable(v22, v23)
    v24.CloseButton = v24.PageFrame:WaitForChild("Close")
    v24.CloseButtonIcon = v24.CloseButton:WaitForChild("Icon")
    v24.PromptsFrame = v24.PageFrame:WaitForChild("Prompts")
    v24.List = v24.PageFrame:WaitForChild("List")
    v24.Container = v24.List:WaitForChild("Container")
    v24.Layout = v24.Container:WaitForChild("Layout")
    v24.SlotsFrame = v24.Container:WaitForChild("Slots")
    v24.SlotsContainer = v24.SlotsFrame:WaitForChild("Container")
    v24.SlotsLayout = v24.SlotsContainer:WaitForChild("Layout")
    v24.InspectList = v24.PageFrame:WaitForChild("Inspect")
    v24.InspectContainer = v24.InspectList:WaitForChild("Container")
    v24.InspectLayout = v24.InspectContainer:WaitForChild("Layout")
    v24.InspectDetailsFrame = v24.InspectContainer:WaitForChild("Details")
    v24.InspectDetailsFrameUIScale = v24.InspectDetailsFrame:WaitForChild("UIScale")
    v24.InspectDetailsContainer = v24.InspectDetailsFrame:WaitForChild("Container")
    v24.InspectDetailsLayout = v24.InspectDetailsContainer:WaitForChild("Layout")
    v24.InspectDetailsThumbnail = v24.InspectDetailsContainer:WaitForChild("Thumbnail")
    v24.InspectDetailsTextLabelsFrame = v24.InspectDetailsContainer:WaitForChild("TextLabels")
    v24.InspectDetailsTextLabelsContainer = v24.InspectDetailsTextLabelsFrame:WaitForChild("Container")
    v24.InspectDetailsTextLabelsLayout = v24.InspectDetailsTextLabelsContainer:WaitForChild("Layout")
    v24.InspectDetailsTitle = v24.InspectDetailsTextLabelsContainer:WaitForChild("Title")
    v24.InspectDetailsDescription = v24.InspectDetailsTextLabelsContainer:WaitForChild("Description")
    v24.InspectDetailsCreator = v24.InspectDetailsTextLabelsContainer:WaitForChild("Creator")
    v24.InspectQueuesFrame = v24.InspectContainer:WaitForChild("Queues")
    v24.InspectQueuesFrameUIScale = v24.InspectQueuesFrame:WaitForChild("UIScale")
    v24.InspectQueuesContainer = v24.InspectQueuesFrame:WaitForChild("Container")
    v24.InspectQueuesLabelsFrame = v24.InspectQueuesContainer:WaitForChild("Labels")
    v24.InspectQueuesLabelsLayout = v24.InspectQueuesLabelsFrame:WaitForChild("Layout")
    v24.InspectStatisticsFrame = v24.InspectContainer:WaitForChild("Statistics")
    v24.InspectStatisticsFrameUIScale = v24.InspectStatisticsFrame:WaitForChild("UIScale")
    v24.InspectStatisticsContainer = v24.InspectStatisticsFrame:WaitForChild("Container")
    v24.InspectStatisticsLayout = v24.InspectStatisticsContainer:WaitForChild("Layout")
    v24.InspectStatisticsTextLabelsFrame = v24.InspectStatisticsContainer:WaitForChild("TextLabels")
    v24.InspectStatisticsTextLabelsContainer = v24.InspectStatisticsTextLabelsFrame:WaitForChild("Container")
    v24.InspectStatisticsTextLabelsLayout = v24.InspectStatisticsTextLabelsContainer:WaitForChild("Layout")
    v24.PromptSystem = v_u_14.new(v24.PromptsFrame)
    v24.StatisticsList = v_u_12.new(v24.InspectStatisticsTextLabelsContainer, 1, true)
    v24._map_slots = {}
    v24._locked_map_slots = {}
    v24._empty_map_slots = {}
    v24._map_slot_ui_scales = {}
    v24._map_slot_tweens = {}
    v24._inspected_map_name = nil
    v24._inspected_map_info = nil
    v24._inspected_map_locked_slot = nil
    v24._inspected_queue_labels = {}
    v24._inspected_map_contract_slots = {}
    v24._inspect_tweens = {}
    v24:_Init()
    return v24
end
function v_u_21.CloseRequest(p25)
    if p25._inspected_map_name then
        p25:Inspect(nil)
    else
        v_u_17.CloseRequest(p25)
    end
end
function v_u_21.Inspect(p_u_26, p27)
    for _, v28 in pairs(p_u_26._inspect_tweens) do
        v28:Cancel()
    end
    for _, v29 in pairs(p_u_26._inspected_queue_labels) do
        v29:Destroy()
    end
    for _, v30 in pairs(p_u_26._inspected_map_contract_slots) do
        v30:Destroy()
    end
    p_u_26._inspected_map_contract_slots = {}
    p_u_26._inspect_tweens = {}
    p_u_26._inspected_queue_labels = {}
    if p_u_26._inspected_map_locked_slot then
        p_u_26._inspected_map_locked_slot:Destroy()
        p_u_26._inspected_map_locked_slot = nil
    end
    p_u_26._inspected_map_name = p27
    p_u_26._inspected_map_info = v_u_5.Maps[p_u_26._inspected_map_name]
    p_u_26.List.Visible = not p_u_26._inspected_map_name
    p_u_26.InspectList.Visible = p_u_26._inspected_map_name
    p_u_26.CloseButtonIcon.Image = p_u_26._inspected_map_name and "rbxassetid://17562685319" or "rbxassetid://17838290166"
    if p_u_26._inspected_map_name then
        local v31 = p_u_26:_IsMapUnlocked(p_u_26._inspected_map_name)
        p_u_26.InspectDetailsTitle.Text = v31 and (p_u_26._inspected_map_name or "Discover this map in a duel to learn more!") or "Discover this map in a duel to learn more!"
        p_u_26.InspectDetailsTitle.TextTransparency = v31 and 0 or 0.5
        p_u_26.InspectDetailsTitle.FontFace = v31 and Font.fromId(12187365977, Enum.FontWeight.Bold, Enum.FontStyle.Normal) or Font.fromId(12187365977, Enum.FontWeight.Medium, Enum.FontStyle.Italic)
        p_u_26.InspectDetailsTitle.Size = v31 and UDim2.new(0.95, 0, 0.066, 0) or UDim2.new(0.95, 0, 0.035, 0)
        p_u_26.InspectDetailsThumbnail.Image = v31 and (p_u_26._inspected_map_info.Image or "") or ""
        p_u_26.InspectDetailsDescription.Text = not v31 and "" or (not p_u_26._inspected_map_info.Description and "" or "\226\128\162 " .. p_u_26._inspected_map_info.Description)
        local v32 = p_u_26.InspectDetailsCreator
        local v33
        if v31 then
            if #p_u_26._inspected_map_info.Contributors > 0 then
                v33 = string.format("\226\128\162 Created by %s with contributions from %s", p_u_26:_GetUsernamesString(p_u_26._inspected_map_info.Creators), p_u_26:_GetUsernamesString(p_u_26._inspected_map_info.Contributors))
            else
                v33 = #p_u_26._inspected_map_info.Creators <= 0 and "" or string.format("\226\128\162 Created by %s", p_u_26:_GetUsernamesString(p_u_26._inspected_map_info.Creators))
            end
        else
            v33 = ""
        end
        v32.Text = v33
        p_u_26.InspectDetailsDescription.Visible = p_u_26.InspectDetailsDescription.Text ~= ""
        p_u_26.InspectDetailsCreator.Visible = p_u_26.InspectDetailsCreator.Text ~= ""
        if not v31 then
            p_u_26._inspected_map_locked_slot = v_u_13.new(p_u_26._inspected_map_name, true)
            p_u_26._inspected_map_locked_slot.Frame.Size = UDim2.new(1, 0, 1, 0)
            p_u_26._inspected_map_locked_slot.Frame.SizeConstraint = Enum.SizeConstraint.RelativeXY
            p_u_26._inspected_map_locked_slot.Frame.Position = UDim2.new(0.5, 0, 0.5, 0)
            p_u_26._inspected_map_locked_slot.Frame.AnchorPoint = Vector2.new(0.5, 0.5)
            p_u_26._inspected_map_locked_slot.Frame.Button.Difficulty.UIStroke.Enabled = false
            p_u_26._inspected_map_locked_slot:SetParent(p_u_26.InspectDetailsThumbnail)
        end
        local function v48(p34, p_u_35, p36, p37)
            local v_u_38 = v_u_5.PlaySources[p_u_35]
            local v_u_39 = p36 or (v_u_38 and v_u_38.AssignedColor or Color3.fromRGB(0, 0, 0))
            local v_u_40 = p37 or v_u_39:Lerp(Color3.fromRGB(0, 0, 0), 0.5)
            local v_u_41 = v_u_19:Clone()
            v_u_41.LayoutOrder = p34
            local v42 = v_u_41.Container.Title
            local v43
            if v_u_38 then
                v43 = v_u_38.DisplayName or p_u_35
            else
                v43 = p_u_35
            end
            v42.Text = v43
            v_u_41.Play.ImageColor3 = v_u_39
            v_u_41.Parent = p_u_26.InspectQueuesLabelsFrame
            local v44 = p_u_26._inspected_queue_labels
            table.insert(v44, v_u_41)
            v_u_41.Container.Title:GetPropertyChangedSignal("TextBounds"):Connect(function()
                v_u_41.Size = UDim2.new(0.05, v_u_41.Container.Title.TextBounds.X, 0.05, 0)
            end)
            v_u_41.Size = UDim2.new(0.05, v_u_41.Container.Title.TextBounds.X, 0.05, 0)
            local function v45()
                v_u_41.Play.Visible = true
                v_u_41.Container.Title.Visible = false
                v_u_41.Container.Title.TextColor3 = v_u_39
                v_u_41.Background.ImageColor3 = v_u_40
            end
            local function v46()
                v_u_41.Play.Visible = false
                v_u_41.Container.Title.Visible = true
                v_u_41.Container.Title.TextColor3 = v_u_40
                v_u_41.Background.ImageColor3 = v_u_39
            end
            v_u_41.Play.Visible = false
            v_u_41.Container.Title.Visible = true
            v_u_41.Container.Title.TextColor3 = v_u_40
            v_u_41.Background.ImageColor3 = v_u_39
            if v_u_38 then
                v_u_41.MouseButton1Click:Connect(function()
                    local v47
                    if v_u_38.Type == "MatchmakingQueue" then
                        v47 = v_u_7:QueueInto(p_u_35)
                    elseif v_u_38.Type == "ArcadeMode" then
                        v47 = v_u_9:ToArcadeServer(p_u_35)
                    else
                        v47 = assert(false, "???")
                    end
                    if v47 == "Success" then
                        p_u_26.Closed:Fire()
                        v_u_10:Close()
                    else
                        p_u_26.PromptSystem:Open("ErrorMessage", "Woops!", v47 or "Server failed to respond, please try again")
                    end
                end)
                v_u_41.MouseEnter:Connect(v45)
                v_u_41.SelectionGained:Connect(v45)
                v_u_41.MouseLeave:Connect(v46)
                v_u_41.SelectionLost:Connect(v46)
            end
        end
        if p_u_26._inspected_map_info.IsHidden then
            v48(1, "N/A", Color3.fromRGB(0, 0, 0), Color3.fromRGB(255, 255, 255))
        elseif #p_u_26._inspected_map_info.PlaySources == 0 then
            v48(1, "Private Servers Only", Color3.fromRGB(0, 0, 0), Color3.fromRGB(255, 255, 255))
        else
            for v49, v50 in pairs(p_u_26._inspected_map_info.PlaySources) do
                v48(v49, v50)
            end
        end
        p_u_26.InspectStatisticsFrame.Visible = v_u_8:GetMapStatistic(p27, "StatisticPlaytime") > 0
        p_u_26.StatisticsList:Generate(false, "MapStatistics", p27)
        if v31 then
            local v51 = 50
            for v52, v53 in pairs(v_u_4:GetMapContracts(p_u_26._inspected_map_name)) do
                if v52 > 1 then
                    local v54 = v_u_18:Clone()
                    v54.LayoutOrder = v51
                    v54.Parent = p_u_26.InspectContainer
                    local v55 = p_u_26._inspected_map_contract_slots
                    table.insert(v55, v54)
                    v51 = v51 + 1
                end
                local v56 = v_u_11.new("MapStatistics", v53)
                v56.Frame.LayoutOrder = v51
                v56.Frame.Parent = p_u_26.InspectContainer
                local v57 = p_u_26._inspected_map_contract_slots
                table.insert(v57, v56)
                v51 = v51 + 1
            end
        end
        p_u_26.InspectDetailsFrameUIScale.Scale = 0.5
        p_u_26.InspectQueuesFrameUIScale.Scale = 0.5
        p_u_26.InspectStatisticsFrameUIScale.Scale = 0.5
        local v58 = v_u_2:Create(p_u_26.InspectDetailsFrameUIScale, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            ["Scale"] = 1
        })
        v58:Play()
        local v59 = p_u_26._inspect_tweens
        table.insert(v59, v58)
        local v60 = v_u_2:Create(p_u_26.InspectQueuesFrameUIScale, TweenInfo.new(0.375, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            ["Scale"] = 1
        })
        v60:Play()
        local v61 = p_u_26._inspect_tweens
        table.insert(v61, v60)
        local v62 = v_u_2:Create(p_u_26.InspectStatisticsFrameUIScale, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            ["Scale"] = 1
        })
        v62:Play()
        local v63 = p_u_26._inspect_tweens
        table.insert(v63, v62)
    else
        p_u_26:_PlayMapSlotsTween()
    end
end
function v_u_21.Open(p64, ...)
    v_u_17.Open(p64, ...)
    p64:Inspect(nil)
    p64:_UpdateMapSlots()
    p64:_PlayMapSlotsTween()
end
function v_u_21._IsMapUnlocked(_, p65)
    return v_u_5.Maps[p65] and #v_u_5.Maps[p65].PlaySources == 0 and true or v_u_8:GetMapStatistic(p65, "StatisticPlaytime") > 0
end
function v_u_21._PlayMapSlotsTween(p_u_66)
    for _, v67 in pairs(p_u_66._map_slot_tweens) do
        v67:Cancel()
    end
    p_u_66._map_slot_tweens = {}
    local function v72(p68, p69)
        p69.Scale = 0.25
        local v70 = v_u_2:Create(p69, TweenInfo.new(math.sqrt(p68) * 0.1 + 0.1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            ["Scale"] = 1
        })
        v70:Play()
        local v71 = p_u_66._map_slot_tweens
        table.insert(v71, v70)
    end
    for v73, v74 in pairs(p_u_66._map_slots) do
        v72(v73, v74[2].Frame.UIScale)
    end
    for v75, v76 in pairs(p_u_66._locked_map_slots) do
        v72(v75, v76[2].Frame.UIScale)
    end
    for v77, v78 in pairs(p_u_66._empty_map_slots) do
        v72(#p_u_66._map_slots + v77, v78.UIScale)
    end
end
function v_u_21._GetUsernamesString(_, p79)
    local v80 = ""
    for v81, v82 in pairs(p79) do
        v80 = (v80 .. (v81 == 1 and "" or (v81 == #p79 and ", & " or ", "))) .. "@" .. v82
    end
    return v80
end
function v_u_21._UpdateMapSlots(p83)
    if p83:IsOpen() then
        for _, v84 in pairs(p83._map_slots) do
            v84[2].Frame.Visible = p83:_IsMapUnlocked(v84[1])
        end
        for _, v85 in pairs(p83._locked_map_slots) do
            v85[2].Frame.Visible = not p83:_IsMapUnlocked(v85[1])
        end
    end
end
function v_u_21._Setup(p_u_86)
    local v87 = v_u_6:CloneTable(v_u_5.MapOrder)
    table.sort(v87, function(p88, p89)
        return v_u_5:SortMaps(p88, p89)
    end)
    local function v94(p90, p_u_91)
        local v92 = v_u_16.new(p_u_91)
        v92.Frame.LayoutOrder = p90
        v92:SetParent(p_u_86.SlotsContainer)
        local v93 = p_u_86._map_slots
        table.insert(v93, { p_u_91, v92 })
        v92.Frame.Button.MouseButton1Click:Connect(function()
            p_u_86:Inspect(p_u_91)
        end)
        Instance.new("UIScale").Parent = v92.Frame
    end
    local function v99(p95, p_u_96)
        local _ = v_u_5.Maps[p_u_96]
        local v97 = v_u_13.new(p_u_96)
        v97.Frame.LayoutOrder = p95
        v97:SetParent(p_u_86.SlotsContainer)
        local v98 = p_u_86._locked_map_slots
        table.insert(v98, { p_u_96, v97 })
        v97.Frame.Button.MouseButton1Click:Connect(function()
            p_u_86:Inspect(p_u_96)
        end)
        Instance.new("UIScale").Parent = v97.Frame
    end
    for v100, v101 in pairs(v87) do
        v94(v100, v101)
        v99(v100, v101)
    end
    local v102 = 9 - #v87
    for _ = 1, math.max(0, v102) + (3 - (#v87 <= 9 and 0 or (#v87 - 1) % 3 + 1)) do
        local v103 = v_u_20:Clone()
        v103.LayoutOrder = 9999999
        v103.Parent = p_u_86.SlotsContainer
        local v104 = p_u_86._empty_map_slots
        table.insert(v104, v103)
        Instance.new("UIScale").Parent = v103
    end
end
function v_u_21._Init(p_u_105)
    p_u_105.CloseButton.MouseButton1Click:Connect(function()
        p_u_105:CloseRequest()
    end)
    p_u_105.Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        p_u_105.List.CanvasSize = UDim2.new(0, 0, 0, p_u_105.Layout.AbsoluteContentSize.Y)
        p_u_105.List.Active = p_u_105.Layout.AbsoluteContentSize.Y >= p_u_105.List.AbsoluteSize.Y
    end)
    p_u_105.SlotsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        p_u_105.SlotsFrame.Size = UDim2.new(1, 0, 0, p_u_105.SlotsLayout.AbsoluteContentSize.Y)
    end)
    p_u_105.InspectLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        p_u_105.InspectList.CanvasSize = UDim2.new(0, 0, 0, p_u_105.InspectLayout.AbsoluteContentSize.Y)
        p_u_105.InspectList.Active = p_u_105.InspectLayout.AbsoluteContentSize.Y >= p_u_105.InspectList.AbsoluteSize.Y
    end)
    p_u_105.InspectDetailsTextLabelsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        p_u_105.InspectDetailsTextLabelsFrame.Size = UDim2.new(1, 0, 0, p_u_105.InspectDetailsTextLabelsLayout.AbsoluteContentSize.Y)
    end)
    p_u_105.InspectDetailsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        p_u_105.InspectDetailsFrame.Size = UDim2.new(1, 0, 0, p_u_105.InspectDetailsLayout.AbsoluteContentSize.Y)
    end)
    p_u_105.InspectQueuesLabelsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        p_u_105.InspectQueuesFrame.Size = UDim2.new(1, 0, 0.088, p_u_105.InspectQueuesLabelsLayout.AbsoluteContentSize.Y)
    end)
    p_u_105.InspectStatisticsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        p_u_105.InspectStatisticsFrame.Size = UDim2.new(1, 0, 0, p_u_105.InspectStatisticsLayout.AbsoluteContentSize.Y)
    end)
    p_u_105.InspectStatisticsTextLabelsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        p_u_105.InspectStatisticsTextLabelsFrame.Size = UDim2.new(1, 0, 0, p_u_105.InspectStatisticsTextLabelsLayout.AbsoluteContentSize.Y)
    end)
    v_u_8.StatisticsUpdated:Connect(function()
        p_u_105:_UpdateMapSlots()
    end)
    p_u_105:_Setup()
    p_u_105:_UpdateMapSlots()
    p_u_105:Inspect(nil)
    v_u_15:Add(p_u_105.CloseButton)
end
return v_u_21._new()