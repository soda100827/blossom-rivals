local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.CosmeticLibrary)
local v_u_4 = require(v1.Modules.LootLibrary)
local v_u_5 = require(v1.Modules.ItemLibrary)
local v_u_6 = require(v2.LocalPlayer.PlayerScripts.Controllers:WaitForChild("PlayerDataController"))
local v_u_7 = require(v2.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect"))
local v_u_8 = require(v2.LocalPlayer.PlayerScripts.Modules:WaitForChild("RewardSlot"))
local v_u_9 = require(v2.LocalPlayer.PlayerScripts.Modules:WaitForChild("Prompt"))
local v_u_10 = v2.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("LootboxListSlot")
local v_u_11 = setmetatable({}, v_u_9)
v_u_11.__index = v_u_11
function v_u_11.new(p12, p13, p14, ...)
    local v15 = v_u_9.new(script.Name)
    local v16 = v_u_11
    local v17 = setmetatable(v15, v16)
    v17.CloseButton = v17.PromptFrame:WaitForChild("Close")
    v17.SwitchButton = v17.PromptFrame:WaitForChild("Switch")
    v17.SwitchIcon = v17.SwitchButton:WaitForChild("Icon")
    v17.TitleText = v17.PromptFrame:WaitForChild("Title")
    v17.Grid = v17.PromptFrame:WaitForChild("Grid")
    v17.GridContainer = v17.Grid:WaitForChild("Container")
    v17.GridLayout = v17.GridContainer:WaitForChild("Layout")
    v17.List = v17.PromptFrame:WaitForChild("List")
    v17.ListContainer = v17.List:WaitForChild("Container")
    v17.ListLayout = v17.ListContainer:WaitForChild("Layout")
    v17.ListGridFrame = v17.ListContainer:WaitForChild("Grid")
    v17.ListGridContainer = v17.ListGridFrame:WaitForChild("Container")
    v17.ListGridLayout = v17.ListGridContainer:WaitForChild("Layout")
    v17.Name = p12
    v17.RewardInfo = v_u_3.Rewards[v17.Name]
    v17._weapon = p13 or "IsRandom"
    v17._back_to_prompt_name = p14
    v17._back_to_prompt_args = { ... }
    v17._reward_slots = {}
    v17:_Init()
    return v17
end
function v_u_11.CloseRequest(p18)
    if p18._back_to_prompt_name then
        local v19 = p18.OpenPrompt
        local v20 = p18._back_to_prompt_name
        local v21 = p18._back_to_prompt_args
        v19:Fire(v20, table.unpack(v21))
    else
        v_u_9.CloseRequest(p18)
    end
end
function v_u_11.Destroy(p22)
    for _, v23 in pairs(p22._reward_slots) do
        v23:Destroy()
    end
    v_u_9.Destroy(p22)
end
function v_u_11._SwitchDisplayType(p24, p25)
    p24.List.Visible = p25
    p24.Grid.Visible = not p25
    p24.SwitchIcon.Image = p25 and "rbxassetid://11188369081" or "rbxassetid://7776047744"
end
function v_u_11._Setup(p26)
    p26.TitleText.Text = p26.Name
    local v27, v28, v29 = v_u_4:GetLootboxPossibilities(p26.RewardInfo.GetContents(), v_u_6:Get("CosmeticInventory"), v_u_6:GetUnlockedWeapons(), p26._weapon)
    local v30 = 0
    for _, v31 in pairs(v27) do
        local v32 = ""
        local v33 = v_u_5.Statuses.Standard.Color
        local v34 = v_u_3.Cosmetics[v31]
        local v35 = v_u_3.Rewards[v31]
        if v34 then
            v32 = v34.Rarity .. " " .. (v34.ItemName and (v34.ItemName .. " " or "") or "") .. v34.Type
            v33 = v_u_3.Rarities[v34.Rarity].Color
        elseif v35 then
            if v35.Type == "Weapon" then
                local v36 = v_u_5.Items[v31]
                v32 = v36.Status .. " Weapon"
                v33 = v_u_5.Statuses[v36.Status].Color
            else
                v32 = v35.Type
            end
        end
        local v37 = string.format("%.2f%%", 100 / #v27)
        local v38
        if v35 or not v34 then
            v38 = nil
        else
            v38 = v34.ItemName or p26._weapon
        end
        local v39 = v_u_10:Clone()
        v39.LayoutOrder = v30
        v39.ItemName.Text = v31
        v39.Type.Text = v32
        v39.Background.ImageColor3 = v33
        v39.Background.BackgroundColor3 = v33
        v39.Background.UIStroke.Color = v33
        v39.Chance.Text = v37 or ""
        v39.Parent = p26.ListContainer
        for v40 = 1, 2 do
            local v41 = v_u_8.new({
                ["Name"] = v31,
                ["Weapon"] = v38
            })
            v41.Frame.LayoutOrder = v30
            v41:SetParent(v40 == 2 and v39.Container or p26.GridContainer)
            v41:SetNameText(v37)
            local v42 = p26._reward_slots
            table.insert(v42, v41)
            if v40 == 2 and v41.CosmeticSlot then
                v41.CosmeticSlot.Frame.Button.Background.Visible = false
                v41.CosmeticSlot.Frame.Button.Title.Visible = false
            end
        end
        v30 = v30 + 1
    end
    for _, v43 in pairs(v28) do
        local v44 = v_u_3.Cosmetics[v43]
        local v45
        if v_u_3.Rewards[v43] or not v44 then
            v45 = nil
        else
            v45 = v44.ItemName or p26._weapon
        end
        for v46 = 1, 2 do
            local v47 = v_u_8.new({
                ["Name"] = v43,
                ["Weapon"] = v45
            }, false, true)
            v47.Frame.LayoutOrder = v30
            v47:SetParent(v46 == 2 and p26.ListGridContainer or p26.GridContainer)
            v47:OnClick(function() end)
            v47:SetNameText("")
            local v48 = p26._reward_slots
            table.insert(v48, v47)
            if v47.CosmeticSlot then
                v47.CosmeticSlot.Frame.Button.Locked.ImageColor3 = Color3.fromRGB(0, 0, 0)
                v47.CosmeticSlot.Frame.Button.Locked.ImageTransparency = 0
            end
        end
        v30 = v30 + 1
    end
    for _, v49 in pairs(v29) do
        local v50 = v_u_3.Cosmetics[v49]
        local v51
        if v_u_3.Rewards[v49] or not v50 then
            v51 = nil
        else
            v51 = v50.ItemName or p26._weapon
        end
        for v52 = 1, 2 do
            local v53 = v_u_8.new({
                ["Name"] = v49,
                ["Weapon"] = v51
            }, false, true)
            v53.Frame.LayoutOrder = v30
            v53:SetParent(v52 == 2 and p26.ListGridContainer or p26.GridContainer)
            v53:SetNameText("")
            local v54 = p26._reward_slots
            table.insert(v54, v53)
            if v53.CosmeticSlot then
                v53.CosmeticSlot.Frame.Button.Locked.Image = "rbxassetid://17588806026"
                v53.CosmeticSlot.Frame.Button.Locked.ImageColor3 = Color3.fromRGB(0, 0, 0)
                v53.CosmeticSlot.Frame.Button.Locked.ImageTransparency = 0
            else
                v53.Frame.Reward.Icon.ImageColor3 = Color3.fromRGB(64, 64, 64)
                local v55 = Instance.new("ImageLabel")
                v55.AnchorPoint = Vector2.new(0.5, 0.5)
                v55.BackgroundTransparency = 1
                v55.Position = UDim2.new(0.5, 0, 0.5, 0)
                v55.Size = UDim2.new(0.375, 0, 0.375, 0)
                v55.ZIndex = 10
                v55.Image = "rbxassetid://17588806026"
                v55.ImageColor3 = Color3.fromRGB(255, 255, 255)
                v55.ScaleType = Enum.ScaleType.Fit
                v55.Name = "CheckMark"
                v55.Parent = v53.Frame.Reward
            end
        end
        v30 = v30 + 1
    end
end
function v_u_11._Init(p_u_56)
    p_u_56.CloseButton.MouseButton1Click:Connect(function()
        p_u_56:CloseRequest()
    end)
    p_u_56.SwitchButton.MouseButton1Click:Connect(function()
        p_u_56:_SwitchDisplayType(not p_u_56.List.Visible)
    end)
    p_u_56.GridLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        p_u_56.Grid.CanvasSize = UDim2.new(0, 0, 0, p_u_56.GridLayout.AbsoluteContentSize.Y)
    end)
    p_u_56.ListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        p_u_56.List.CanvasSize = UDim2.new(0, 0, 0, p_u_56.ListLayout.AbsoluteContentSize.Y)
    end)
    p_u_56.ListGridLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        p_u_56.ListGridFrame.Size = UDim2.new(1, 0, 0, p_u_56.ListGridLayout.AbsoluteContentSize.Y)
    end)
    p_u_56:_Setup()
    p_u_56:_SwitchDisplayType(true)
    v_u_7:Add(p_u_56.CloseButton)
    v_u_7:Add(p_u_56.SwitchButton)
end
return v_u_11