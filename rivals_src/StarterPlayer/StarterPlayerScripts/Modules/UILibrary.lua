local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("UserInputService")
local v_u_3 = game:GetService("GuiService")
local v_u_4 = game:GetService("Players")
local v_u_5 = require(v1.Modules.Utility)
local v_u_6 = v_u_4.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("Pages")
local v_u_7 = {}
v_u_7.__index = v_u_7
function v_u_7._new()
    local v8 = v_u_7
    local v9 = setmetatable({}, v8)
    v9.BUTTON_BACKGROUND_TRANSPARENCY = 0.08
    v9.BUTTON_BACKGROUND_COLOR = Color3.fromRGB(18, 18, 21)
    v9.BUTTON_ICON_COLOR = Color3.fromRGB(247, 247, 248)
    v9.PlayerGui = v_u_4.LocalPlayer:WaitForChild("PlayerGui")
    v9.MainGui = v9.PlayerGui:WaitForChild("MainGui")
    v9:_Init()
    return v9
end
function v_u_7.GetMouseLocation(_)
    return v_u_2:GetMouseLocation() - Vector2.new(0, v_u_3.TopbarInset.Height)
end
function v_u_7.GetMouseLocationCentered(_)
    return workspace.CurrentCamera.ViewportSize / 2 - Vector2.new(0, v_u_3.TopbarInset.Height)
end
function v_u_7.ScreenPointToPosition(p10, p11, p12)
    local v13 = p12 or p10.MainGui.AbsolutePosition
    return Vector2.new(p11.X - v13.X, p11.Y - v13.Y)
end
function v_u_7.IsMouseWithinBounds(p14, p15, p16)
    local v17 = p14:GetMouseLocation()
    local v18
    if v17.X > p15.X and (v17.X < p15.X + p16.X and v17.Y > p15.Y) then
        v18 = v17.Y < p15.Y + p16.Y
    else
        v18 = false
    end
    return v18
end
function v_u_7.GetTo(p19, ...)
    return v_u_5:WaitForChild(p19.MainGui, ...)
end
function v_u_7.GetPage(_, p20)
    local v21 = typeof(p20) == "string"
    local v22 = "Argument 1 invalid, expected a string, got " .. tostring(p20)
    assert(v21, v22)
    return v_u_6:WaitForChild(p20)
end
function v_u_7.ScrollingTextLabel(p_u_23, p_u_24, p_u_25, p_u_26)
    local function v27()
        p_u_24.Size = UDim2.new(0, p_u_26.AbsolutePosition.X + p_u_26.AbsoluteSize.X - p_u_26.TextBounds.X - p_u_26.AbsoluteSize.Y * 0.5 - p_u_24.AbsolutePosition.X, 0.625, 0)
    end
    p_u_24:GetPropertyChangedSignal("AbsolutePosition"):Connect(v27)
    p_u_26:GetPropertyChangedSignal("AbsolutePosition"):Connect(v27)
    p_u_26:GetPropertyChangedSignal("AbsoluteSize"):Connect(v27)
    p_u_26:GetPropertyChangedSignal("TextBounds"):Connect(v27)
    p_u_24.Size = UDim2.new(0, p_u_26.AbsolutePosition.X + p_u_26.AbsoluteSize.X - p_u_26.TextBounds.X - p_u_26.AbsoluteSize.Y * 0.5 - p_u_24.AbsolutePosition.X, 0.625, 0)
    local v_u_28 = nil
    local v_u_29 = 0
    local function v_u_37(p_u_30)
        task.defer(function()
            if tick() < v_u_29 then
                return
            end
            if not p_u_24:IsDescendantOf(v_u_4.LocalPlayer.PlayerGui) then
                v_u_28 = nil
                return
            end
            local v31 = p_u_25.TextBounds.X - p_u_24.AbsoluteSize.X
            if v31 <= 0 then
                ::l6::
            else
                if v_u_28 then
                    local v32 = v31 - v_u_28
                    if math.abs(v32) < 0.1 then
                        goto l6
                    end
                end
                local v33 = v31 / p_u_23.MainGui.AbsoluteSize.X * 50
                local v34 = UDim2.new(0, 0, 0.5, 0)
                local v35 = UDim2.new(0, -v31, 0.5, 0)
                v_u_29 = tick() + 1
                v_u_28 = v31
                p_u_25.Position = p_u_30 and v35 and v35 or v34
                local v36 = p_u_25
                if p_u_30 then
                    v35 = v34 or v35
                end
                v36:TweenPosition(v35, "InOut", "Linear", v33, true, function()
                    v_u_28 = nil
                    task.delay(1, v_u_37, not p_u_30)
                end)
            end
        end)
    end
    p_u_24.AncestryChanged:Connect(v_u_37)
    p_u_24:GetPropertyChangedSignal("AbsoluteSize"):Connect(v_u_37)
    p_u_25:GetPropertyChangedSignal("TextBounds"):Connect(v_u_37)
    local v_u_38 = nil
    task.defer(function()
        if tick() < v_u_29 then
            return
        end
        if not p_u_24:IsDescendantOf(v_u_4.LocalPlayer.PlayerGui) then
            v_u_28 = nil
            return
        end
        local v39 = p_u_25.TextBounds.X - p_u_24.AbsoluteSize.X
        if v39 <= 0 then
            ::l6::
        else
            if v_u_28 then
                local v40 = v39 - v_u_28
                if math.abs(v40) < 0.1 then
                    goto l6
                end
            end
            local v41 = v39 / p_u_23.MainGui.AbsoluteSize.X * 50
            local v42 = UDim2.new(0, 0, 0.5, 0)
            local v43 = UDim2.new(0, -v39, 0.5, 0)
            v_u_29 = tick() + 1
            v_u_28 = v39
            p_u_25.Position = v_u_38 and v43 and v43 or v42
            local v44 = p_u_25
            if v_u_38 then
                v43 = v42 or v43
            end
            v44:TweenPosition(v43, "InOut", "Linear", v41, true, function()
                v_u_28 = nil
                task.delay(1, v_u_37, not v_u_38)
            end)
        end
    end)
end
function v_u_7._Init(_) end
return v_u_7._new()