local v1 = game:GetService("ReplicatedStorage")
game:GetService("HapticService")
local v_u_2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.Utility)
require(v_u_2.LocalPlayer.PlayerScripts.Controllers.ControlsController)
local v_u_4 = {}
v_u_4.__index = v_u_4
function v_u_4._new()
    local v5 = v_u_4
    local v6 = setmetatable({}, v5)
    v6:_Init()
    return v6
end
function v_u_4.ClickSound(_)
    v_u_3:CreateSound("rbxassetid://177266782", 0.5, 1, script, true, 4)
end
function v_u_4.Add(p_u_7, p8, p_u_9, p10)
    local v11 = typeof(p8) ~= "Instance" or p8:IsA("ImageButton") or (p8:IsA("TextButton") or p8:IsA("ClickDetector"))
    local v12 = "Argument 1 invalid, expected an ImageButton or TextButton or ClickDetector, got " .. tostring(p8)
    assert(v11, v12)
    local v13 = not p_u_9 or typeof(p_u_9) == "boolean"
    local v14 = "Argument 2 invalid, expected a boolean or nil, got " .. tostring(p_u_9)
    assert(v13, v14)
    local v15 = not p10 or typeof(p10) == "table"
    local v16 = "Argument 3 invalid, expected a table or nil, got " .. tostring(p10)
    assert(v15, v16)
    local v_u_17 = p10 and table.clone(p10) or {}
    v_u_17.Speed = v_u_17.Speed or 1
    v_u_17.PressRatio = v_u_17.PressRatio or 0.875
    v_u_17.HoverRatio = v_u_17.HoverRatio or 1.125
    v_u_17.ReleaseRatio = v_u_17.ReleaseRatio or 1.125
    v_u_17.TargetElement = v_u_17.TargetElement or p8
    v_u_17.OnRelease = v_u_17.OnRelease or nil
    v_u_17.OnHover = v_u_17.OnHover or nil
    v_u_17.DontReposition = v_u_17.DontReposition or nil
    local v_u_18 = v_u_17.TargetElement
    if not p8:IsA("ClickDetector") then
        local v_u_19 = nil
        local v_u_20 = nil
        local v_u_21 = nil
        local v_u_22 = nil
        local function v27(p23)
            v_u_19 = p23
            local v24 = v_u_17.PressRatio
            v_u_20 = typeof(v24) == "UDim2" and v_u_19 + v_u_17.PressRatio or UDim2.new(v_u_19.X.Scale * v_u_17.PressRatio, v_u_19.X.Offset * v_u_17.PressRatio, v_u_19.Y.Scale * v_u_17.PressRatio, v_u_19.Y.Offset * v_u_17.PressRatio)
            local v25 = v_u_17.HoverRatio
            v_u_21 = typeof(v25) == "UDim2" and v_u_19 + v_u_17.HoverRatio or UDim2.new(v_u_19.X.Scale * v_u_17.HoverRatio, v_u_19.X.Offset * v_u_17.HoverRatio, v_u_19.Y.Scale * v_u_17.HoverRatio, v_u_19.Y.Offset * v_u_17.HoverRatio)
            local v26 = v_u_17.ReleaseRatio
            v_u_22 = typeof(v26) == "UDim2" and v_u_19 + v_u_17.ReleaseRatio or UDim2.new(v_u_19.X.Scale * v_u_17.ReleaseRatio, v_u_19.X.Offset * v_u_17.ReleaseRatio, v_u_19.Y.Scale * v_u_17.ReleaseRatio, v_u_19.Y.Offset * v_u_17.ReleaseRatio)
        end
        v27(v_u_18.Size)
        local v_u_28 = false
        local function v29()
            v_u_28 = false
            if not p_u_9 then
                if v_u_18:IsDescendantOf(workspace) or v_u_18:IsDescendantOf(v_u_2) then
                    v_u_18.Size = v_u_22
                    v_u_18:TweenSize(v_u_19, "Out", "Back", 0.25, true)
                else
                    v_u_18.Size = v_u_19
                end
            end
            if v_u_17.OnRelease then
                v_u_17.OnRelease()
            end
        end
        p8.MouseButton1Up:Connect(v29)
        p8.MouseLeave:Connect(v29)
        p8.SelectionLost:Connect(v29)
        local function v30()
            if not p_u_9 then
                if v_u_18:IsDescendantOf(workspace) or v_u_18:IsDescendantOf(v_u_2) then
                    v_u_18:TweenSize(v_u_21, "Out", "Quint", 0.25, true)
                else
                    v_u_18.Size = v_u_21
                end
            end
            if v_u_17.OnHover then
                v_u_17.OnHover()
            end
        end
        p8.MouseEnter:Connect(v30)
        p8.SelectionGained:Connect(v30)
        local function v31()
            v_u_28 = true
            if not p_u_9 then
                if v_u_18:IsDescendantOf(workspace) or v_u_18:IsDescendantOf(v_u_2) then
                    v_u_18:TweenSize(v_u_20, "Out", "Quint", 0.25, true)
                else
                    v_u_18.Size = v_u_20
                end
            end
            p_u_7:ClickSound()
        end
        p8.MouseButton1Down:Connect(v31)
        if not (p_u_9 or v_u_17.DontReposition) then
            local v32 = 0.5 - v_u_18.AnchorPoint.X
            local v33 = 0.5 - v_u_18.AnchorPoint.Y
            v_u_18.Position = v_u_18.Position + UDim2.new(v_u_18.Size.X.Scale * v32, v_u_18.Size.X.Offset * v32, v_u_18.Size.Y.Scale * v33, v_u_18.Size.Y.Offset * v33)
            v_u_18.AnchorPoint = Vector2.new(0.5, 0.5)
        end
        return {
            ["UpdateOriginalSize"] = v27
        }
    end
    p8.MouseClick:Connect(function()
        p_u_7:ClickSound()
    end)
end
function v_u_4._Init(_) end
return v_u_4._new()