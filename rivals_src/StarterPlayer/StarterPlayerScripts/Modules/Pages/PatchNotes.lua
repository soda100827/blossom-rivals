local v_u_1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("TweenService")
local v_u_3 = game:GetService("RunService")
local v4 = game:GetService("Players")
local v_u_5 = require(v_u_1.Modules.CONSTANTS)
require(v_u_1.Modules.CosmeticLibrary)
local v_u_6 = require(v_u_1.Modules.BetterDebris)
local v_u_7 = require(v_u_1.Modules.ItemLibrary)
local v_u_8 = require(v_u_1.Modules.Utility)
local v_u_9 = require(v_u_1.Modules.Signal)
local v_u_10 = require(v4.LocalPlayer.PlayerScripts.Controllers:WaitForChild("PlayerDataController"))
local v_u_11 = require(v4.LocalPlayer.PlayerScripts.Modules:WaitForChild("WeaponStatusHandler"))
local v_u_12 = require(v4.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect"))
local v_u_13 = require(v4.LocalPlayer.PlayerScripts.Modules:WaitForChild("RewardSlot"))
local v_u_14 = require(v4.LocalPlayer.PlayerScripts.Modules:WaitForChild("UILibrary"))
local v_u_15 = require(v4.LocalPlayer.PlayerScripts.Modules:WaitForChild("Page"))
local v_u_16 = v4.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("PatchNoteBalancingOverviewSlot")
local v_u_17 = v4.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("PatchNoteContentSummarySlot")
local v_u_18 = v4.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("PatchNoteBalanceChangeSlot")
local v_u_19 = v4.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("PatchNoteViewMoreButton")
local v_u_20 = v4.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("PatchNoteThumbnailSlot")
local v_u_21 = v4.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("PatchNoteChangeSlot")
local v_u_22 = v4.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("PatchNotesSlot")
local v_u_23 = v4.LocalPlayer.PlayerScripts.Modules:WaitForChild("PatchNotes")
local v_u_24 = {
    "Release",
    "FreezeRay",
    "Matchmaking",
    "Cosmetics",
    "NewMaps",
    "Gamemodes",
    "2024SpookyEvent",
    "Weapons",
    "2024FestiveEvent",
    "BridgeMap",
    "Ranked",
    "TheHunt",
    "Cosmetics2",
    "Gamemodes2",
    "Emotes",
    "Season1",
    "2025SpookyEvent",
    "2025FestiveEvent"
}
local v_u_25 = {
    { Color3.fromRGB(100, 255, 50), "rbxassetid://72868042131575" },
    { Color3.fromRGB(255, 50, 50), "rbxassetid://129990470163489" },
    { Color3.fromRGB(166, 166, 166), "rbxassetid://125168324521437" }
}
local v_u_26 = {
    ["Title"] = {
        ["Weight"] = 600,
        ["Transparency"] = 0,
        ["Size"] = 1.5,
        ["Spaces"] = 3,
        ["Prefix"] = "",
        ["NewLine"] = 2
    },
    ["Header"] = {
        ["Weight"] = 500,
        ["Transparency"] = 0.25,
        ["Size"] = 0.875,
        ["Spaces"] = 9,
        ["Prefix"] = "",
        ["NewLine"] = 0.5
    },
    ["Description"] = {
        ["Weight"] = 400,
        ["Transparency"] = 0.25,
        ["Size"] = 0.75,
        ["Spaces"] = 12,
        ["Prefix"] = "\226\128\162 ",
        ["NewLine"] = nil
    },
    ["Description2"] = {
        ["Weight"] = 400,
        ["Transparency"] = 0.25,
        ["Size"] = 0.75,
        ["Spaces"] = 18,
        ["Prefix"] = "\226\150\170  ",
        ["NewLine"] = nil
    }
}
local v_u_27 = setmetatable({}, v_u_15)
v_u_27.__index = v_u_27
function v_u_27._new()
    local v28 = v_u_15.new(script.Name)
    local v29 = v_u_27
    local v30 = setmetatable(v28, v29)
    v30.PageContainer = v30.PageFrame:WaitForChild("Container")
    v30.CloseButton = v30.PageContainer:WaitForChild("Close")
    v30.List = v30.PageContainer:WaitForChild("List")
    v30.Container = v30.List:WaitForChild("Container")
    v30.Layout = v30.Container:WaitForChild("Layout")
    v30.ViewMoreButton = v30.Container:WaitForChild("ViewMore")
    v30._num_patch_notes_generated = 0
    v30._is_generating = false
    v30._elements = {}
    v30:_Init()
    return v30
end
function v_u_27.ScrollTo(p31, p32, p33)
    if p32 then
        v_u_2:Create(p31.List, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            ["CanvasPosition"] = Vector2.new(0, p32.AbsolutePosition.Y - p31.Container.AbsolutePosition.Y)
        }):Play()
        local v_u_34 = Instance.new("Frame")
        v_u_34.BackgroundColor3 = p33 or Color3.fromRGB(255, 255, 255)
        v_u_34.AnchorPoint = Vector2.new(0.5, 0.5)
        v_u_34.Position = UDim2.new(0.5, 0, 0.5, 0)
        v_u_34.Size = UDim2.new(1, 0, 20, 0)
        v_u_34.Parent = p32
        v_u_34:TweenSize(UDim2.new(1, 0, 1, 0), "Out", "Quint", 0.5, true)
        v_u_6:AddItem(v_u_34, 3)
        local v35 = Instance.new("UIGradient")
        v35.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.125, 0),
            NumberSequenceKeypoint.new(0.875, 0),
            NumberSequenceKeypoint.new(1, 1)
        })
        v35.Parent = v_u_34
        task.spawn(v_u_8.RenderstepForLoop, v_u_8, 0, 100, 1, function(p36)
            v_u_34.BackgroundTransparency = 0 + 1 * (p36 / 100) ^ 4
        end)
    end
end
function v_u_27.Open(p_u_37, ...)
    v_u_15.Open(p_u_37, ...)
    p_u_37:_UpdateSize()
    local v_u_38 = p_u_37._is_open_hash
    task.delay(0.5, function()
        for _, v39 in pairs(p_u_37._elements) do
            if v_u_38 ~= p_u_37._is_open_hash then
                return
            end
            v39[1].Parent = v39[2]
            v_u_3.RenderStepped:Wait()
        end
    end)
end
function v_u_27.Close(p40, ...)
    for _, v41 in pairs(p40._elements) do
        v41[1].Parent = nil
    end
    v_u_15.Close(p40, ...)
end
function v_u_27._GenerateNext(p_u_42)
    if p_u_42._num_patch_notes_generated < #v_u_24 then
        p_u_42._is_generating = true
        p_u_42._num_patch_notes_generated = p_u_42._num_patch_notes_generated + 1
        p_u_42.ViewMoreButton.Visible = false
        local v_u_43 = require(v_u_23:WaitForChild(v_u_24[#v_u_24 - p_u_42._num_patch_notes_generated + 1]))
        local v_u_44 = v_u_22:Clone()
        v_u_44.LayoutOrder = p_u_42._num_patch_notes_generated
        v_u_44.Container.Thumbnail.Image = v_u_43.Image or ""
        v_u_44.Container.Thumbnail.Visible = v_u_44.Container.Thumbnail.Image ~= ""
        v_u_44.Container.Details.Title.Text = v_u_43.Title
        v_u_44.Container.Details.Changes.Date.Text = v_u_43.Date
        v_u_44.Parent = p_u_42.Container
        v_u_44.Container.Details.Changes.CodeButton.Button.MouseButton1Click:Connect(function()
            v_u_44.Container.Details.Changes.CodeButton.Visible = false
            v_u_1.Remotes.Data.RedeemCode:InvokeServer(string.lower(v_u_43.Code))
        end)
        v_u_44.Container.Details.Changes.Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            v_u_44.Size = UDim2.new(1, 0, 0, v_u_44.Container.Details.Changes.AbsolutePosition.Y - v_u_44.AbsolutePosition.Y + v_u_44.Container.Details.Changes.Layout.AbsoluteContentSize.Y)
        end)
        v_u_12:Add(v_u_44.Container.Details.Changes.CodeButton.Button)
        if v_u_43.Code then
            task.delay(20, function()
                v_u_44.Container.Details.Changes.CodeButton.Visible = not v_u_10:Get("RedeemedCodes")[string.lower(v_u_43.Code)]
            end)
        end
        local v_u_45 = v_u_9.new()
        local v_u_46 = true
        local v_u_47 = nil
        local v_u_48 = 0
        local v_u_49 = {}
        local v_u_50 = false
        local v_u_51 = {}
        local v_u_52 = 0
        local function v_u_63(p53, p54, p55)
            if v_u_49 then
                p53.Visible = false
                local v56 = v_u_49
                table.insert(v56, p53)
                if p54 then
                    p54.Visible = false
                    local v57 = v_u_49
                    table.insert(v57, p54)
                    return
                end
            else
                if v_u_48 == 10 then
                    local v_u_58 = Instance.new("UIGradient")
                    v_u_58.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.5), NumberSequenceKeypoint.new(1, 1) })
                    v_u_58.Rotation = 90
                    v_u_58.Parent = p53
                    local v_u_59 = {}
                    v_u_49 = v_u_59
                    local v_u_60 = v_u_19:Clone()
                    v_u_60.Parent = p53
                    local function v62()
                        if not v_u_46 then
                            for _, v61 in pairs(v_u_59) do
                                v61.Visible = true
                            end
                            v_u_58:Destroy()
                            v_u_60:Destroy()
                        end
                    end
                    v_u_60.MouseButton1Click:Connect(v62)
                    v_u_45:Connect(v62)
                    v_u_12:Add(v_u_60)
                    v_u_3.RenderStepped:Wait()
                    return
                end
                v_u_48 = v_u_48 + (p55 or 1)
            end
        end
        local function v75(p64)
            v_u_50 = true
            local v_u_65 = v_u_16:Clone()
            v_u_52 = v_u_52 + 1
            v_u_65.LayoutOrder = v_u_52
            for v66 = 1, 3 do
                local v_u_67 = v_u_25[v66]
                local v68 = p64[v66 + 1] or {}
                for _, v_u_69 in pairs(v68) do
                    local v70 = v_u_7.ViewModels[v_u_69]
                    assert(v70, v_u_69)
                    local v71 = v_u_18:Clone()
                    v71.Button.Label.Icon.Image = v_u_67[2]
                    v71.Button.Label.Icon.ImageColor3 = v_u_67[1]
                    v71.Button.Background.BackgroundColor3 = v_u_67[1]
                    v71.Button.Background.UIStroke.Color = v_u_67[1]
                    v71.Button.Graphic.Picture.Image = v_u_7.ViewModels[v_u_69].ImageCentered or v_u_7.Items[v_u_69].Image
                    v71.Parent = v_u_65.Slots
                    v71.Button.MouseButton1Click:Connect(function()
                        v_u_45:Fire()
                        task.defer(p_u_42.ScrollTo, p_u_42, v_u_51[v_u_69], v_u_67[1])
                    end)
                    v_u_12:Add(v71.Button)
                end
            end
            v_u_65.Parent = p_u_42._is_open and v_u_44.Container.Details.Changes or nil
            local v72 = p_u_42._elements
            local v73 = { v_u_65, v_u_44.Container.Details.Changes }
            table.insert(v72, v73)
            local v_u_74 = v_u_65.Slots.Layout
            v_u_74:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                v_u_65.Size = UDim2.new(1, 0, 0, v_u_74.AbsoluteContentSize.Y)
            end)
            v_u_65.Size = UDim2.new(1, 0, 0, v_u_74.AbsoluteContentSize.Y)
        end
        local function v87(p76)
            local v77 = p76[3]
            local v78 = #v77 / 7
            for v79 = 1, math.ceil(v78) do
                local v_u_80 = v_u_17:Clone()
                v_u_52 = v_u_52 + 1
                v_u_80.LayoutOrder = v_u_52
                v_u_80.Slots.Layout.HorizontalAlignment = Enum.HorizontalAlignment[p76[2] or "Center"]
                for v81 = 1 + (v79 - 1) * 7, v79 * 7 do
                    local v82 = v77[v81]
                    if v82 then
                        local v83 = v_u_13.new({
                            ["Name"] = v82,
                            ["Weapon"] = nil
                        })
                        v83.Frame.LayoutOrder = v81
                        v83:SetParent(v_u_80.Slots)
                        if v_u_50 and v_u_7.Items[v82] then
                            v_u_51[v82] = v_u_80
                        end
                    end
                end
                v_u_63(v_u_80, nil, 3)
                v_u_80.Parent = p_u_42._is_open and v_u_44.Container.Details.Changes or nil
                local v84 = p_u_42._elements
                local v85 = { v_u_80, v_u_44.Container.Details.Changes }
                table.insert(v84, v85)
                local v_u_86 = v_u_80.Slots.Layout
                v_u_86:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                    v_u_80.Size = UDim2.new(1, 0, 0, v_u_86.AbsoluteContentSize.Y)
                end)
                v_u_80.Size = UDim2.new(1, 0, 0, v_u_86.AbsoluteContentSize.Y)
            end
        end
        local function v103(p88)
            local v89 = p88[1]
            local v90 = p88[2]
            local v91 = v_u_26[v89]
            local v92 = v91 ~= nil
            assert(v92, v89, p88)
            if v89 == "Title" then
                v_u_47 = p88
                v_u_48 = 0
                v_u_49 = nil
            end
            local v93
            if v91.NewLine then
                v93 = v_u_21:Clone()
                v_u_52 = v_u_52 + 1
                v93.LayoutOrder = v_u_52
                v93.Text = ""
                v93.Size = UDim2.new(v93.Size.X.Scale, 0, v93.Size.Y.Scale * v91.NewLine, 0)
                v93.AutoLocalize = false
                v93.Parent = p_u_42._is_open and v_u_44.Container.Details.Changes or nil
                local v94 = p_u_42._elements
                local v95 = { v93, v_u_44.Container.Details.Changes }
                table.insert(v94, v95)
            else
                v93 = nil
            end
            local v96 = v_u_21:Clone()
            v_u_52 = v_u_52 + 1
            v96.LayoutOrder = v_u_52
            v96.Text = string.format("%s%s<font weight=\"%s\">%s</font>", string.rep(" ", v91.Spaces), v91.Prefix, v91.Weight, v90)
            v96.TextTransparency = v91.Transparency
            local v97 = UDim2.new
            local v98 = v96.Size.X.Scale
            local v99 = v96.Size.Y.Scale
            local v100 = #v90 / 80
            v96.Size = v97(v98, 0, v99 * math.ceil(v100) * v91.Size, 0)
            v96.AutoLocalize = false
            v96.Parent = p_u_42._is_open and v_u_44.Container.Details.Changes or nil
            local v101 = p_u_42._elements
            local v102 = { v96, v_u_44.Container.Details.Changes }
            table.insert(v101, v102)
            if v_u_50 and (v89 == "Header" and v_u_7.Items[v90]) then
                v_u_11:ApplyItemStatusToText(v96, v_u_7.Items[v90].Status)
                v_u_51[v90] = v96
            end
            v_u_63(v96, v93)
        end
        local v104 = v_u_52
        for _, v105 in pairs(v_u_43.Changes) do
            local v106 = v105[1]
            if typeof(v106) == "function" then
                for _, v107 in pairs(v105[1](select(2, table.unpack(v105)))) do
                    local v108 = v107[1]
                    if v108 == "Thumbnail" then
                        local v109 = v107[2]
                        local v110 = v107[3]
                        local v111 = v_u_20:Clone()
                        v_u_52 = v104 + 1
                        v111.LayoutOrder = v_u_52
                        v111.Thumbnail.Image = v109
                        v111.Title.Text = v110
                        v111.Title.AutoLocalize = false
                        v_u_63(v111)
                        local v112
                        if p_u_42._is_open then
                            v112 = v_u_44.Container.Details.Changes or nil
                        else
                            v112 = nil
                        end
                        v111.Parent = v112
                        local v113 = p_u_42._elements
                        local v114 = { v111, v_u_44.Container.Details.Changes }
                        table.insert(v113, v114)
                        v104 = v_u_52
                    elseif v108 == "BalancingOverview" then
                        v75(v107)
                    elseif v108 == "ContentSummary" then
                        v87(v107)
                    else
                        v103(v107)
                    end
                end
            else
                local v115 = v105[1]
                if v115 == "Thumbnail" then
                    local v116 = v105[2]
                    local v117 = v105[3]
                    local v118 = v_u_20:Clone()
                    v_u_52 = v104 + 1
                    v118.LayoutOrder = v_u_52
                    v118.Thumbnail.Image = v116
                    v118.Title.Text = v117
                    v118.Title.AutoLocalize = false
                    v_u_63(v118)
                    local v119
                    if p_u_42._is_open then
                        v119 = v_u_44.Container.Details.Changes or nil
                    else
                        v119 = nil
                    end
                    v118.Parent = v119
                    local v120 = p_u_42._elements
                    local v121 = { v118, v_u_44.Container.Details.Changes }
                    table.insert(v120, v121)
                    v104 = v_u_52
                elseif v115 == "BalancingOverview" then
                    v75(v105)
                elseif v115 == "ContentSummary" then
                    v87(v105)
                else
                    v103(v105)
                end
            end
        end
        v_u_46 = false
        p_u_42._is_generating = false
    end
end
function v_u_27._UpdateList(p122)
    p122.CloseButton.Position = UDim2.new(0.975, 0, 0.0225, p122.PageFrame.AbsoluteSize.Y * 0.125)
    p122.List.Position = UDim2.new(0.5, 9, 0, p122.PageFrame.AbsoluteSize.Y * 0.125)
    p122.List.Size = UDim2.new(0.85, 0, 0, p122.PageFrame.AbsoluteSize.Y * 0.75)
    p122.List.CanvasSize = UDim2.new(0, 0, 0, p122.Layout.AbsoluteContentSize.Y)
end
function v_u_27._UpdateSize(p123)
    local v124 = p123.PageContainer
    local v125 = UDim2.new
    local v126 = v_u_14.MainGui.AbsoluteSize.X * 0.875
    v124.Size = v125(0, math.min(1000, v126), 1, 0)
end
function v_u_27._Init(p_u_127)
    p_u_127.CloseButton.MouseButton1Click:Connect(function()
        if v_u_10:Get("LastPatchNotesVersion") ~= v_u_5.GAME_VERSION then
            v_u_1.Remotes.Misc.ViewedPatchNotes:FireServer()
        end
        p_u_127:CloseRequest()
    end)
    p_u_127.Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        p_u_127.List.CanvasSize = UDim2.new(0, 0, 0, p_u_127.Layout.AbsoluteContentSize.Y)
    end)
    p_u_127.List:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
        if not p_u_127._is_generating and p_u_127.List.CanvasPosition.Y >= p_u_127.List.AbsoluteCanvasSize.Y - p_u_127.List.AbsoluteWindowSize.Y - 20 then
            p_u_127:_GenerateNext()
        end
    end)
    p_u_127.Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        p_u_127:_UpdateList()
    end)
    p_u_127.PageFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        p_u_127:_UpdateList()
    end)
    p_u_127.ViewMoreButton.MouseButton1Click:Connect(function()
        p_u_127:_GenerateNext()
    end)
    v_u_14.MainGui:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        p_u_127:_UpdateSize()
    end)
    p_u_127:_UpdateSize()
    p_u_127:_UpdateList()
    task.spawn(p_u_127._GenerateNext, p_u_127)
    v_u_12:Add(p_u_127.CloseButton)
    v_u_12:Add(p_u_127.ViewMoreButton)
end
return v_u_27._new()