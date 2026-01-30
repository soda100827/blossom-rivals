local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.ItemLibrary)
local v_u_4 = require(v1.Modules.Utility)
local v_u_5 = v2.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("Crosshair")
local v_u_6 = {}
v_u_6.__index = v_u_6
function v_u_6.new()
    local v7 = v_u_6
    local v8 = setmetatable({}, v7)
    v8.Type = nil
    v8.Info = nil
    v8.Appearance = nil
    v8.Frame = v_u_5:Clone()
    v8._destroyed = false
    v8._visible = true
    v8._spacing = 16
    v8._spacing_multiplier = 1
    v8._transparency = 0
    v8._update_queued = false
    v8:_Init()
    return v8
end
function v_u_6.GetDisplayAppearance(p9)
    local v10
    if p9.Info.IsSpecial and not (p9.Appearance and p9.Appearance.Override) then
        v10 = nil
    else
        v10 = p9.Appearance or nil
    end
    return v10
end
function v_u_6.IsStatic(p11)
    local v12 = p11:GetDisplayAppearance()
    if v12 then
        return v12.IsStatic
    else
        return false
    end
end
function v_u_6.ShowWhileAiming(p13)
    local v14 = p13:GetDisplayAppearance()
    if v14 then
        return v14.ShowWhileAiming
    else
        return false
    end
end
function v_u_6.GetAppearanceSpacing(p15)
    local v16 = p15:GetDisplayAppearance()
    return v16 and v16.BarsSpacing or 16
end
function v_u_6.SetParent(p17, p18)
    p17.Frame.Parent = p18
end
function v_u_6.SetType(p19, p20, p21)
    p19.Type = p20
    p19.Info = v_u_3.Crosshairs[p19.Type]
    p19:_UpdateDeferred(p21)
end
function v_u_6.SetVisible(p22, p23, p24)
    if p23 ~= p22._visible then
        p22._visible = p23
        p22:_UpdateDeferred(p24)
    end
end
function v_u_6.SetSpacing(p25, p26, p27, p28)
    if p26 ~= p25._spacing or p27 ~= p25._spacing_multiplier then
        p25._spacing = p26 or p25._spacing
        p25._spacing_multiplier = p27 or p25._spacing_multiplier
        p25:_UpdateDeferred(p28)
    end
end
function v_u_6.SetTransparency(p29, p30, p31)
    if p30 ~= p29._transparency then
        p29._transparency = p30
        p29:_UpdateDeferred(p31)
    end
end
function v_u_6.SetAppearance(p32, p33, p34)
    p32.Appearance = p33
    p32:_UpdateDeferred(p34)
end
function v_u_6.Destroy(p35)
    if not p35._destroyed then
        p35._destroyed = true
        pcall(p35.Frame.Destroy, p35.Frame)
    end
end
function v_u_6._UpdateDeferred(p_u_36, ...)
    if p_u_36._update_queued then
        task.cancel(p_u_36._update_queued)
        p_u_36._update_queued = nil
    end
    p_u_36._update_queued = task.defer(function(...)
        p_u_36._update_queued = nil
        p_u_36:_Update(...)
    end, ...)
end
function v_u_6._Update(p37, p38)
    if p37._destroyed or p38 then
        return
    else
        local v39 = p37.Frame
        local v40 = p37._visible
        if v40 then
            v40 = not p37.Appearance and true or not p37.Appearance.IsDisabled
        end
        v39.Visible = v40
        if p37.Frame.Visible then
            local v41 = p37:GetDisplayAppearance()
            local v42 = v41 and (v41.Rotation or 0) or 0
            local v43 = v41 and (v41.Scale or 1) or 1
            p37.Frame.Rotation = v42
            p37.Frame.UIScale.Scale = v43
            local v44 = p37.Info.IsSpecial and (p37.Appearance and p37.Appearance.Override) and v_u_3.Crosshairs.Default or p37.Info
            p37.Frame.Foreground.Dot.Image = v44.DotImage
            p37.Frame.Foreground.Right.Image = v44.RightBarImage
            p37.Frame.Foreground.Left.Image = v44.LeftBarImage
            p37.Frame.Foreground.Down.Image = v44.BottomBarImage
            p37.Frame.Foreground.Up.Image = v44.TopBarImage
            p37.Frame.Background.Dot.Image = p37.Frame.Foreground.Dot.Image
            p37.Frame.Background.Right.Image = p37.Frame.Foreground.Right.Image
            p37.Frame.Background.Left.Image = p37.Frame.Foreground.Left.Image
            p37.Frame.Background.Down.Image = p37.Frame.Foreground.Down.Image
            p37.Frame.Background.Up.Image = p37.Frame.Foreground.Up.Image
            local v45 = not v41 and true or not v41.DotDisabled
            local v46 = not v41 and true or not v41.BarsDisabled
            local v47 = not v41 and true or not v41.BarsTopDisabled
            local v48 = not v41 and true or not v41.BarsBottomDisabled
            local v49 = not v41 and true or not v41.BarsRightDisabled
            local v50 = not v41 and true or not v41.BarsLeftDisabled
            local v51 = not v41 and true or not v41.CircleDisabled
            p37.Frame.Foreground.Dot.Visible = v44.DotEnabled and v45
            local v52 = p37.Frame.Foreground.Right
            local v53 = v44.BarsEnabled
            if v53 then
                if not v46 then
                    v49 = v46
                end
            else
                v49 = v53
            end
            v52.Visible = v49
            local v54 = p37.Frame.Foreground.Left
            local v55 = v44.BarsEnabled
            if v55 then
                if not v46 then
                    v50 = v46
                end
            else
                v50 = v55
            end
            v54.Visible = v50
            local v56 = p37.Frame.Foreground.Down
            local v57 = v44.BarsEnabled
            if v57 then
                if not v46 then
                    v48 = v46
                end
            else
                v48 = v57
            end
            v56.Visible = v48
            local v58 = p37.Frame.Foreground.Up
            local v59 = v44.BarsEnabled
            if v59 then
                if not v46 then
                    v47 = v46
                end
            else
                v47 = v59
            end
            v58.Visible = v47
            p37.Frame.Foreground.Circle.Visible = v44.CircleEnabled and v51
            p37.Frame.Background.Dot.Visible = p37.Frame.Foreground.Dot.Visible
            p37.Frame.Background.Right.Visible = p37.Frame.Foreground.Right.Visible
            p37.Frame.Background.Left.Visible = p37.Frame.Foreground.Left.Visible
            p37.Frame.Background.Down.Visible = p37.Frame.Foreground.Down.Visible
            p37.Frame.Background.Up.Visible = p37.Frame.Foreground.Up.Visible
            p37.Frame.Background.Circle.Visible = p37.Frame.Foreground.Circle.Visible
            local v60
            if v41 then
                v60 = v41.IsStatic
            else
                v60 = false
            end
            local v61 = (v60 and p37:GetAppearanceSpacing() or p37._spacing) * p37._spacing_multiplier
            p37.Frame.Foreground.Right.Position = UDim2.new(0.5, v61, 0.5, 0)
            p37.Frame.Foreground.Left.Position = UDim2.new(0.5, -v61, 0.5, 0)
            p37.Frame.Foreground.Down.Position = UDim2.new(0.5, 0, 0.5, v61)
            p37.Frame.Foreground.Up.Position = UDim2.new(0.5, 0, 0.5, -v61)
            p37.Frame.Background.Right.Position = p37.Frame.Foreground.Right.Position
            p37.Frame.Background.Left.Position = p37.Frame.Foreground.Left.Position
            p37.Frame.Background.Down.Position = p37.Frame.Foreground.Down.Position
            p37.Frame.Background.Up.Position = p37.Frame.Foreground.Up.Position
            local v62 = v41 and (v41.DotTransparency or 0) or 0
            local v63 = v62 + (1 - v62) * p37._transparency
            local v64 = v41 and (v41.BarsTransparency or 0) or 0
            local v65 = v64 + (1 - v64) * p37._transparency
            local v66 = v41 and (v41.CircleTransparency or 0) or 0
            local v67 = v66 + (1 - v66) * p37._transparency
            p37.Frame.Foreground.Dot.ImageTransparency = v63
            p37.Frame.Foreground.Right.ImageTransparency = v65
            p37.Frame.Foreground.Left.ImageTransparency = v65
            p37.Frame.Foreground.Down.ImageTransparency = v65
            p37.Frame.Foreground.Up.ImageTransparency = v65
            p37.Frame.Foreground.Circle.UIStroke.Transparency = v67
            p37.Frame.Background.Dot.ImageTransparency = p37.Frame.Foreground.Dot.ImageTransparency
            p37.Frame.Background.Right.ImageTransparency = p37.Frame.Foreground.Right.ImageTransparency
            p37.Frame.Background.Left.ImageTransparency = p37.Frame.Foreground.Left.ImageTransparency
            p37.Frame.Background.Down.ImageTransparency = p37.Frame.Foreground.Down.ImageTransparency
            p37.Frame.Background.Up.ImageTransparency = p37.Frame.Foreground.Up.ImageTransparency
            local v68 = v41 and (v41.DotThickness or 2) or 2
            local v69 = v41 and (v41.BarsLength or 6) or 6
            local v70 = v41 and (v41.BarsThickness or 2) or 2
            local v71 = v41 and (v41.CircleSize or 16) or 16
            local v72 = v41 and (v41.CircleThickness or 2) or 2
            p37.Frame.Foreground.Dot.Size = v44.DotSize or UDim2.new(0, v68, 0, v68)
            p37.Frame.Foreground.Right.Size = v44.RightBarSize or UDim2.new(0, v69, 0, v70)
            p37.Frame.Foreground.Left.Size = v44.LeftBarSize or UDim2.new(0, v69, 0, v70)
            p37.Frame.Foreground.Down.Size = v44.BottomBarSize or UDim2.new(0, v70, 0, v69)
            p37.Frame.Foreground.Up.Size = v44.TopBarSize or UDim2.new(0, v70, 0, v69)
            p37.Frame.Foreground.Circle.Size = v44.CircleSize or UDim2.new(0, v71, 0, v71)
            p37.Frame.Foreground.Circle.UIStroke.Thickness = v44.CircleThickness or v72
            p37.Frame.Background.Dot.Size = p37.Frame.Foreground.Dot.Size
            p37.Frame.Background.Right.Size = p37.Frame.Foreground.Right.Size
            p37.Frame.Background.Left.Size = p37.Frame.Foreground.Left.Size
            p37.Frame.Background.Down.Size = p37.Frame.Foreground.Down.Size
            p37.Frame.Background.Up.Size = p37.Frame.Foreground.Up.Size
            local v73 = not v41 and true or not v41.OutlineDisabled
            p37.Frame.Background.Circle.UIStroke.Enabled = v73
            p37.Frame.Background.Dot.UIStroke.Enabled = v73
            p37.Frame.Background.Right.UIStroke.Enabled = v73
            p37.Frame.Background.Left.UIStroke.Enabled = v73
            p37.Frame.Background.Down.UIStroke.Enabled = v73
            p37.Frame.Background.Up.UIStroke.Enabled = v73
            if v73 then
                local v74 = v41 and (v41.OutlineTransparency or 0) or 0
                local v75 = v74 + (1 - v74) * p37._transparency
                p37.Frame.Background.Dot.UIStroke.Transparency = v75
                p37.Frame.Background.Right.UIStroke.Transparency = v75
                p37.Frame.Background.Left.UIStroke.Transparency = v75
                p37.Frame.Background.Down.UIStroke.Transparency = v75
                p37.Frame.Background.Up.UIStroke.Transparency = v75
                p37.Frame.Background.Circle.UIStroke.Transparency = v75
                local v76 = v41 and (v41.OutlineThickness or 0) or 0
                local _ = v76 * 2 + v72
                p37.Frame.Background.Dot.UIStroke.Thickness = v76
                p37.Frame.Background.Right.UIStroke.Thickness = v76
                p37.Frame.Background.Left.UIStroke.Thickness = v76
                p37.Frame.Background.Down.UIStroke.Thickness = v76
                p37.Frame.Background.Up.UIStroke.Thickness = v76
                p37.Frame.Background.Circle.UIStroke.Thickness = v76 * 2 + v72
                local v77 = p37.Frame.Background.Circle
                local v78 = UDim2.new
                local v79 = p37.Frame.Foreground.Circle.Size.X.Offset - v76 * 2
                local v80 = math.max(0, v79)
                local v81 = p37.Frame.Foreground.Circle.Size.Y.Offset - v76 * 2
                v77.Size = v78(0, v80, 0, (math.max(0, v81)))
                local v82 = Enum.LineJoinMode[v41 and (v41.OutlineType or "Miter") or "Miter"]
                p37.Frame.Background.Dot.UIStroke.LineJoinMode = v82
                p37.Frame.Background.Right.UIStroke.LineJoinMode = v82
                p37.Frame.Background.Left.UIStroke.LineJoinMode = v82
                p37.Frame.Background.Down.UIStroke.LineJoinMode = v82
                p37.Frame.Background.Up.UIStroke.LineJoinMode = v82
            end
            local v83 = v_u_4:Color3FromHex(v41 and (v41.DotColor or "#ffffff") or "#ffffff")
            local v84 = v_u_4:Color3FromHex(v41 and (v41.BarsColor or "#ffffff") or "#ffffff")
            local v85 = v_u_4:Color3FromHex(v41 and (v41.CircleColor or "#ffffff") or "#ffffff")
            p37.Frame.Foreground.Dot.ImageColor3 = v83
            p37.Frame.Foreground.Right.ImageColor3 = v84
            p37.Frame.Foreground.Left.ImageColor3 = v84
            p37.Frame.Foreground.Down.ImageColor3 = v84
            p37.Frame.Foreground.Up.ImageColor3 = v84
            p37.Frame.Foreground.Circle.UIStroke.Color = v85
            p37.Frame.Background.Dot.ImageColor3 = p37.Frame.Foreground.Dot.ImageColor3
            p37.Frame.Background.Right.ImageColor3 = p37.Frame.Foreground.Right.ImageColor3
            p37.Frame.Background.Left.ImageColor3 = p37.Frame.Foreground.Left.ImageColor3
            p37.Frame.Background.Down.ImageColor3 = p37.Frame.Foreground.Down.ImageColor3
            p37.Frame.Background.Up.ImageColor3 = p37.Frame.Foreground.Up.ImageColor3
            local v86 = v_u_4:Color3FromHex(v41 and (v41.OutlineColor or "#000000") or "#000000")
            p37.Frame.Background.Dot.UIStroke.Color = v86
            p37.Frame.Background.Right.UIStroke.Color = v86
            p37.Frame.Background.Left.UIStroke.Color = v86
            p37.Frame.Background.Down.UIStroke.Color = v86
            p37.Frame.Background.Up.UIStroke.Color = v86
            p37.Frame.Background.Circle.UIStroke.Color = v86
            local v87 = v41 and (v41.BarsShape or "Sharp") or "Sharp"
            local v88 = v41 and (v41.DotShape or "Sharp") or "Sharp"
            local v89 = v41 and v41.CircleShape or "Circle"
            p37.Frame.Foreground.Dot.UICorner.CornerRadius = v88 == "Round" and UDim.new(1, 0) or UDim.new(0, 0)
            p37.Frame.Foreground.Right.UICorner.CornerRadius = v87 == "Round" and UDim.new(1, 0) or UDim.new(0, 0)
            p37.Frame.Foreground.Left.UICorner.CornerRadius = v87 == "Round" and UDim.new(1, 0) or UDim.new(0, 0)
            p37.Frame.Foreground.Down.UICorner.CornerRadius = v87 == "Round" and UDim.new(1, 0) or UDim.new(0, 0)
            p37.Frame.Foreground.Up.UICorner.CornerRadius = v87 == "Round" and UDim.new(1, 0) or UDim.new(0, 0)
            p37.Frame.Foreground.Circle.UICorner.CornerRadius = v89 == "Circle" and UDim.new(1, 0) or (v89 == "Round" and UDim.new(0.25, 0) or UDim.new(0, 0))
            p37.Frame.Background.Dot.UICorner.CornerRadius = p37.Frame.Foreground.Dot.UICorner.CornerRadius
            p37.Frame.Background.Right.UICorner.CornerRadius = p37.Frame.Foreground.Right.UICorner.CornerRadius
            p37.Frame.Background.Left.UICorner.CornerRadius = p37.Frame.Foreground.Left.UICorner.CornerRadius
            p37.Frame.Background.Down.UICorner.CornerRadius = p37.Frame.Foreground.Down.UICorner.CornerRadius
            p37.Frame.Background.Up.UICorner.CornerRadius = p37.Frame.Foreground.Up.UICorner.CornerRadius
            p37.Frame.Background.Circle.UICorner.CornerRadius = p37.Frame.Foreground.Circle.UICorner.CornerRadius
        end
    end
end
function v_u_6._Setup(p90)
    p90.Frame.Visible = false
end
function v_u_6._Init(p_u_91)
    p_u_91.Frame.Destroying:Connect(function()
        p_u_91:Destroy()
    end)
    p_u_91:_Setup()
    p_u_91:SetType("Default", true)
    p_u_91:SetSpacing(16, 1, true)
    p_u_91:SetTransparency(0, true)
    p_u_91:SetVisible(true, true)
    p_u_91:SetAppearance(nil, true)
    p_u_91:_Update()
end
return v_u_6