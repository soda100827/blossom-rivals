local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("TweenService")
local v3 = game:GetService("Players")
local v_u_4 = require(v1.Modules.CosmeticLibrary)
local v_u_5 = require(v3.LocalPlayer.PlayerScripts.Modules.EmoteViewportFrame)
local v_u_6 = v3.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("EmoteWheelSlot")
local v_u_7 = TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local v_u_8 = TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
local v_u_9 = {}
v_u_9.__index = v_u_9
function v_u_9.new(p10)
    local v11 = v_u_9
    local v12 = setmetatable({}, v11)
    v12.EquippedData = p10
    local v13 = v12.EquippedData
    if v13 then
        v13 = v12.EquippedData.Name
    end
    v12.Name = v13
    v12.Frame = v_u_6:Clone()
    local v14 = v12.Name
    if v14 then
        v14 = v_u_5.new(v12.Name, 4)
    end
    v12._emote_viewport_frame = v14
    v12._is_highlighted = nil
    v12._background = v12.Frame.Background
    v12._highlight = v12._background.Highlight
    v12._container = v12.Frame.Container
    v12._title = v12._container.Title
    v12._title_stroke = v12._title.UIStroke
    v12._highlight_tweens = {}
    v12._equip_bounce_effect_ui_scale = Instance.new("UIScale")
    v12:_Init()
    return v12
end
function v_u_9.GetContainerPosition(p15)
    return p15._container.AbsolutePosition + p15._container.AbsoluteSize / 2
end
function v_u_9.SetHighlighted(p16, p17)
    if p16._is_highlighted ~= p17 then
        for _, v18 in pairs(p16._highlight_tweens) do
            v18:Pause()
            v18:Destroy()
        end
        p16._highlight_tweens = {}
        p16._is_highlighted = p17
        p16.Frame.ZIndex = p17 and 1 or 0
        local v19 = v_u_2:Create(p16.Frame, v_u_8, {
            ["Size"] = p16._is_highlighted and UDim2.new(1.1, 0, 1.1, 0) or UDim2.new(1, 0, 1, 0)
        })
        v19:Play()
        local v20 = p16._highlight_tweens
        table.insert(v20, v19)
        local v21 = v_u_2:Create(p16._highlight, v_u_8, {
            ["ImageTransparency"] = p16._is_highlighted and 0 or 1
        })
        v21:Play()
        local v22 = p16._highlight_tweens
        table.insert(v22, v21)
        local v23 = v_u_2:Create(p16._title, v_u_8, {
            ["Size"] = p16._is_highlighted and UDim2.new(3, 0, 0.25, 0) or UDim2.new(3, 0, 0.175, 0),
            ["TextTransparency"] = p16._is_highlighted and 0 or 0.5
        })
        v23:Play()
        local v24 = p16._highlight_tweens
        table.insert(v24, v23)
        local v25 = v_u_2:Create(p16._title_stroke, v_u_8, {
            ["Transparency"] = p16._is_highlighted and 0.75 or 0.875
        })
        v25:Play()
        local v26 = p16._highlight_tweens
        table.insert(v26, v25)
        if p16._emote_viewport_frame then
            local v27 = v_u_2:Create(p16._emote_viewport_frame.Frame, v_u_8, {
                ["Size"] = p16._is_highlighted and UDim2.new(1.375, 0, 1.375, 0) or UDim2.new(1, 0, 1, 0)
            })
            v27:Play()
            local v28 = p16._highlight_tweens
            table.insert(v28, v27)
        end
    end
end
function v_u_9.SetRotation(p29, p30)
    p29.Frame.Rotation = p30
    p29._container.Rotation = -p30
end
function v_u_9.EquipBounceEffect(p31)
    p31._equip_bounce_effect_ui_scale.Scale = 1.25
    v_u_2:Create(p31._equip_bounce_effect_ui_scale, v_u_7, {
        ["Scale"] = 1
    }):Play()
end
function v_u_9.Destroy(p32)
    if p32._emote_viewport_frame then
        p32._emote_viewport_frame:Destroy()
    end
    p32.Frame:Destroy()
end
function v_u_9._Setup(p33)
    if p33._emote_viewport_frame then
        p33._emote_viewport_frame:SetParent(p33._container)
    end
    p33._background.ImageTransparency = p33.Name and 0.25 or 0.5
    p33._title.Text = p33.Name or ""
    p33._highlight.ImageColor3 = not p33.Name and Color3.fromRGB(0, 0, 0) or v_u_4.Rarities[v_u_4.Cosmetics[p33.Name].Rarity].Color
    p33._equip_bounce_effect_ui_scale.Parent = p33.Frame
end
function v_u_9._Init(p34)
    p34:_Setup()
    p34:SetHighlighted(false)
end
return v_u_9