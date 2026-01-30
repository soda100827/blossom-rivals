local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.Utility)
local v_u_4 = require(v2.LocalPlayer.PlayerScripts.Modules.ViewModels["Battle Axe"])
local v_u_5 = setmetatable({}, v_u_4)
v_u_5.__index = v_u_5
function v_u_5.new(...)
    local v6 = v_u_4.new(...)
    local v7 = v_u_5
    local v8 = setmetatable(v6, v7)
    v8._equip_effect_hash = 0
    v8._vfx_attachment = v8.ItemModel:WaitForChild("Body"):WaitForChild("Gem"):WaitForChild("VFX")
    v8._blade1 = v8.ItemModel:WaitForChild("Body"):WaitForChild("Blade1")
    v8._blade2 = v8.ItemModel:WaitForChild("Body"):WaitForChild("Blade2")
    v8:_Init()
    return v8
end
function v_u_5.Unequip(p9, ...)
    p9._equip_effect_hash = p9._equip_effect_hash + 1
    v_u_4.Unequip(p9, ...)
end
function v_u_5.Destroy(p10)
    p10._equip_effect_hash = p10._equip_effect_hash + 1
    v_u_4.Destroy(p10)
end
function v_u_5._EquipEffect(p11, p12)
    p11._equip_effect_hash = p11._equip_effect_hash + 1
    local v13 = p11._equip_effect_hash
    p11:_LocalTransparencyModifier(p11._blade1, "EquipEffect", 1)
    p11:_LocalTransparencyModifier(p11._blade2, "EquipEffect", 1)
    if not p12 then
        wait(0.55)
    end
    if p11._equip_effect_hash == v13 then
        v_u_3:PlayParticles(p11._vfx_attachment)
        p11:CreateSound("rbxassetid://117746175185603", 0.5, 0.5 + 0.125 * math.random(), true, 0.3)
        if not p12 then
            wait(0.3)
        end
        if p11._equip_effect_hash == v13 then
            p11:CreateSound("rbxassetid://75313977551180", 0.875, 1 + 0.2 * math.random(), true, 5)
            p11:CreateSound("rbxassetid://107162559513589", 0.875, 1 + 0.2 * math.random(), true, 5)
            p11:CreateSound("rbxassetid://115716079009988", 0.875, 1 + 0.2 * math.random(), true, 5)
            p11:_LocalTransparencyModifier(p11._blade1, "EquipEffect", 0)
            p11:_LocalTransparencyModifier(p11._blade2, "EquipEffect", 0)
        end
    else
        return
    end
end
function v_u_5._Init(p_u_14)
    p_u_14.Equipped:Connect(function(p15)
        p_u_14:_EquipEffect(p15)
    end)
end
return v_u_5