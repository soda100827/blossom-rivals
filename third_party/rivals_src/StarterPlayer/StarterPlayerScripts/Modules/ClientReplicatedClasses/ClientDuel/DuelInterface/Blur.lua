local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("Lighting")
local v_u_3 = require(v1.Modules.Utility)
local v_u_4 = Color3.fromRGB(255, 255, 255)
local v_u_5 = Color3.fromRGB(220, 220, 220)
local v_u_6 = {}
v_u_6.__index = v_u_6
function v_u_6.new(p7)
    local v8 = v_u_6
    local v9 = setmetatable({}, v8)
    v9.DuelInterface = p7
    v9._blur = Instance.new("BlurEffect")
    v9._colorcorrection = Instance.new("ColorCorrectionEffect")
    v9._last_blur_enabled = nil
    v9._last_cc_enabled = nil
    v9._tween_hash = 0
    v9:_Init()
    return v9
end
function v_u_6.Update(p10)
    local v11 = p10.DuelInterface:IsActive() and v_u_2 or nil
    p10._blur.Parent = v11
    p10._colorcorrection.Parent = v11
end
function v_u_6.Destroy(p12)
    p12._blur:Destroy()
    p12._colorcorrection:Destroy()
    p12._tween_hash = p12._tween_hash + 1
end
function v_u_6._Tween(p_u_13, p14, p15)
    local v16
    if p14 then
        v16 = not p_u_13.DuelInterface.Voting:IsOpen()
    else
        v16 = p14
    end
    if p14 ~= p_u_13._last_blur_enabled or v16 ~= p_u_13._last_cc_enabled then
        p_u_13._tween_last = p14
        p_u_13._tween_hash = p_u_13._tween_hash + 1
        local v_u_17 = p_u_13._tween_hash
        local v_u_18 = p_u_13._blur.Size
        local v_u_19 = p_u_13._colorcorrection.Brightness
        local v_u_20 = p_u_13._colorcorrection.TintColor
        local v_u_21 = p14 and 24 or 0
        local v_u_22 = v16 and -0.1 or 0
        local v_u_23 = v16 and v_u_5 or v_u_4
        task.spawn(v_u_3.RenderstepForLoop, v_u_3, 0, 100, p15 and 100 or 4, function(p24)
            if v_u_17 ~= p_u_13._tween_hash then
                return true
            end
            local v25 = 1 - (1 - p24 / 100) ^ 3
            p_u_13._blur.Size = v_u_18 + (v_u_21 - v_u_18) * v25
            p_u_13._colorcorrection.Brightness = v_u_19 + (v_u_22 - v_u_19) * v25
            p_u_13._colorcorrection.TintColor = v_u_20:Lerp(v_u_23, v25)
        end)
    end
end
function v_u_6._UpdateLighting(p26)
    p26:_Tween(p26.DuelInterface.Frame.Visible and (p26.DuelInterface.Scoreboard:IsOpen() or (p26.DuelInterface.FinalResults.CurrentPage == "Summary" and true or p26.DuelInterface.Voting:IsOpen())))
end
function v_u_6._Setup(p27)
    p27._blur.Name = "DuelInterface"
    p27._colorcorrection.Name = "DuelInterface"
end
function v_u_6._Init(p_u_28)
    p_u_28.DuelInterface.Frame:GetPropertyChangedSignal("Visible"):Connect(function()
        p_u_28:_UpdateLighting()
    end)
    p_u_28.DuelInterface.Scoreboard.VisibilityChanged:Connect(function()
        p_u_28:_UpdateLighting()
    end)
    p_u_28.DuelInterface.FinalResults.PageChanged:Connect(function()
        p_u_28:_UpdateLighting()
    end)
    p_u_28.DuelInterface.Voting.VisibilityChanged:Connect(function()
        p_u_28:_UpdateLighting()
    end)
    p_u_28:_Setup()
    task.defer(p_u_28._Tween, p_u_28, false, true)
end
return v_u_6