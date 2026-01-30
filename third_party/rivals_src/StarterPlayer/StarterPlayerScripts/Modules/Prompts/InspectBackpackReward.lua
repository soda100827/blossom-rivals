local v_u_1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v_u_1.Modules.CONSTANTS)
local v_u_4 = require(v_u_1.Modules.CosmeticLibrary)
local v_u_5 = require(v_u_1.Modules.ServerOsTime)
local v_u_6 = require(v_u_1.Modules.Utility)
local v_u_7 = require(v_u_1.Modules.Signal)
local v_u_8 = require(v2.LocalPlayer.PlayerScripts.Controllers:WaitForChild("PlayerDataController"))
local v_u_9 = require(v2.LocalPlayer.PlayerScripts.Controllers:WaitForChild("FighterController"))
local v_u_10 = require(v2.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect"))
local v_u_11 = require(v2.LocalPlayer.PlayerScripts.Modules:WaitForChild("RewardSlot"))
local v_u_12 = require(v2.LocalPlayer.PlayerScripts.Modules:WaitForChild("Prompt"))
local v_u_13 = setmetatable({}, v_u_12)
v_u_13.__index = v_u_13
function v_u_13.new(p14)
    local v15 = v_u_12.new(script.Name)
    local v16 = v_u_13
    local v17 = setmetatable(v15, v16)
    v17.ClosePage = v_u_7.new()
    v17.Title = v17.PromptFrame:WaitForChild("Title")
    v17.ExpireText = v17.PromptFrame:WaitForChild("Expire")
    v17.ExpireLeftIcon = v17.ExpireText:WaitForChild("LeftIcon")
    v17.ExpireRightIcon = v17.ExpireText:WaitForChild("RightIcon")
    v17.Container = v17.PromptFrame:WaitForChild("Container")
    v17.CloseButton = v17.PromptFrame:WaitForChild("Close")
    v17.ButtonsFrame = v17.PromptFrame:WaitForChild("Buttons")
    v17.ViewContentsButton = v17.ButtonsFrame:WaitForChild("ViewContents")
    v17.UseButton = v17.ButtonsFrame:WaitForChild("Use")
    v17.Use3Button = v17.ButtonsFrame:WaitForChild("Use3")
    v17.UseMaxButton = v17.ButtonsFrame:WaitForChild("UseMax")
    v17.UseMaxButtonText = v17.UseMaxButton:WaitForChild("Price")
    v17.Index = p14
    v17.RewardData = v_u_8:Get("UnclaimedRewards")[v17.Index]
    v17._reward_slots = {}
    v17._cosmetic_info = v_u_4.Cosmetics[v17.RewardData.Name]
    v17._reward_info = v_u_4.Rewards[v17.RewardData.Name]
    v17:_Init()
    return v17
end
function v_u_13.Use(p18, p19)
    if v_u_9.LocalFighter and not (v_u_9.LocalFighter:Get("IsInDuel") or v_u_9.LocalFighter:Get("IsInShootingRange")) then
        local v20 = p18._reward_info
        if v20 then
            v20 = p18._reward_info.Type == "Lootbox"
        end
        if v_u_1.Remotes.Data.UseUnclaimedReward:InvokeServer(p18.Index, p19) == "Success" then
            if v20 then
                if p18._reward_info.SoundProfile then
                    p18.ClosePage:Fire()
                    return
                end
                p18:CloseRequest()
            end
            return
        elseif v20 then
            p18.OpenPrompt:Fire("ErrorMessage", "Woops!", "Failed to open, you probably already have everything!")
            return
        elseif p18._cosmetic_info and v_u_4.Types[p18._cosmetic_info.Type].IsWeaponCosmetic then
            p18.OpenPrompt:Fire("ErrorMessage", "Woops!", "Failed to use, this item is probably already unlocked for all possible weapons!")
        else
            p18.OpenPrompt:Fire("ErrorMessage", "Woops!", "Failed to use, this item is probably already unlocked!")
        end
    else
        return
    end
end
function v_u_13.Destroy(p21)
    for _, v22 in pairs(p21._reward_slots) do
        v22:Destroy()
    end
    v_u_12.Destroy(p21)
end
function v_u_13._UpdateTextBounds(p23)
    p23.ExpireLeftIcon.Position = UDim2.new(0.5, -p23.ExpireText.TextBounds.X / 2, 0.5, 0)
    p23.ExpireRightIcon.Position = UDim2.new(0.5, p23.ExpireText.TextBounds.X / 2, 0.5, 0)
end
function v_u_13._UpdateExpireText(p24)
    p24.ExpireText.Text = v_u_5:Get() >= p24.RewardData.ExpireTime and "This item has expired" or "Expires in " .. v_u_6:TimeFormat2(p24.RewardData.ExpireTime - v_u_5:GetRounded())
end
function v_u_13._Setup(p_u_25)
    p_u_25.Title.Text = p_u_25._cosmetic_info and (p_u_25.RewardData.Weapon == "IsRandom" and "Random" or (p_u_25.RewardData.Weapon == "IsUniversal" and "Universal" or p_u_25.RewardData.Weapon)) .. " " .. p_u_25._cosmetic_info.Type or p_u_25.RewardData.Name
    p_u_25.ExpireText.Visible = p_u_25.RewardData.ExpireTime ~= nil
    local v26 = p_u_25.ViewContentsButton
    local v27 = p_u_25._reward_info
    if v27 then
        v27 = p_u_25._reward_info.Type == "Lootbox"
    end
    v26.Visible = v27
    local v28 = p_u_25.Use3Button
    local v29 = p_u_25.ViewContentsButton.Visible
    if v29 then
        v29 = (p_u_25.RewardData.Quantity or 1) >= 3
    end
    v28.Visible = v29
    local v30 = p_u_25.UseMaxButton
    local v31 = p_u_25.ViewContentsButton.Visible
    if v31 then
        v31 = (p_u_25.RewardData.Quantity or 1) > 3
    end
    v30.Visible = v31
    local v32 = p_u_25.UseMaxButtonText
    local v33 = v_u_3.MAX_BACKPACK_USE_QUANTITY
    local v34 = p_u_25.RewardData.Quantity or 1
    v32.Text = "\195\151" .. math.min(v33, v34)
    local v35 = v_u_11.new(p_u_25.RewardData)
    v35:SetParent(p_u_25.Container)
    local v36 = p_u_25._reward_slots
    table.insert(v36, v35)
    if p_u_25.ExpireText.Visible then
        task.defer(function()
            while not p_u_25._destroyed do
                p_u_25:_UpdateExpireText()
                wait(1)
            end
        end)
    end
end
function v_u_13._Init(p_u_37)
    p_u_37.CloseButton.MouseButton1Click:Connect(function()
        p_u_37:CloseRequest()
    end)
    p_u_37.UseButton.MouseButton1Click:Connect(function()
        p_u_37:Use(1)
    end)
    p_u_37.Use3Button.MouseButton1Click:Connect(function()
        p_u_37:Use(3)
    end)
    p_u_37.UseMaxButton.MouseButton1Click:Connect(function()
        p_u_37:Use(v_u_3.MAX_BACKPACK_USE_QUANTITY)
    end)
    p_u_37.ViewContentsButton.MouseButton1Click:Connect(function()
        p_u_37.OpenPrompt:Fire("InspectLootbox", p_u_37.RewardData.Name, p_u_37.RewardData.Weapon, "InspectBackpackReward", p_u_37.Index)
    end)
    p_u_37.ExpireText:GetPropertyChangedSignal("TextBounds"):Connect(function()
        p_u_37:_UpdateTextBounds()
    end)
    p_u_37:_Setup()
    p_u_37:_UpdateTextBounds()
    v_u_10:Add(p_u_37.UseButton)
    v_u_10:Add(p_u_37.Use3Button)
    v_u_10:Add(p_u_37.UseMaxButton)
    v_u_10:Add(p_u_37.CloseButton)
    v_u_10:Add(p_u_37.ViewContentsButton)
end
return v_u_13