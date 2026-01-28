local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.ItemLibrary)
local v_u_4 = require(v2.LocalPlayer.PlayerScripts.Modules.ItemTypes.Custom)
local v_u_5 = {
    ["Utility"] = "rbxassetid://134135466396929",
    ["Melee"] = "rbxassetid://78813062969940",
    ["Secondary"] = "rbxassetid://136044794858753",
    ["Primary"] = "rbxassetid://77716075365102"
}
local v_u_6 = setmetatable({}, v_u_4)
v_u_6.__index = v_u_6
function v_u_6.new(...)
    local v7 = v_u_4.new(...)
    local v8 = v_u_6
    local v9 = setmetatable(v7, v8)
    v9._use_cooldown = 0
    v9:_Init()
    return v9
end
function v_u_6.GetAutoShootReactionTime(_)
    return nil
end
function v_u_6.CanQuickAttack(p10)
    local v11
    if tick() > p10._use_cooldown then
        v11 = not p10:IsEquipping()
    else
        v11 = false
    end
    return v11
end
function v_u_6.StartShooting(p_u_12, p13)
    if not p13 and (tick() < p_u_12._use_cooldown or p_u_12:IsEquipping()) then
        return false
    end
    p_u_12._use_cooldown = tick() + p_u_12.Info.RollDuration + p_u_12.Info.Cooldown
    p_u_12.ViewModel:PlayAnimation("Use")
    if p_u_12.ItemInterface then
        p_u_12.ItemInterface:CooldownEffect("rbxassetid://132973552546079", p_u_12.Info.RollDuration, "Rolling", true)
        task.delay(p_u_12.Info.RollDuration, function()
            if not p_u_12._destroyed then
                if p_u_12.ItemInterface then
                    p_u_12.ItemInterface:CooldownEffect("rbxassetid://17156089790", p_u_12.Info.Cooldown, "Cooldown")
                end
            end
        end)
    end
    return true, "StartShooting", p_u_12.ClientFighter:GetCameraData()
end
function v_u_6.ReplicateFromServer(p14, p15, ...)
    if p15 == "RollResult" then
        if p14:IsRendered() then
            local v16, v17 = ...
            local v18 = v17 and "rbxassetid://136831234910767" or (v_u_5[v_u_3.Items[v16].Class] or v_u_5.Utility)
            if p14.ClientFighter.FighterInterface then
                p14.ClientFighter.FighterInterface.Hotbar:RollEffect(p14)
            end
            p14:CreateSound("rbxassetid://95740132815107", 1.5, 1 + 0.1 * math.random(), true, 0.4):SetAttribute("DontClearSound", true)
            wait(0.4)
            p14:CreateSound(v18, 1.5, 1 + 0.2 * math.random(), true, 5):SetAttribute("DontClearSound", true)
        end
    else
        v_u_4.ReplicateFromServer(p14, p15, ...)
        return
    end
end
function v_u_6._Init(_) end
return v_u_6