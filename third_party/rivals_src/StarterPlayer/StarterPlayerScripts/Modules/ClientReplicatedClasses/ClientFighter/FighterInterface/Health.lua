local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("TweenService")
local v_u_3 = game:GetService("GuiService")
local v_u_4 = require(v1.Modules.Utility)
local v_u_5 = {}
v_u_5.__index = v_u_5
function v_u_5.new(p6)
    local v7 = v_u_5
    local v8 = setmetatable({}, v7)
    v8.FighterInterface = p6
    v8.DamageVignette = v8.FighterInterface.Frame:WaitForChild("DamageVignette")
    v8.DamageVignettePermanent = v8.DamageVignette:WaitForChild("Permanent")
    v8.HealVignette = v8.FighterInterface.Frame:WaitForChild("HealVignette")
    v8.Frame = v8.FighterInterface.Frame:WaitForChild("Health")
    v8.ContainerFrame = v8.Frame:WaitForChild("Container"):WaitForChild("Health")
    v8.ContainerUIStroke = v8.ContainerFrame:WaitForChild("UIStroke")
    v8.ContainerBar = v8.ContainerFrame:WaitForChild("Bar")
    v8.ContainerBarUIStroke = v8.ContainerBar:WaitForChild("UIStroke")
    v8.ContainerBarText = v8.ContainerBar:WaitForChild("Value"):WaitForChild("Title")
    v8._last_health_tween = nil
    v8._last_health_alpha = nil
    v8._hurt_effect_hash = 0
    v8._heal_effect_hash = 0
    v8:_Init()
    return v8
end
function v_u_5.SetVisible(p9, p10)
    p9.Frame.Visible = p10
    p9:Refresh()
end
function v_u_5.HurtEffect(p_u_11, p_u_12)
    if p_u_11.FighterInterface:IsActive() then
        local v13 = p_u_12[utf8.char(0)] / p_u_11.FighterInterface.ClientFighter.Entity.Humanoid.Health
        if v13 ~= 0 then
            task.spawn(function()
                p_u_11.FighterInterface.DamageIndicators:Create(p_u_12)
            end)
            p_u_11._hurt_effect_hash = p_u_11._hurt_effect_hash + 1
            local v_u_14 = p_u_11._hurt_effect_hash
            local v_u_15 = 0.5 - 0.5 * v13
            task.spawn(v_u_4.RenderstepForLoop, v_u_4, 0, 100, 4, function(p16)
                if v_u_14 ~= p_u_11._hurt_effect_hash then
                    return true
                end
                local v17 = p16 / 100
                p_u_11.DamageVignette.ImageTransparency = v_u_15 + (1 - v_u_15) * v17
            end)
        end
    else
        return
    end
end
function v_u_5.HealEffect(p_u_18, p19)
    if p_u_18.FighterInterface:IsActive() then
        p_u_18._heal_effect_hash = p_u_18._heal_effect_hash + 1
        local v_u_20 = p_u_18._heal_effect_hash
        local v21 = p19 / 10
        local v22 = math.clamp(v21, 0, 1)
        p_u_18.FighterInterface:CreateSound("rbxassetid://17138490999", v22 * 0.5, 1, script, true, 10)
        local v_u_23 = 1 - v22 * 1
        task.spawn(v_u_4.RenderstepForLoop, v_u_4, 0, 100, 4, function(p24)
            if v_u_20 ~= p_u_18._heal_effect_hash then
                return true
            end
            local v25 = p24 / 100
            p_u_18.HealVignette.ImageTransparency = v_u_23 + (1 - v_u_23) * v25
        end)
    end
end
function v_u_5.Refresh(p26)
    if p26.Frame.Visible then
        p26:_Update()
    else
        p26.DamageVignettePermanent.ImageTransparency = 1
    end
end
function v_u_5.Destroy(p27)
    p27._hurt_effect_hash = p27._hurt_effect_hash + 1
    p27._heal_effect_hash = p27._heal_effect_hash + 1
end
function v_u_5._Update(p28, p29)
    if p28._last_health_tween then
        p28._last_health_tween:Pause()
        p28._last_health_tween = nil
    end
    local v30 = p28.FighterInterface.ClientFighter:Get("IsAprilFools")
    local v31 = p28.FighterInterface.ClientFighter:GetMaxHealth()
    local v32
    if v30 then
        local v33 = math.min(1, v31)
        local v34 = v31 * math.random()
        v32 = math.max(v33, v34)
    else
        v32 = p28.FighterInterface.ClientFighter:GetHealth()
    end
    local v35 = v32 / v31
    local v36 = math.clamp(v35, 0, 1)
    local v37 = Color3.fromRGB(255, 50, 50):Lerp(Color3.fromRGB(255, 215, 0):Lerp(Color3.fromRGB(100, 255, 50), v36), v36)
    local v38 = Color3.new(v37.R / 2, v37.G / 2, v37.B / 2)
    p28.DamageVignettePermanent.ImageTransparency = v36 > 0.5 and 1 or v36 * 2
    p28.ContainerFrame.BackgroundColor3 = v38
    p28.ContainerUIStroke.Color = v38
    p28.ContainerBar.BackgroundColor3 = v37
    p28.ContainerBar.Visible = v36 > 0
    p28.ContainerBarUIStroke.Color = v37
    p28.ContainerBarText.Text = v32 >= 1 and v_u_4:PrettyNumber((math.ceil(v32))) or ""
    local v39 = UDim2.new(math.max(0.06, v36), 2, 1, 2)
    if p29 then
        p28.ContainerBar.Size = v39
    else
        local v40 = p28._last_health_alpha and v36 >= p28._last_health_alpha and 0.5 or 1
        p28._last_health_tween = v_u_2:Create(p28.ContainerBar, TweenInfo.new(0.5 / v40, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            ["Size"] = v39
        })
        p28._last_health_tween:Play()
    end
    p28._last_health_alpha = v36
end
function v_u_5._Setup(p41)
    local v42 = UDim2.new(1, 0, 1, v_u_3:GetGuiInset().Y)
    p41.HealVignette.Size = v42
    p41.DamageVignette.Size = v42
end
function v_u_5._Init(p43)
    p43:_Setup()
    p43:_Update(true)
end
return v_u_5