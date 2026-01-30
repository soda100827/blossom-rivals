local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.SettingsLibrary)
local v_u_4 = require(v1.Modules.Utility)
local v_u_5 = require(v1.Modules.Signal)
local v_u_6 = require(v_u_2.LocalPlayer.PlayerScripts.Controllers:WaitForChild("PlayerDataController"))
local v_u_7 = require(v_u_2.LocalPlayer.PlayerScripts.Controllers:WaitForChild("SettingsController"))
local v_u_8 = require(v_u_2.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("MobileButtons"))
local v_u_9 = require(v_u_2.LocalPlayer.PlayerScripts.Modules:WaitForChild("InsetButtonsBar"))
local v_u_10 = require(v_u_2.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect"))
local v_u_11 = require(v_u_2.LocalPlayer.PlayerScripts.Modules:WaitForChild("UILibrary"))
local v_u_12 = v_u_2.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("InsetBarButtonShareBubble")
local v_u_13 = { "Settings Double Tap Shoot", "Settings Left Handed Touch Controls" }
local v_u_14 = {
    { "Close", "Finish editing", "rbxassetid://108220438104376" },
    { "Reset", "Reset this layout to default", "rbxassetid://81857929131936" },
    { "Share", "Share & import button layout", "rbxassetid://13733474711" }
}
local v_u_15 = {}
v_u_15.__index = v_u_15
function v_u_15.new(p16)
    local v17 = v_u_15
    local v18 = setmetatable({}, v17)
    v18.Inset = p16
    v18.Bar = v_u_9.new(v_u_11.BUTTON_BACKGROUND_TRANSPARENCY, v_u_11.BUTTON_BACKGROUND_COLOR, v_u_11.BUTTON_ICON_COLOR)
    v18._reset_button_hash = 0
    v18._interruption_internal = v_u_5.new()
    v18._share_bubble_frame = v_u_12:Clone()
    v18:_Init()
    return v18
end
function v_u_15.SetVisible(p19, p20, p21)
    p19.Bar.Frame.Visible = p20
    p19.Bar.Frame.Size = p21 or p19.Bar.Frame.Size
    p19.Bar:Toggle(true)
    p19:_CloseButtonAnimation()
    v_u_8:SetEditorEnabled(p20)
    if not p20 then
        p19._interruption_internal:Fire()
    end
end
function v_u_15._UpdateShareBubblePosition(p22)
    local v23 = p22.Bar.Buttons.Share.Frame.AbsolutePosition.X + p22.Bar.Buttons.Share.Frame.AbsoluteSize.X / 2 - p22.Bar.Frame.AbsolutePosition.X
    p22._share_bubble_frame.Position = UDim2.new(0, v23, 0.99, 0)
end
function v_u_15._CloseButtonAnimation(p24)
    local v25 = p24.Bar.Buttons.Close
    if v25.Frame:IsDescendantOf(v_u_2) then
        v25.Frame.Button.Icon.Size = UDim2.new(0, 0, 0, 0)
        v25.Frame.Button.Icon:TweenSize(UDim2.new(0.5, 0, 0.5, 0), "Out", "Quint", 0.25, true)
    else
        v25.Frame.Button.Icon.Size = UDim2.new(0.5, 0, 0.5, 0)
    end
end
function v_u_15._UpdateProfileButtons(p26)
    local v27 = v_u_6:Get("MobileButtonSettings")
    local v28 = v_u_6:Get("MobileButtonProfile")
    for v29, _ in pairs(v27) do
        local v30 = v28 == v29
        local v31 = p26.Bar.Buttons["Profile" .. v29]
        v31.Frame.Button.IsSelected.Visible = v30
        v31.Frame.Button.Title.TextColor3 = v30 and p26.Bar:GetBackgroundColor() or p26.Bar:GetVisualColor()
        v31.Frame.Button.Icon.ImageColor3 = v30 and p26.Bar:GetBackgroundColor() or p26.Bar:GetVisualColor()
    end
end
function v_u_15._Setup(p_u_32)
    for v33, v34 in pairs(v_u_14) do
        p_u_32.Bar:CreateButton(v33, table.unpack(v34))
    end
    local v35 = v_u_6:Get("MobileButtonSettings")
    for v_u_36, _ in pairs(v35) do
        local v37 = p_u_32.Bar:CreateButton(#v_u_14 + v_u_36, "Profile" .. v_u_36, "Switch to layout #" .. v_u_36, v_u_36)
        local v38 = Instance.new("Frame")
        v38.AnchorPoint = Vector2.new(0.5, 0.5)
        v38.Size = UDim2.new(0.75, 0, 0.75, 0)
        v38.Position = UDim2.new(0.5, 0, 0.5, 0)
        v38.ZIndex = 0
        v38.Name = "IsSelected"
        v38.BackgroundColor3 = p_u_32.Bar:GetVisualColor()
        v38.Parent = v37.Frame.Button
        local v39 = Instance.new("UICorner")
        v39.CornerRadius = UDim.new(1, 0)
        v39.Parent = v38
        v37.Clicked:Connect(function()
            v_u_8:Switch(v_u_36)
        end)
    end
    for v40, v_u_41 in pairs(v_u_13) do
        local v_u_42 = v_u_3.Info[v_u_41]
        local v_u_43 = p_u_32.Bar:CreateButton(#v_u_14 + #v35 + v40, "Settings" .. v40, nil, v_u_42.Image)
        v_u_43.Clicked:Connect(function()
            v_u_7:ChangeSetting(v_u_41, not v_u_6:Get(v_u_41))
        end)
        local v_u_44 = 0
        local function v_u_49(p45)
            p_u_32._interruption_internal:Fire(v_u_41)
            v_u_44 = v_u_44 + 1
            local v46 = v_u_6:Get(v_u_41)
            v_u_43.Frame.Button.Icon.ImageColor3 = v46 and Color3.fromRGB(100, 255, 50) or Color3.fromRGB(255, 50, 50)
            local v47 = v_u_43
            local v48
            if p45 then
                v48 = string.format("%s <font weight=\"900\" color=\"rgb(%s)\">%s</font>", v_u_42.DisplayName, v46 and "100,255,50" or "255,50,50", v46 and "ON" or "OFF")
            else
                v48 = nil
            end
            v47:PlayBubbleEffect(v48)
        end
        v_u_6:GetDataChangedSignal(v_u_41):Connect(function()
            v_u_49(true)
        end)
        v_u_49(false)
        p_u_32._interruption_internal:Connect(function(p50)
            if p50 ~= v_u_41 then
                v_u_43:PlayBubbleEffect(nil)
            end
        end)
    end
    p_u_32.Bar.Buttons.Close.Clicked:Connect(function()
        p_u_32:SetVisible(false)
        p_u_32.Inset.MainBar:SetVisible(true, p_u_32.Bar.Frame.Size)
    end)
    p_u_32.Bar.Buttons.Reset.Clicked:Connect(function()
        local v51 = p_u_32
        v51._reset_button_hash = v51._reset_button_hash + 1
        local v_u_52 = p_u_32._reset_button_hash
        task.spawn(v_u_4.RenderstepForLoop, v_u_4, 0, 100, 5, function(p53)
            if p_u_32._reset_button_hash ~= v_u_52 then
                return true
            end
            local v54 = 1 - (1 - p53 / 100) ^ 3
            p_u_32.Bar.Buttons.Reset.Frame.Button.Icon.Rotation = -360 * (1 - v54)
        end)
        v_u_8:Reset()
    end)
    p_u_32.Bar.Buttons.Share.Clicked:Connect(function()
        p_u_32._share_bubble_frame.Import.Box.Text = ""
        p_u_32._share_bubble_frame.Export.Text = v_u_8:EncryptProfile()
        p_u_32._share_bubble_frame.ExportTitle.Text = "Share layout #" .. v_u_6:Get("MobileButtonProfile") .. " by copying this: "
        p_u_32._share_bubble_frame.Visible = true
        p_u_32._interruption_internal:Fire("Share")
    end)
    p_u_32.Bar.Buttons.Share.Frame:GetPropertyChangedSignal("AbsolutePosition"):Connect(function()
        p_u_32:_UpdateShareBubblePosition()
    end)
    p_u_32.Bar.Buttons.Share.Frame:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        p_u_32:_UpdateShareBubblePosition()
    end)
    p_u_32._interruption_internal:Connect(function(p55)
        if p55 ~= "Share" then
            p_u_32._share_bubble_frame.Visible = false
        end
    end)
    p_u_32._share_bubble_frame.Parent = p_u_32.Bar.Frame
    p_u_32.Bar.Frame.Parent = p_u_32.Inset.LeftButtonsFrame
end
function v_u_15._Init(p_u_56)
    p_u_56.Bar.Frame:GetPropertyChangedSignal("AbsolutePosition"):Connect(function()
        p_u_56:_UpdateShareBubblePosition()
    end)
    p_u_56._share_bubble_frame.Close.MouseButton1Click:Connect(function()
        p_u_56._share_bubble_frame.Visible = false
    end)
    p_u_56._share_bubble_frame.Import.Button.MouseButton1Click:Connect(function()
        v_u_8:ImportProfile(p_u_56._share_bubble_frame.Import.Box.Text)
    end)
    v_u_6:GetDataChangedSignal("MobileButtonSettings"):Connect(function()
        p_u_56:_UpdateProfileButtons()
    end)
    v_u_6:GetDataChangedSignal("MobileButtonProfile"):Connect(function()
        p_u_56:_UpdateProfileButtons()
    end)
    p_u_56:_Setup()
    p_u_56:_UpdateProfileButtons()
    p_u_56:_UpdateShareBubblePosition()
    p_u_56:SetVisible(false)
    v_u_10:Add(p_u_56._share_bubble_frame.Import.Button, true)
end
return v_u_15