local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.BetterDebris)
local v_u_4 = require(v1.Modules.Utility)
local v_u_5 = require(v1.Modules.Spring)
local v_u_6 = v2.LocalPlayer.PlayerScripts.Assets:WaitForChild("Misc"):WaitForChild("SmokeClouds")
local v_u_7 = {}
v_u_7.__index = v_u_7
function v_u_7.new(p8, _)
    local v9 = v_u_7
    local v10 = setmetatable({}, v9)
    v10.Part = p8
    v10.Name = v10.Part.Name
    v10.EnvironmentID = v10.Part:GetAttribute("EnvironmentID")
    v10.Model = nil
    v10._destroyed = false
    v10._start_spring = v_u_5.new(0, 0.875, 10)
    v10._finish_spring = v_u_5.new(0, 1, 2)
    v10._position_spring = v_u_5.new(v10.Part.Position, 1, 20)
    v10._speed = 0.75 + 0.25 * math.random()
    v10._spin = 6.283185307179586 * math.random()
    v10._last_size = v10.Part.Size
    v10._idle_sound = nil
    v10._idle_sound_original_volume = nil
    v10:_Init()
    return v10
end
function v_u_7.IsDestroyed(p11)
    return p11._destroyed
end
function v_u_7.Update(p12, p13)
    if p12:_UpdateCoreLogic() then
        return true
    end
    p12._position_spring.Target = p12.Part.Position
    p12:_StepSpin(p13)
    p12.Model:PivotTo(CFrame.new(p12._position_spring.Value) * CFrame.Angles(0, p12._spin, 0))
end
function v_u_7.Clear(p14)
    p14._finish_spring.Target = 1
    v_u_3:AddItem(p14, 10)
end
function v_u_7.Destroy(p15)
    if not p15._destroyed then
        p15._destroyed = true
        p15.Model:Destroy()
    end
end
function v_u_7._CreateIdleSound(_)
    return v_u_4:CreateSound("rbxassetid://16540273153", 0.1, 1, nil, true)
end
function v_u_7._StepSpin(p16, p17)
    p16._spin = (p16._spin + p16._speed * (1 + 5 * p16._start_spring.Velocity) * p17) % 6.283185307179586
end
function v_u_7._UpdateCoreLogic(p18)
    if not p18._idle_sound then
        p18._idle_sound = p18:_CreateIdleSound()
        p18._idle_sound.Parent = p18.Part
        p18._idle_sound_original_volume = p18._idle_sound.Volume
    end
    p18.Model:ScaleTo(p18.Part.Size.Y * p18._start_spring.Value)
    if p18._finish_spring.Target > 0 then
        if p18._finish_spring.Value >= 1 then
            p18:Destroy()
            return true
        end
        for _, v19 in pairs(p18.Model:GetDescendants()) do
            local v20 = p18._finish_spring.Value * (v19:GetAttribute("DecaySpeed") or 1) + (v19:GetAttribute("DecayOffset") or 0)
            v19.LocalTransparencyModifier = math.clamp(v20, 0, 1)
        end
        local v21 = p18._idle_sound
        local v22 = p18._idle_sound_original_volume
        local v23 = 1 - p18._finish_spring.Value * 2
        v21.Volume = v22 * math.clamp(v23, 0, 1)
    else
        p18._idle_sound.Volume = p18._start_spring.Value * p18._idle_sound_original_volume
    end
end
function v_u_7._AppearSound(p24)
    v_u_4:CreateSound("rbxassetid://16540273321", 1, 1 + 0.1 * math.random(), p24.Part, true, 5)
end
function v_u_7._Setup(p_u_25)
    local v26 = p_u_25.Part:GetAttribute("Template")
    local v27 = v_u_6:FindFirstChild(p_u_25.Part.Name)
    p_u_25.Model = (v27 and v27:IsA("Folder") and (v26 and v27[v26] or v27:GetChildren()[math.random(#v27:GetChildren())]) or (v27 or v_u_6.Default)):Clone()
    p_u_25.Model.Destroying:Connect(function()
        p_u_25:Destroy()
    end)
    p_u_25._start_spring.Target = 1
end
function v_u_7._Init(p_u_28)
    p_u_28.Part:GetPropertyChangedSignal("Size"):Connect(function()
        p_u_28:_AppearSound()
        p_u_28._start_spring.Value = p_u_28._last_size.Magnitude / p_u_28.Part.Size.Magnitude
        p_u_28._last_size = p_u_28.Part.Size
    end)
    p_u_28:_Setup()
    p_u_28:_AppearSound()
end
return v_u_7