local v1 = game:GetService("Players")
local v_u_2 = require(v1.LocalPlayer.PlayerScripts.Modules.ViewModels.Gunblade)
local v_u_3 = setmetatable({}, v_u_2)
v_u_3.__index = v_u_3
function v_u_3.new(...)
    local v4 = v_u_2.new(...)
    local v5 = v_u_3
    local v6 = setmetatable(v4, v5)
    v6._spike_toggle = false
    v6._next_toggle = 0
    v6._spikes1 = v6.ItemModel:WaitForChild("Body"):WaitForChild("Spikes1")
    v6._spikes2 = v6.ItemModel:WaitForChild("Body"):WaitForChild("Spikes2")
    v6:_Init()
    return v6
end
function v_u_3.Update(p7, p8, p9, p10)
    v_u_2.Update(p7, p8, p9, p10)
    if p10.IsActive then
        if tick() >= p7._next_toggle then
            p7._next_toggle = tick() + 0.03
            p7._spike_toggle = not p7._spike_toggle
            p7:_LocalTransparencyModifier(p7._spikes1, "Update", p7._spike_toggle and 0 or 1)
            p7:_LocalTransparencyModifier(p7._spikes2, "Update", p7._spike_toggle and 1 or 0)
        end
    else
        return
    end
end
function v_u_3._PlayIdleSound(p11)
    local v12 = p11:CreateSound("rbxassetid://13645858587", 0.375, 1, true, nil, 10, 40)
    if v12 then
        v12.Looped = true
    end
    local v13 = p11:CreateSound("rbxassetid://13646484249", 0.375, 1, true, nil, 10, 40)
    if v13 then
        v13.Looped = true
    end
    local v14 = p11:CreateSound("rbxassetid://13646484113", 0.25, 1, true, nil, 10, 40)
    if v14 then
        v14.Looped = true
    end
end
function v_u_3._Init(p_u_15)
    p_u_15.Equipped:Connect(function()
        p_u_15:_PlayIdleSound()
    end)
end
return v_u_3