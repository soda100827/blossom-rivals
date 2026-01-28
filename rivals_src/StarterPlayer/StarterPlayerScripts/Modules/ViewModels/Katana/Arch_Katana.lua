local v1 = game:GetService("Players")
local v_u_2 = require(v1.LocalPlayer.PlayerScripts.Modules.ViewModels.Katana)
local v_u_3 = setmetatable({}, v_u_2)
v_u_3.__index = v_u_3
function v_u_3.new(...)
    local v4 = v_u_2.new(...)
    local v5 = v_u_3
    local v6 = setmetatable(v4, v5)
    v6._equip_effect_hash = 0
    v6._arch_katana_particles = {}
    v6:_Init()
    return v6
end
function v_u_3.PlayDeflectHitSounds(p7)
    p7:CreateSound("rbxassetid://14776414133", 1.25, 1.5 + 0.5 * math.random(), true, 5)
    p7:CreateSound("rbxassetid://14776437962", 1, 0.9 + 0.2 * math.random(), true, 5)
    p7:CreateSound("rbxassetid://82797934287631", 1, 0.9 + 0.2 * math.random(), true, 5)
end
function v_u_3.Unequip(p8, ...)
    p8._equip_effect_hash = p8._equip_effect_hash + 1
    v_u_2.Unequip(p8, ...)
end
function v_u_3.Destroy(p9)
    p9._equip_effect_hash = p9._equip_effect_hash + 1
    v_u_2.Destroy(p9)
end
function v_u_3._SetArchParticlesVisible(p10, p11)
    for _, v12 in pairs(p10._arch_katana_particles) do
        v12.Enabled = p11
    end
end
function v_u_3._EquipEffect(p13, p14)
    p13._equip_effect_hash = p13._equip_effect_hash + 1
    local v15 = p13._equip_effect_hash
    p13:_SetArchParticlesVisible(false)
    if not p14 then
        wait(0.5)
    end
    if p13._equip_effect_hash == v15 then
        p13:_SetArchParticlesVisible(true)
    end
end
function v_u_3._Setup(p16)
    for _, v17 in pairs(p16.ItemModel:GetDescendants()) do
        if v17:HasTag("ArchKatanaParticles") and v17.Enabled then
            local v18 = p16._arch_katana_particles
            table.insert(v18, v17)
        end
    end
end
function v_u_3._Init(p_u_19)
    p_u_19.Equipped:Connect(function(p20)
        p_u_19:_EquipEffect(p20)
    end)
    p_u_19:_Setup()
end
return v_u_3