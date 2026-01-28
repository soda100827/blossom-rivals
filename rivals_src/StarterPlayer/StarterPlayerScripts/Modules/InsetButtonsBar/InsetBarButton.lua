local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.Signal)
local v_u_4 = require(v_u_2.LocalPlayer.PlayerScripts.Modules.ButtonEffect)
local v_u_5 = v_u_2.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("InsetBarButton")
local v_u_6 = {}
v_u_6.__index = v_u_6
function v_u_6.new(p7, p8, p9, p10, p11, p12, p13)
    local v14 = v_u_6
    local v15 = setmetatable({}, v14)
    v15.Clicked = v_u_3.new()
    v15.Entered = v_u_3.new()
    v15.Name = p7
    v15.Frame = v_u_5:Clone()
    v15._display_name = p8
    v15._visual = p9
    v15._visual_position = p10
    v15._visual_size = p11
    v15._visual_color = p12
    v15._is_mirrored = p13
    v15._bubble_effect_hash = 0
    v15._bubble_effect_playing = false
    v15:_Init()
    return v15
end
function v_u_6.SetMirrored(p16, p17)
    if p17 ~= p16._is_mirrored then
        p16._is_mirrored = p17
        p16:_UpdateMirrored()
    end
end
function v_u_6.Enter(p18)
    if not p18._bubble_effect_playing then
        p18.Frame.Button.OnHover.Visible = true
        p18.Entered:Fire()
    end
end
function v_u_6.Leave(p19)
    if not p19._bubble_effect_playing then
        p19.Frame.Button.OnHover.Visible = false
    end
end
function v_u_6.SetBubbleText(p20, p21)
    p20.Frame.Button.OnHover.Bubble.Container.Title.Text = p21
end
function v_u_6.PlayBubbleEffect(p_u_22, p23)
    p_u_22._bubble_effect_hash = p_u_22._bubble_effect_hash + 1
    local v_u_24 = p_u_22._bubble_effect_hash
    if p23 then
        p_u_22._bubble_effect_playing = true
        p_u_22.Frame.Button.OnHover.Visible = true
        p_u_22.Frame.Button.OnHover.Bubble.Visible = true
        p_u_22.Frame.Button.OnHover.Bubble.Container.Title.Text = p23
        task.delay(3, function()
            wait(3)
            if v_u_24 == p_u_22._bubble_effect_hash and p_u_22.Frame:IsDescendantOf(v_u_2) then
                p_u_22:_DisableBubbleEffect()
            end
        end)
    else
        p_u_22:_DisableBubbleEffect()
    end
end
function v_u_6.Destroy(p_u_25)
    p_u_25.Clicked:Destroy()
    p_u_25.Entered:Destroy()
    pcall(function()
        p_u_25.Frame:Destroy()
    end)
end
function v_u_6._DisableBubbleEffect(p26)
    p26:_ResetBubbleVisibility()
    p26._bubble_effect_playing = false
    p26:Leave()
end
function v_u_6._ResetBubbleVisibility(p27)
    p27.Frame.Button.OnHover.Bubble.Visible = p27._display_name ~= nil
end
function v_u_6._UpdateBubble(p28)
    p28.Frame.Button.OnHover.Bubble.Container.Background.Size = UDim2.new(0.25, p28.Frame.Button.OnHover.Bubble.Container.Title.TextBounds.X, 1, 0)
end
function v_u_6._UpdateBubbleContainer(p29)
    local v30 = 1
    for v31 = 1, #p29.Frame.Button.OnHover.Bubble.Container.Title.Text do
        local v32 = p29.Frame.Button.OnHover.Bubble.Container.Title.Text
        if string.sub(v32, v31, v31) == "\n" then
            v30 = v30 + 1
        end
    end
    p29.Frame.Button.OnHover.Bubble.Container.Size = UDim2.new(3.25, 0, v30 * 0.75, 0)
    p29.Frame.Button.OnHover.Bubble.Container.Arrow.Size = UDim2.new(0.5 / v30, 0, 0.5 / v30, 0)
    p29:_UpdateBubble()
end
function v_u_6._UpdateMirrored(p33)
    p33.Frame.Button.OnHover.Bubble.Container.Title.AnchorPoint = p33._is_mirrored and Vector2.new(1, 0.5) or Vector2.new(0, 0.5)
    p33.Frame.Button.OnHover.Bubble.Container.Title.Position = p33._is_mirrored and UDim2.new(0.875, 0, 0.5, 0) or UDim2.new(0.125, 0, 0.5, 0)
    p33.Frame.Button.OnHover.Bubble.Container.Title.TextXAlignment = p33._is_mirrored and Enum.TextXAlignment.Right or Enum.TextXAlignment.Left
    p33.Frame.Button.OnHover.Bubble.Container.Background.AnchorPoint = p33._is_mirrored and Vector2.new(1, 0.5) or Vector2.new(0, 0.5)
    p33.Frame.Button.OnHover.Bubble.Container.Background.Position = p33._is_mirrored and UDim2.new(1, 0, 0.5, 0) or UDim2.new(0, 0, 0.5, 0)
    p33.Frame.Button.OnHover.Bubble.Container.Arrow.Position = p33._is_mirrored and UDim2.new(0.75, 0, 0, 2) or UDim2.new(0.25, 0, 0, 2)
    p33.Frame.Button.OnHover.Bubble.Container.AnchorPoint = p33._is_mirrored and Vector2.new(0.75, 0) or Vector2.new(0.25, 0)
end
function v_u_6._Setup(p34)
    local v35 = p34._visual
    local v36
    if typeof(v35) == "string" and #p34._visual >= 13 then
        local v37 = p34._visual
        v36 = string.sub(v37, 1, 13) == "rbxassetid://"
    else
        v36 = false
    end
    p34.Frame.Button.Icon.Image = v36 and (p34._visual or "") or ""
    p34.Frame.Button.Icon.Position = p34._visual_position or UDim2.new(0.5, 0, 0.5, 0)
    p34.Frame.Button.Icon.Size = p34._visual_size or UDim2.new(0.5, 0, 0.5, 0)
    p34.Frame.Button.Title.Position = p34._visual_position or UDim2.new(0.5, 0, 0.5, 0)
    p34.Frame.Button.Title.Size = p34._visual_size or UDim2.new(0.5, 0, 0.5, 0)
    p34.Frame.Button.Title.Text = v36 and "" or (p34._visual or "")
    p34.Frame.Button.Title.TextColor3 = p34._visual_color
    p34.Frame.Button.Icon.ImageColor3 = p34._visual_color
    p34.Frame.Button.OnHover.Visible = false
    p34.Frame.Button.OnHover.BackgroundTransparency = 0.75
    p34.Frame.Button.OnHover.Bubble.Container.Title.Text = p34._display_name or ""
end
function v_u_6._Init(p_u_38)
    p_u_38.Frame.Destroying:Connect(function()
        p_u_38:Destroy()
    end)
    p_u_38.Frame.Button.MouseButton1Click:Connect(function()
        p_u_38.Clicked:Fire()
    end)
    p_u_38.Frame.MouseEnter:Connect(function()
        p_u_38:Enter()
    end)
    p_u_38.Frame.MouseLeave:Connect(function()
        p_u_38:Leave()
    end)
    p_u_38.Frame:GetPropertyChangedSignal("Visible"):Connect(function()
        p_u_38:Leave()
    end)
    p_u_38.Frame.Button.OnHover.Bubble.Container.Title:GetPropertyChangedSignal("TextBounds"):Connect(function()
        p_u_38:_UpdateBubble()
    end)
    p_u_38.Frame.Button.OnHover.Bubble.Container.Title:GetPropertyChangedSignal("Text"):Connect(function()
        p_u_38:_UpdateBubbleContainer()
    end)
    p_u_38:_Setup()
    p_u_38:_UpdateMirrored()
    p_u_38:_UpdateBubble()
    p_u_38:_ResetBubbleVisibility()
    p_u_38:_UpdateBubbleContainer()
    p_u_38:Leave()
    v_u_4:Add(p_u_38.Frame.Button, true)
end
return v_u_6