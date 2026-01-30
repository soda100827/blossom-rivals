local v1 = game:GetService("Players")
local v_u_2 = require(v1.LocalPlayer.PlayerScripts.Modules:WaitForChild("ClientReplicatedClasses"):WaitForChild("ClientFighter"):WaitForChild("ClientItem"):WaitForChild("ClientViewModel"))
local v_u_3 = setmetatable({}, v_u_2)
v_u_3.__index = v_u_3
function v_u_3.new(...)
    local v4 = v_u_2.new(...)
    local v5 = v_u_3
    local v6 = setmetatable(v4, v5)
    v6._sphere = nil
    v6._visibility_delayed = nil
    v6:_Init()
    return v6
end
function v_u_3._UpdateBall(p7)
    if p7._destroyed then
        return
    else
        local v8 = p7.ClientItem:Get("Ammo") > 0 and true or p7:IsAnimationPlaying("Reload")
        if v8 and not p7._visibility_delayed then
            p7._visibility_delayed = true
            wait(0.1)
            p7:_UpdateBall()
        else
            p7:_LocalTransparencyModifier(p7._sphere, "AmmoVisual", v8 and 0 or 1)
            p7._visibility_delayed = nil
        end
    end
end
function v_u_3._RegisterDefaultAmmoVisuals(p_u_9)
    p_u_9._sphere = p_u_9.ItemModel:WaitForChild("Ball"):WaitForChild("Sphere")
    p_u_9.ClientItem:GetDataChangedSignal("Ammo"):Connect(function()
        p_u_9:_UpdateBall()
    end)
    p_u_9.AnimationPlayed:Connect(function(p10)
        if p10 == "Reload" then
            p_u_9:_UpdateBall()
        end
    end)
    p_u_9.AnimationStopped:Connect(function(p11)
        if p11 == "Reload" then
            p_u_9:_UpdateBall()
        end
    end)
    task.spawn(p_u_9._UpdateBall, p_u_9)
end
function v_u_3._Init(_) end
return v_u_3