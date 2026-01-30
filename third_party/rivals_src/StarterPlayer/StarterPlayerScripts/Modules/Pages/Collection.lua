local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.CONSTANTS)
local v_u_4 = require(v1.Modules.CosmeticLibrary)
local v_u_5 = require(v1.Modules.ItemLibrary)
local v_u_6 = require(v1.Modules.ShopLibrary)
local v_u_7 = require(v1.Modules.Utility)
local v_u_8 = require(v2.LocalPlayer.PlayerScripts.Controllers:WaitForChild("PlayerDataController"))
local v_u_9 = require(v2.LocalPlayer.PlayerScripts.Modules:WaitForChild("WeaponStatusHandler"))
local v_u_10 = require(v2.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect"))
local v_u_11 = require(v2.LocalPlayer.PlayerScripts.Modules:WaitForChild("CosmeticSlot"))
local v_u_12 = require(v2.LocalPlayer.PlayerScripts.Modules:WaitForChild("PromptSystem"))
local v_u_13 = require(v2.LocalPlayer.PlayerScripts.Modules:WaitForChild("WeaponSlot"))
local v_u_14 = require(v2.LocalPlayer.PlayerScripts.Modules:WaitForChild("Page"))
local v_u_15 = v2.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("CosmeticSlotBubble")
local v_u_16 = {
    "Weapon",
    "Skin",
    "Wrap",
    "Charm",
    "Finisher",
    "Emote"
}
local v_u_17 = setmetatable({}, v_u_14)
v_u_17.__index = v_u_17
function v_u_17._new()
    local v18 = v_u_14.new(script.Name)
    local v19 = v_u_17
    local v20 = setmetatable(v18, v19)
    v20.CloseButton = v20.PageFrame:WaitForChild("Close")
    v20.PromptsFrame = v20.PageFrame:WaitForChild("Prompts")
    v20.List = v20.PageFrame:WaitForChild("List")
    v20.Container = v20.List:WaitForChild("Container")
    v20.Layout = v20.Container:WaitForChild("Layout")
    v20.TabsFrame = v20.Container:WaitForChild("Tabs")
    v20.SlotsFrame = v20.Container:WaitForChild("Slots")
    v20.SlotsContainer = v20.SlotsFrame:WaitForChild("Container")
    v20.SlotsLayout = v20.SlotsContainer:WaitForChild("Layout")
    v20.SearchFrame = v20.Container:WaitForChild("Search")
    v20.SearchBox = v20.SearchFrame:WaitForChild("Box")
    v20.LockedSlotsFrame = v20.Container:WaitForChild("LockedSlots")
    v20.LockedSlotsContainer = v20.LockedSlotsFrame:WaitForChild("Container")
    v20.LockedSlotsLayout = v20.LockedSlotsContainer:WaitForChild("Layout")
    v20.Divider = v20.Container:WaitForChild("Divider")
    v20.CurrentTab = nil
    v20.PromptSystem = v_u_12.new(v20.PromptsFrame)
    v20._slots = {}
    v20._close_bubbles = {}
    v20._generate_hash = 0
    v20._search_query = ""
    v20:_Init()
    return v20
end
function v_u_17.SetTab(p21, p22)
    p21.CurrentTab = p22
    for _, v23 in pairs(v_u_16) do
        local v24 = v23 == p21.CurrentTab
        local v25 = p21.TabsFrame:WaitForChild(v23)
        local v26 = v25:WaitForChild("Background")
        v25:WaitForChild("Title").TextColor3 = v24 and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(255, 255, 255)
        v26.ImageColor3 = v24 and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(0, 0, 0)
        v26.ImageTransparency = v24 and 0 or 0.25
        v26:WaitForChild("UIGradient").Enabled = not v24
    end
    p21:_Generate()
end
function v_u_17.Open(p27, ...)
    v_u_14.Open(p27, ...)
    p27.SearchBox.Text = ""
    p27:_Generate()
end
function v_u_17.Close(p28)
    v_u_14.Close(p28)
    p28:_Generate()
end
function v_u_17._UpdateLayouts(p29)
    p29.List.CanvasSize = UDim2.new(0, 0, 0, p29.Layout.AbsoluteContentSize.Y)
    p29.List.Active = p29.Layout.AbsoluteContentSize.Y >= p29.List.AbsoluteSize.Y
    p29.SlotsFrame.Size = UDim2.new(1, 0, 0, p29.SlotsLayout.AbsoluteContentSize.Y)
    p29.SlotsFrame.Visible = p29.SlotsLayout.AbsoluteContentSize.Y > 0
    p29.LockedSlotsFrame.Size = UDim2.new(1, 0, 0, p29.LockedSlotsLayout.AbsoluteContentSize.Y)
    p29.LockedSlotsFrame.Visible = p29.LockedSlotsLayout.AbsoluteContentSize.Y > 0
end
function v_u_17._UpdateSearch(p30, p31)
    local v32 = p31.Frame
    local v33 = v_u_7
    local v34 = p30._search_query
    local v35 = p31.SearchArgs
    v32.Visible = v33:IsVisibleFromSearch(v34, table.unpack(v35))
end
function v_u_17._BulkUpdateSearch(p36)
    p36._search_query = string.lower(p36.SearchBox.Text)
    for _, v37 in pairs(p36._slots) do
        p36:_UpdateSearch(v37)
    end
end
function v_u_17._CloseBubbles(p38)
    for _, v39 in pairs(p38._close_bubbles) do
        v39()
    end
end
function v_u_17._GenerateWeapons(p_u_40)
    local v41 = p_u_40._generate_hash
    local v42 = v_u_8:GetUnlockedWeapons()
    for v43, v44 in pairs(v_u_6:GetReleasedOwnableWeapons(v_u_3.WEAPON_REVEAL_TIME_OFFSET, v_u_6.OwnableWeaponsAlphabetized)) do
        if v41 ~= p_u_40._generate_hash then
            return
        end
        local v_u_45 = v_u_5.Items[v44]
        local v46 = v_u_5.Statuses[v_u_45.Status]
        local v47 = not v42[v44]
        local v_u_48 = v_u_45.Status .. " " .. v_u_45.Class
        local v_u_49 = v_u_13.new(v44)
        v_u_49.Frame.LayoutOrder = v43 - v46.Value * 999999
        v_u_49.Frame.Parent = v47 and p_u_40.LockedSlotsContainer or p_u_40.SlotsContainer
        if v47 then
            v_u_49:Lock()
            if not v_u_6:IsWeaponReleased(v44) then
                v_u_49:HideName()
            end
        end
        local v_u_50 = nil
        local function v_u_51()
            v_u_50.Background.Size = UDim2.new(0, v_u_50.Title.TextBounds.X + v_u_50.Background.AbsoluteSize.Y, 1, 0)
        end
        p_u_40._close_bubbles[v44] = function()
            v_u_49.Frame.ZIndex = 0
            if v_u_50 then
                v_u_50:Destroy()
                v_u_50 = nil
            end
        end
        local function v52()
            p_u_40:_CloseBubbles()
            v_u_49.Frame.ZIndex = 1
            v_u_50 = v_u_15:Clone()
            v_u_50.Title.Text = v_u_48
            v_u_50.Parent = v_u_49.Frame.Button
            v_u_9:ApplyItemStatusToText(v_u_50.Title, v_u_45.Status)
            v_u_50.Background:GetPropertyChangedSignal("AbsoluteSize"):Connect(v_u_51)
            v_u_50.Title:GetPropertyChangedSignal("TextBounds"):Connect(v_u_51)
            v_u_50.Background.Size = UDim2.new(0, v_u_50.Title.TextBounds.X + v_u_50.Background.AbsoluteSize.Y, 1, 0)
            v_u_50.Size = UDim2.new(0, 0, 0.125, 0)
            v_u_50:TweenSize(UDim2.new(5, 0, 0.25, 0), "Out", "Quint", 0.25, true)
        end
        v_u_49.Frame.Button.MouseEnter:Connect(v52)
        v_u_49.Frame.Button.MouseButton1Click:Connect(v52)
        if not v47 then
            p_u_40.Divider.Visible = true
        end
        local v53 = {
            ["Object"] = v_u_49,
            ["Frame"] = v_u_49.Frame,
            ["SearchArgs"] = {
                v_u_49.Frame.Button.Title.Text,
                v_u_49.Frame.Button.Title,
                v_u_48,
                nil
            }
        }
        local v54 = p_u_40._slots
        table.insert(v54, v53)
        p_u_40:_UpdateSearch(v53)
        if v43 % 5 == 0 then
            wait(0.03)
        end
    end
end
function v_u_17._GenerateCosmetics(p_u_55)
    local v56 = v_u_8:GetUnlockedWeapons()
    local v57 = v_u_8:Get("CosmeticInventory")
    local v58 = p_u_55._generate_hash
    for v59, v_u_60 in pairs(v_u_4.CosmeticsAlphabetized) do
        if v58 ~= p_u_55._generate_hash then
            return
        end
        local v_u_61 = v_u_4.Cosmetics[v_u_60]
        if v_u_61.Type == p_u_55.CurrentTab and (v_u_61.Type ~= "Skin" or (v56[v_u_61.ItemName] or v_u_6:IsWeaponReleased(v_u_61.ItemName))) then
            local v_u_62 = not v_u_4:OwnsCosmeticForSomething(v57, v_u_60)
            if not (v_u_61.Hidden and v_u_62) then
                p_u_55.Divider.Visible = p_u_55.Divider.Visible or not v_u_62
                local v_u_63 = v_u_11.new(v_u_60, v_u_62)
                v_u_63.Frame.LayoutOrder = v59 - v_u_4.Rarities[v_u_61.Rarity].Value * 10000 + (v_u_62 and 9999999 or 0)
                v_u_63.Frame.Parent = v_u_62 and p_u_55.LockedSlotsContainer or p_u_55.SlotsContainer
                local v_u_64 = nil
                local function v_u_65()
                    v_u_64.Background.Size = UDim2.new(0, v_u_64.Title.TextBounds.X + v_u_64.Background.AbsoluteSize.Y, 1, 0)
                end
                p_u_55._close_bubbles[v_u_60] = function()
                    v_u_63.Frame.ZIndex = 0
                    if v_u_64 then
                        v_u_64:Destroy()
                        v_u_64 = nil
                    end
                end
                local function v_u_66()
                    if v_u_61.Description then
                        p_u_55:_CloseBubbles()
                        v_u_63.Frame.ZIndex = 1
                        v_u_64 = v_u_15:Clone()
                        v_u_64.Title.Text = v_u_61.Description or ""
                        v_u_64.Parent = v_u_63.Frame.Button
                        v_u_64.Title:GetPropertyChangedSignal("TextBounds"):Connect(v_u_65)
                        v_u_64.Background:GetPropertyChangedSignal("AbsoluteSize"):Connect(v_u_65)
                        v_u_64.Background.Size = UDim2.new(0, v_u_64.Title.TextBounds.X + v_u_64.Background.AbsoluteSize.Y, 1, 0)
                        v_u_64.Size = UDim2.new(0, 0, 0.125, 0)
                        v_u_64:TweenSize(UDim2.new(5, 0, 0.25, 0), "Out", "Quint", 0.25, true)
                    end
                end
                v_u_63.Frame.Button.MouseEnter:Connect(v_u_66)
                v_u_63.Frame.Button.MouseButton1Click:Connect(function()
                    if v_u_4.Types[v_u_61.Type].IsWeaponCosmetic and (v_u_61.Type ~= "Skin" and not v_u_62) then
                        p_u_55:_CloseBubbles()
                        p_u_55.PromptSystem:Open("InspectCosmetic", v_u_60)
                    else
                        v_u_66()
                    end
                end)
                local v67 = {
                    ["Object"] = v_u_63,
                    ["Frame"] = v_u_63.Frame,
                    ["SearchArgs"] = {
                        v_u_63.Frame.Button.Title.ContentText,
                        v_u_63.Frame.Button.Title,
                        v_u_61.Description,
                        nil
                    }
                }
                local v68 = p_u_55._slots
                table.insert(v68, v67)
                p_u_55:_UpdateSearch(v67)
                if v59 % 5 == 0 then
                    wait(0.03)
                end
            end
        end
    end
end
function v_u_17._Generate(p_u_69)
    for _, v70 in pairs(p_u_69._slots) do
        v70.Object:Destroy()
    end
    p_u_69._slots = {}
    p_u_69._close_bubbles = {}
    p_u_69._generate_hash = p_u_69._generate_hash + 1
    p_u_69.Divider.Visible = false
    p_u_69:_UpdateLayouts()
    if p_u_69._is_open then
        task.spawn(function()
            if p_u_69.CurrentTab == "Weapon" then
                p_u_69:_GenerateWeapons()
            else
                p_u_69:_GenerateCosmetics()
            end
            p_u_69:_UpdateLayouts()
        end)
    end
end
function v_u_17._Setup(p_u_71)
    for _, v_u_72 in pairs(v_u_16) do
        local v73 = p_u_71.TabsFrame:WaitForChild(v_u_72)
        v73.MouseButton1Click:Connect(function()
            p_u_71:SetTab(v_u_72)
        end)
        v_u_10:Add(v73)
    end
end
function v_u_17._Init(p_u_74)
    p_u_74.CloseButton.MouseButton1Click:Connect(function()
        p_u_74:CloseRequest()
    end)
    p_u_74.Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        p_u_74:_UpdateLayouts()
    end)
    p_u_74.SlotsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        p_u_74:_UpdateLayouts()
    end)
    p_u_74.LockedSlotsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        p_u_74:_UpdateLayouts()
    end)
    p_u_74.SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
        p_u_74:_BulkUpdateSearch()
    end)
    p_u_74:_Setup()
    p_u_74:SetTab("Weapon")
    v_u_10:Add(p_u_74.CloseButton)
end
return v_u_17._new()