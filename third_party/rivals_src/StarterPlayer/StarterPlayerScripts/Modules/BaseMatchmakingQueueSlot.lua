local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
require(v1.Modules.CONSTANTS)
local v_u_3 = require(v1.Modules.Utility)
local v_u_4 = require(v1.Modules.Signal)
local v_u_5 = require(v2.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect"))
local v_u_6 = Color3.fromRGB(200, 200, 200)
local v_u_7 = Color3.fromRGB(255, 255, 255)
local v_u_8 = {}
v_u_8.__index = v_u_8
function v_u_8.new(p9, p10, p11)
    local v12 = v_u_8
    local v13 = setmetatable({}, v12)
    v13.Clicked = v_u_4.new()
    v13.Frame = p9
    v13._destroyed = false
    v13._stroke_thickness = p10 or 4
    v13._always_bright = p11 or false
    v13._hover_hash = 0
    v13._tween_alpha = 0
    v13:_Init()
    return v13
end
function v_u_8.Set(p14, p15)
    if not p14._destroyed then
        local v16 = p14._always_bright and 1 or p15
        p14.Frame.Button.Thumbnail.ImageTransparency = 0.375 - 0.375 * v16
        p14.Frame.Button.Thumbnail.ImageColor3 = v_u_6:Lerp(v_u_7, v16)
        p14.Frame.Button.Stroke.Size = UDim2.new(1, 2 - p14._stroke_thickness * 2 * p15, 1, 2 - p14._stroke_thickness * 2 * p15)
        p14.Frame.Button.Stroke.UIStroke.Thickness = p14._stroke_thickness * p15
    end
end
function v_u_8.Tween(p_u_17, p18)
    if not p_u_17._destroyed then
        p_u_17._hover_hash = p_u_17._hover_hash + 1
        local v_u_19 = p_u_17._hover_hash
        v_u_3:RenderstepForLoop(p_u_17._tween_alpha, p18, 0.15 * (p18 < p_u_17._tween_alpha and -1 or 1), function(p20)
            if v_u_19 ~= p_u_17._hover_hash or p_u_17._destroyed then
                return true
            end
            p_u_17._tween_alpha = p20
            p_u_17:Set(1 - (1 - p_u_17._tween_alpha) ^ 3)
        end)
    end
end
function v_u_8.Destroy(p21)
    p21._destroyed = true
    p21.Clicked:Destroy()
    p21.Frame:Destroy()
end
function v_u_8._Init(p_u_22)
    p_u_22.Frame.Button.MouseLeave:Connect(function()
        p_u_22:Tween(0)
    end)
    p_u_22.Frame.Button.SelectionLost:Connect(function()
        p_u_22:Tween(0)
    end)
    p_u_22.Frame.Button.MouseEnter:Connect(function()
        p_u_22:Tween(1)
    end)
    p_u_22.Frame.Button.SelectionGained:Connect(function()
        p_u_22:Tween(1)
    end)
    p_u_22.Frame.Button.MouseButton1Click:Connect(function()
        p_u_22.Clicked:Fire()
    end)
    p_u_22:Set(0)
    v_u_5:Add(p_u_22.Frame.Button, nil, {
        ["ReleaseRatio"] = 0.975,
        ["HoverRatio"] = 0.975
    })
end
return v_u_8