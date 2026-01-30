local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.CosmeticLibrary)
local v_u_4 = require(v1.Modules.Signal)
local v_u_5 = require(v2.LocalPlayer.PlayerScripts.Modules.ButtonEffect)
local v_u_6 = require(v2.LocalPlayer.PlayerScripts.Modules.UserInterface.Pages)
local v_u_7 = require(v2.LocalPlayer.PlayerScripts.Controllers.PlayerDataController)
local v_u_8 = {}
v_u_8.__index = v_u_8
function v_u_8.new(p9)
    local v10 = v_u_8
    local v11 = setmetatable({}, v10)
    v11.SearchUpdated = v_u_4.new()
    v11.Customize = p9
    v11.Frame = v11.Customize.BottomContainer:WaitForChild("Actions")
    v11.BackButton = v11.Frame:WaitForChild("Back")
    v11.EmoteButton = v11.Frame:WaitForChild("Emote")
    v11.EmoteButtonEquipFrame = v11.EmoteButton:WaitForChild("Equip")
    v11.EmoteButtonUnequipFrame = v11.EmoteButton:WaitForChild("Unequip")
    v11.SearchFrame = v11.Frame:WaitForChild("Search")
    v11.SearchBox = v11.SearchFrame:WaitForChild("Box")
    v11:_Init()
    return v11
end
function v_u_8.OnCustomizingStateChanged(p12)
    p12:_UpdateEmoteButton()
end
function v_u_8.OnStateChanged(p13)
    p13:_UpdateEmoteButton()
    if not p13.Customize.Interface.Equipment:IsCustomizing() then
        p13.SearchBox.Text = ""
    end
end
function v_u_8._UpdateEmoteButton(p14)
    local v15 = p14.Customize.Interface.Equipment:GetSelectedCosmetic()
    local v16 = v_u_3.Cosmetics[v15]
    if v16 then
        v16 = v16.Type == "Emote"
    end
    local v17
    if v16 then
        v17 = v_u_3:OwnsCosmetic(v_u_7:Get("CosmeticInventory"), v15, p14.Customize.Interface.Equipment:GetSelectedWeapon())
    else
        v17 = v16
    end
    if v16 then
        v16 = v_u_7:IsEmoteEquipped(v15)
    end
    p14.EmoteButton.Visible = v17
    p14.EmoteButtonEquipFrame.Visible = not v16
    p14.EmoteButtonUnequipFrame.Visible = v16
    p14.SearchFrame.Size = v17 and UDim2.new(0.75, -10, 1, 0) or UDim2.new(0.875, -5, 1, 0)
end
function v_u_8._UpdateSearch(p18)
    p18.Customize.Interface.Equipment:SetCosmeticSearchQuery(p18.SearchBox.Text)
end
function v_u_8._Init(p_u_19)
    p_u_19.SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
        p_u_19:_UpdateSearch()
    end)
    p_u_19.BackButton.MouseButton1Click:Connect(function()
        p_u_19.Customize.Interface.Equipment:CloseRequest()
    end)
    p_u_19.EmoteButton.MouseButton1Click:Connect(function()
        v_u_6.PageSystem:OpenPage("EquipEmote")
        v_u_6.PageSystem:WaitForPage("EquipEmote"):SetEmoteName(p_u_19.Customize.Interface.Equipment:GetSelectedCosmetic())
    end)
    v_u_7:GetDataChangedSignal("CosmeticInventory"):Connect(function()
        p_u_19:_UpdateEmoteButton()
    end)
    v_u_5:Add(p_u_19.BackButton, nil, {
        ["HoverRatio"] = UDim2.new(0, 10, 0, 10),
        ["ReleaseRatio"] = UDim2.new(0, 10, 0, 10)
    })
    v_u_5:Add(p_u_19.EmoteButton, nil, {
        ["HoverRatio"] = UDim2.new(0, 10, 0, 10),
        ["ReleaseRatio"] = UDim2.new(0, 10, 0, 10)
    })
end
return v_u_8