local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("Lighting")
local v3 = game:GetService("Players")
local v_u_4 = require(v1.Modules.Utility)
local v_u_5 = require(v3.LocalPlayer.PlayerScripts.Modules.ViewModels.Handgun)
local v_u_6 = setmetatable({}, v_u_5)
v_u_6.__index = v_u_6
function v_u_6.new(...)
    local v7 = v_u_5.new(...)
    local v8 = v_u_6
    local v9 = setmetatable(v7, v8)
    v9._domain_expansion_hash = 0
    v9._domain_expansion_cc = nil
    v9._domain_expansion_sound = nil
    v9:_Init()
    return v9
end
function v_u_6.Destroy(p10)
    p10._domain_expansion_hash = p10._domain_expansion_hash + 1
    if p10._domain_expansion_cc then
        p10._domain_expansion_cc:Destroy()
        p10._domain_expansion_cc = nil
    end
    if p10._domain_expansion_sound then
        p10._domain_expansion_sound:Destroy()
        p10._domain_expansion_sound = nil
    end
    v_u_5.Destroy(p10)
end
function v_u_6._DomainExpansion(p_u_11)
    if not p_u_11._destroyed and p_u_11.ClientItem.ClientFighter:Get("IsSpectating") then
        p_u_11._domain_expansion_hash = p_u_11._domain_expansion_hash + 1
        if p_u_11._domain_expansion_cc then
            p_u_11._domain_expansion_cc:Destroy()
            p_u_11._domain_expansion_cc = nil
        end
        if p_u_11._domain_expansion_sound then
            p_u_11._domain_expansion_sound:Destroy()
            p_u_11._domain_expansion_sound = nil
        end
        p_u_11._domain_expansion_cc = Instance.new("ColorCorrectionEffect")
        p_u_11._domain_expansion_cc.Brightness = -0.5
        p_u_11._domain_expansion_cc.Contrast = 2
        p_u_11._domain_expansion_cc.Saturation = -3
        p_u_11._domain_expansion_cc.Parent = v_u_2
        p_u_11._domain_expansion_sound = v_u_4:CreateSound("rbxassetid://83352422371729", 1.25, 1.1, script, true, 20)
        local v_u_12 = p_u_11._domain_expansion_hash
        task.delay(15, function()
            local v_u_13 = p_u_11._domain_expansion_sound
            if v_u_13 then
                v_u_13 = p_u_11._domain_expansion_sound.Volume
            end
            v_u_4:RenderstepForLoop(1, 0, -0.04, function(p14)
                if v_u_12 ~= p_u_11._domain_expansion_hash then
                    return true
                end
                local v15 = p14 ^ 4
                p_u_11._domain_expansion_cc.Saturation = -3 * v15
                p_u_11._domain_expansion_cc.Contrast = 2 * v15
                p_u_11._domain_expansion_cc.Brightness = -0.5 * v15
                if p_u_11._domain_expansion_sound then
                    p_u_11._domain_expansion_sound.Volume = v_u_13 * p14
                end
            end)
            if v_u_12 == p_u_11._domain_expansion_hash then
                p_u_11._domain_expansion_cc:Destroy()
                p_u_11._domain_expansion_cc = nil
                if p_u_11._domain_expansion_sound then
                    p_u_11._domain_expansion_sound:Destroy()
                    p_u_11._domain_expansion_sound = nil
                end
            end
        end)
    end
end
function v_u_6._Init(p_u_16)
    p_u_16.AnimationPlayed:Connect(function(p17)
        if p17 == "RareInspect" then
            task.delay(0.6, p_u_16._DomainExpansion, p_u_16)
        end
    end)
end
return v_u_6