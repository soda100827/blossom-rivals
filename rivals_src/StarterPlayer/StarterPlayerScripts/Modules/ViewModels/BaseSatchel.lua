local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.Utility)
local v_u_4 = require(v2.LocalPlayer.PlayerScripts.Modules:WaitForChild("ClientReplicatedClasses"):WaitForChild("ClientFighter"):WaitForChild("ClientItem"):WaitForChild("ClientViewModel"))
v2.LocalPlayer.PlayerScripts.Assets.Misc:WaitForChild("ChainsawParticles")
local v_u_5 = { 1, 0.1 }
local v_u_6 = setmetatable({}, v_u_4)
v_u_6.__index = v_u_6
function v_u_6.new(...)
    local v7 = v_u_4.new(...)
    local v8 = v_u_6
    local v9 = setmetatable(v7, v8)
    v9._beep_parts = {}
    v9._beep_visible = false
    v9._toggle_index = 0
    v9._next_toggle = 0
    v9:_Init()
    return v9
end
function v_u_6.Update(p10, p11, p12, p13)
    v_u_4.Update(p10, p11, p12, p13)
    if p13.IsActive then
        if tick() >= p10._next_toggle then
            p10._toggle_index = p10._toggle_index % #v_u_5 + 1
            p10._next_toggle = tick() + v_u_5[p10._toggle_index]
            p10._beep_visible = not p10._beep_visible
            for v14, _ in pairs(p10._beep_parts) do
                p10:_LocalTransparencyModifier(v14, "Update", p10._beep_visible and 0 or 1)
            end
        end
    else
        return
    end
end
function v_u_6._PlayBeepAnimation(_, p15)
    while p15:IsDescendantOf(workspace) do
        wait(1)
        p15.LocalTransparencyModifier = 1
        wait(0.1)
        p15.LocalTransparencyModifier = 0
    end
end
function v_u_6._RegisterBeepPart(p16, p17)
    p16._beep_parts[p17] = true
end
function v_u_6._Init(p_u_18)
    task.defer(function()
        p_u_18.ClientItem.ProjectileThrown:Connect(function(p19, _)
            wait(0.5)
            v_u_3:CreateSound("rbxassetid://104924027407060", 0.05, 1 + 0.1 * math.random(), p19, true).Looped = true
        end)
    end)
end
return v_u_6