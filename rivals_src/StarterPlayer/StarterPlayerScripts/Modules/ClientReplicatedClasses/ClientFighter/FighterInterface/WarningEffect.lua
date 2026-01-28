local v_u_1 = game:GetService("TweenService")
game:GetService("Players")
local v_u_2 = {}
v_u_2.__index = v_u_2
function v_u_2.new(p3)
    local v4 = v_u_2
    local v5 = setmetatable({}, v4)
    v5.FighterInterface = p3
    v5.WarningVignette = v5.FighterInterface.Frame:WaitForChild("WarningVignette")
    v5.WarningVignetteTexture = v5.WarningVignette:WaitForChild("Texture")
    v5.WarningVignetteContainer = v5.WarningVignette:WaitForChild("Container")
    v5.WarningVignetteContainerBackground = v5.WarningVignetteContainer:WaitForChild("Frame"):WaitForChild("Container"):WaitForChild("Background")
    v5._connections = {}
    v5._warning_effect_tweens = {}
    v5:_Init()
    return v5
end
function v_u_2.SetEnabled(p_u_6, p7, p8)
    p_u_6:_Cleanup()
    p_u_6.WarningVignette.ImageTransparency = 1
    p_u_6.WarningVignette.ImageColor3 = Color3.fromRGB(255, 215, 0)
    p_u_6.WarningVignetteTexture.ImageTransparency = 1
    p_u_6.WarningVignetteContainer.Visible = false
    p_u_6.WarningVignetteContainerBackground.ImageColor3 = Color3.fromRGB(255, 215, 0)
    if p7 and p8 < (1 / 0) then
        local v9 = TweenInfo.new(p8 / 2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)
        local v10 = TweenInfo.new(p8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
        local v11 = v_u_1:Create(p_u_6.WarningVignette, v9, {
            ["ImageTransparency"] = 0
        })
        v11:Play()
        local v12 = p_u_6._warning_effect_tweens
        table.insert(v12, v11)
        local v13 = v_u_1:Create(p_u_6.WarningVignette, v10, {
            ["ImageColor3"] = Color3.fromRGB(255, 50, 50)
        })
        v13:Play()
        local v14 = p_u_6._warning_effect_tweens
        table.insert(v14, v13)
        local v15 = v_u_1:Create(p_u_6.WarningVignetteTexture, v9, {
            ["ImageTransparency"] = 0
        })
        v15:Play()
        local v16 = p_u_6._warning_effect_tweens
        table.insert(v16, v15)
        local v17 = v_u_1:Create(p_u_6.WarningVignetteContainerBackground, v10, {
            ["ImageColor3"] = Color3.fromRGB(255, 50, 50)
        })
        v17:Play()
        local v18 = p_u_6._warning_effect_tweens
        table.insert(v18, v17)
        local v_u_19 = task.spawn(function()
            tick()
            while true do
                p_u_6.FighterInterface:CreateSound("rbxassetid://114467311328776", 0.5, 1, script, true, 10)
                p_u_6.WarningVignette.Container.Visible = true
                wait(0.4)
                p_u_6.WarningVignette.Container.Visible = false
                wait(0.15)
            end
        end)
        local v20 = p_u_6._warning_effect_tweens
        table.insert(v20, {
            ["Cancel"] = function()
                task.cancel(v_u_19)
            end
        })
    end
end
function v_u_2.Destroy(p21)
    for _, v22 in pairs(p21._connections) do
        v22:Disconnect()
    end
    p21._connections = {}
    p21:_Cleanup()
end
function v_u_2._Cleanup(p23)
    for _, v24 in pairs(p23._warning_effect_tweens) do
        v24:Cancel()
    end
    p23._warning_effect_tweens = {}
end
function v_u_2._Init(_) end
return v_u_2