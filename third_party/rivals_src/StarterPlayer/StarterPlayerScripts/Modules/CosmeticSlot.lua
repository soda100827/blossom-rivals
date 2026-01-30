local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.CONSTANTS)
local v_u_4 = require(v1.Modules.CosmeticLibrary)
local v_u_5 = require(v1.Modules.ItemLibrary)
local v_u_6 = require(v1.Modules.Utility)
require(v2.LocalPlayer.PlayerScripts.Modules:WaitForChild("StaticModel"):WaitForChild("StaticViewModel"))
local v_u_7 = require(v2.LocalPlayer.PlayerScripts.Modules:WaitForChild("CosmeticViewportFrame"))
local v_u_8 = require(v2.LocalPlayer.PlayerScripts.Modules:WaitForChild("WeaponStatusHandler"))
local v_u_9 = require(v2.LocalPlayer.PlayerScripts.Modules:WaitForChild("EmoteViewportFrame"))
local v_u_10 = require(v2.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect"))
local v_u_11 = v2.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("CosmeticSlot")
local v_u_12 = {}
v_u_12.__index = v_u_12
function v_u_12.new(p13, p14, p15)
    local v16 = v_u_12
    local v17 = setmetatable({}, v16)
    v17.Name = p13
    v17.Info = v_u_4.Cosmetics[v17.Name]
    v17.IsLocked = p14
    v17.Frame = v_u_11:Clone()
    v17._cleanup = {}
    v17._ignore_button_effects = p15
    v17._quantity = 1
    v17._name_text_override = nil
    v17._emote_viewport_frame = nil
    v17._cosmetic_viewport_frame = nil
    v17:_Init()
    return v17
end
function v_u_12.SetWeapon(p18, p19)
    local v20 = v_u_5.Items[p19]
    local v21 = v_u_5.ViewModels[p19]
    local v22 = p19 == "IsUniversal" and true or p19 == "IsRandom"
    local v23
    if p19 == "IsUniversal" then
        v23 = v_u_5.UNIVERSAL_WEAPON_ICON
    elseif p19 == "IsRandom" then
        v23 = v_u_5.RANDOM_WEAPON_ICON
    else
        v23 = not v21 and "" or (v21.ImageCentered or v21.Image)
    end
    p18.Frame.Button.Weapon.Visible = not p18.IsLocked and p19
    p18.Frame.Button.Weapon.Container.IconCanvas.Icon.Image = v23
    p18.Frame.Button.Weapon.Container.IconCanvas.Icon.ImageTransparency = v22 and 0.25 or 0
    p18.Frame.Button.Weapon.Container.IconCanvas.Icon.Size = v22 and UDim2.new(0.75, 0, 1, 0) or UDim2.new(4, 0, 4, 0)
    v_u_8:ApplyItemStatusToBackground(p18.Frame.Button.Weapon.Container.Background, p18.Frame.Button.Weapon.Container.Outline.UIStroke, v20 and v20.Status or "Standard")
end
function v_u_12.SetQuantity(p24, p25)
    p24._quantity = p25 or 1
    p24:_UpdateNameText()
end
function v_u_12.SetInteractable(p26, p27)
    p26.Frame.Button.Interactable = p27
end
function v_u_12.OverrideNameText(p28, p29)
    p28._name_text_override = p29
    p28:_UpdateNameText()
end
function v_u_12.UseHighResolutionImage(p30)
    p30.Frame.Button.Icon.Image = v_u_3.COSMETIC_IMAGES[p30.Name] or v_u_5.ViewModels[p30.Name] and v_u_5.ViewModels[p30.Name].ImageHighResolution or p30.Info.Image
end
function v_u_12.Destroy(p31)
    p31.Frame:Destroy()
    if p31._cosmetic_viewport_frame then
        p31._cosmetic_viewport_frame:Destroy()
    end
    if p31._emote_viewport_frame then
        p31._emote_viewport_frame:Destroy()
    end
end
function v_u_12._UpdateNameText(p32)
    p32.Frame.Button.Title.Size = (p32._name_text_override or (p32._quantity == 1 or p32._quantity == 0)) and UDim2.new(0.9, 0, 0.2, 0) or UDim2.new(0.9, 0, 0.4, 0)
    p32.Frame.Button.Title.Text = p32._name_text_override or (p32.Name == "RANDOM_COSMETIC" or (p32.Name == "NONE_COSMETIC" or (p32._quantity == 1 or p32._quantity == 0) and p32.Name)) or "\195\151" .. v_u_6:PrettyNumber(p32._quantity)
end
function v_u_12._Setup(p33)
    local v34 = p33.Info and v_u_4.Rarities[p33.Info.Rarity].Color or Color3.fromRGB(0, 0, 0)
    p33.Frame.Button.Icon.Size = (p33.Name == "RANDOM_COSMETIC" or p33.Name == "NONE_COSMETIC") and UDim2.new(0.45, 0, 0.45, 0) or UDim2.new(0.75 * p33.Info.ImageScale, 0, 0.75 * p33.Info.ImageScale, 0)
    p33.Frame.Button.Icon.Image = v_u_3.COSMETIC_IMAGES[p33.Name] or p33.Info.Image
    p33.Frame.Button.Icon.ImageTransparency = (p33.Name == "RANDOM_COSMETIC" or p33.Name == "NONE_COSMETIC") and 0.875 or (p33.IsLocked and 0.5 or 0)
    p33.Frame.Button.Icon.ImageColor3 = p33.IsLocked and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(255, 255, 255)
    p33.Frame.Button.Title.TextTransparency = p33.IsLocked and 0.5 or 0
    p33.Frame.Button.Locked.Visible = p33.IsLocked
    p33.Frame.Button.Background.UIStroke.Color = v34
    p33.Frame.Button.Background.BackgroundColor3 = v34
    if not p33._ignore_button_effects then
        v_u_10:Add(p33.Frame.Button)
    end
    if p33.Info and p33.Info.Type == "Emote" then
        p33._emote_viewport_frame = v_u_9.new(p33.Name)
        p33._emote_viewport_frame.Frame.ZIndex = p33.IsLocked and 0 or 1
        p33._emote_viewport_frame:SetParent(p33.Frame.Button)
        p33._emote_viewport_frame:SetLocked(p33.IsLocked)
    end
    p33._cosmetic_viewport_frame = v_u_7.new(p33.Name, p33.IsLocked)
    p33._cosmetic_viewport_frame.Frame.BackgroundColor3 = v34
    p33._cosmetic_viewport_frame.Frame.Parent = p33.Frame.Button
end
function v_u_12._Init(p_u_35)
    p_u_35.Frame.Destroying:Connect(function()
        for _, v36 in pairs(p_u_35._cleanup) do
            v36:Destroy()
        end
    end)
    p_u_35:_Setup()
    p_u_35:_UpdateNameText()
    p_u_35:SetWeapon(nil)
    p_u_35:SetQuantity(nil)
end
return v_u_12