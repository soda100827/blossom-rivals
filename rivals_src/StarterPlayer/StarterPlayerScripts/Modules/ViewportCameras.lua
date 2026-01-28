local v1 = game:GetService("RunService")
local v_u_2 = {
    ["Charm"] = Instance.new("Camera")
}
v_u_2.Charm.FieldOfView = 25
v_u_2.Skin = Instance.new("Camera")
v_u_2.Skin.FieldOfView = 25
v_u_2.Wrap = Instance.new("Camera")
v_u_2.Wrap.FieldOfView = 25
v_u_2.Wrap.CFrame = CFrame.Angles(0, 3.490658503988659, 0) * CFrame.Angles(-0.2617993877991494, 0, 0) * CFrame.new(0, 0, 1)
v_u_2.Emote = Instance.new("Camera")
v_u_2.Emote.FieldOfView = 10
v1.RenderStepped:Connect(function(_)
    v_u_2.Charm.CFrame = CFrame.Angles(0, tick() * 0.5 % 6.283185307179586, 0) * CFrame.Angles(-0.2617993877991494, 0, 0) * CFrame.new(0, 0, 0.3)
    v_u_2.Skin.CFrame = CFrame.Angles(0, tick() * 0.5 % 6.283185307179586, 0) * CFrame.Angles(-0.2617993877991494, 0, 0) * CFrame.new(0, 0, 5)
    local v3 = v_u_2.Emote
    local v4 = CFrame.Angles
    local v5 = tick() * 0.25 % 6.283185307179586
    v3.CFrame = v4(0, 3.141592653589793 + math.sin(v5) * 0.2617993877991494, 0) * CFrame.Angles(-0.4363323129985824, 0, 0) * CFrame.new(0, 0, 40)
end)
return v_u_2