local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.CosmeticLibrary)
local v_u_4 = require(v2.LocalPlayer.PlayerScripts.Modules:WaitForChild("EmoteViewportFrame"))
local v_u_5 = require(v2.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect"))
local v_u_6 = require(script.Parent)
local v_u_7 = v2.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("ShopBigSlot")
local v_u_8 = setmetatable({}, v_u_6)
v_u_8.__index = v_u_8
function v_u_8.new(...)
    local v9 = v_u_6.new(...)
    local v10 = v_u_8
    local v11 = setmetatable(v9, v10)
    v11.Frame = v_u_7:Clone()
    v11._emote_viewport_frame = nil
    v11:_Init()
    return v11
end
function v_u_8.OnClick(p12, p13)
    p12.Frame.Button.MouseButton1Click:Connect(p13)
end
function v_u_8.SetDescription(p14, p15)
    p14.Frame.Button.Description.Text = p15
end
function v_u_8.Destroy(p16)
    if p16._emote_viewport_frame then
        p16._emote_viewport_frame:Destroy()
    end
    p16.Frame:Destroy()
end
function v_u_8._Setup(p17)
    local v18 = v_u_3.Cosmetics[p17.FirstRewardData.Name]
    p17.Frame.Button.Background.BackgroundColor3 = v_u_3.Rarities[v18.Rarity].Color
    p17.Frame.Button.Background.UIStroke.Color = p17.Frame.Button.Background.BackgroundColor3
    p17.Frame.Button.Icon.Image = v18.ImageHighResolution or ""
    p17.Frame.Button.Title.Text = p17.FirstRewardData.Name
    p17.Frame.Button.Weapon.Text = v18.Rarity .. " " .. (v18.ItemName or "???") .. " " .. v18.Type
    if not (p17.IsOwned or p17.IsLocked) then
        v_u_5:Add(p17.Frame.Button, nil, {
            ["HoverRatio"] = 1.03,
            ["ReleaseRatio"] = 1.03
        })
    end
    if v18.Type == "Emote" then
        p17._emote_viewport_frame = v_u_4.new(p17.FirstRewardData.Name)
        p17._emote_viewport_frame:SetParent(p17.Frame.Button)
        p17._emote_viewport_frame.Frame.ZIndex = 9
        p17._emote_viewport_frame.Frame.Position = UDim2.new(0.5, 0, 1, 0)
        p17._emote_viewport_frame.EmoteGlow.Position = UDim2.new(0.5, 0, 0.85, 0)
        p17._emote_viewport_frame.EmoteGlow.Position = UDim2.new(0.5, 0, 0.85, 0)
    end
end
function v_u_8._Init(p19)
    p19:_Setup()
    p19:_SetupBuyButton(p19.Frame.Button.Buy, p19.Frame.Button.Owned)
    p19:SetDescription("")
end
return v_u_8