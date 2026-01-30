local v1 = game:GetService("Players")
local v_u_2 = require(v1.LocalPlayer.PlayerScripts.Modules:WaitForChild("ClientReplicatedClasses"):WaitForChild("ClientFighter"):WaitForChild("ClientItem"):WaitForChild("ClientViewModel"))
local v_u_3 = v1.LocalPlayer.PlayerScripts.Assets.Misc.BowChargeEffects
local v_u_4 = {
    Color3.fromRGB(191, 191, 191),
    Color3.fromRGB(100, 255, 50),
    Color3.fromRGB(255, 180, 0),
    Color3.fromRGB(255, 50, 50)
}
local v_u_5 = setmetatable({}, v_u_2)
v_u_5.__index = v_u_5
function v_u_5.new(...)
    local v6 = v_u_2.new(...)
    local v7 = v_u_5
    local v8 = setmetatable(v6, v7)
    v8._charge_attachment = v8.Model:FindFirstChild("_bow_charge", true)
    v8._charge_particles = {}
    v8._visibility_delayed = nil
    local v9 = v8._charm_pivot_attachment
    if v9 then
        v9 = v8._charm_pivot_attachment.Parent
    end
    v8._charm_attachment_parent = v9
    v8._registered_ammo_visuals = {}
    v8:_Init()
    return v8
end
function v_u_5.GetChargeColor(_, p10)
    return v_u_4[p10]
end
function v_u_5.PlayChargeSound(p11, p12)
    p11:CreateSound("rbxassetid://13744359504", 1, 0.75 + 0.25 * p12, true, 10)
end
function v_u_5.PlayChargeEffect(p13, p14)
    p13:PlayChargeSound(p14)
    for _, v15 in pairs(p13._charge_particles) do
        v15.Color = ColorSequence.new(p13:GetChargeColor(p14))
        v15:Emit(1)
    end
end
function v_u_5._UpdateArrow(p16)
    if p16._destroyed then
        return
    else
        local v17 = (p16.ClientItem:Get("Ammo") <= 0 and not p16:IsAnimationPlaying("Reload") and true or false) and (not p16:IsAnimationPlaying("Shoot1") and p16:IsAnimationPlaying("ChargeRelease"))
        if v17 then
            v17 = p16.ClientItem:Get("AmmoReserve") > 0
        end
        if v17 and not p16._visibility_delayed then
            p16._visibility_delayed = true
            wait(0.1)
            p16:_UpdateArrow()
        else
            if p16._charm_pivot_attachment then
                local v18 = p16._charm_pivot_attachment
                local v19
                if v17 then
                    v19 = p16._charm_attachment_parent or nil
                else
                    v19 = nil
                end
                v18.Parent = v19
            end
            local v20 = v17 and 0 or 1
            for _, v21 in pairs(p16._registered_ammo_visuals) do
                p16:_LocalTransparencyModifier(v21, "AmmoVisual", v20)
            end
            p16._visibility_delayed = nil
        end
    end
end
function v_u_5._RegisterAmmoVisual(p22, p23)
    local v24 = p22._registered_ammo_visuals
    table.insert(v24, p23)
end
function v_u_5._Setup(p25)
    for _, v26 in pairs((v_u_3:FindFirstChild(p25.Name) or v_u_3.Default).Attachment:GetChildren()) do
        local v27 = v26:Clone()
        v27.Parent = p25._charge_attachment
        local v28 = p25._charge_particles
        table.insert(v28, v27)
    end
end
function v_u_5._Init(p_u_29)
    p_u_29.ClientItem:GetDataChangedSignal("Ammo"):Connect(function()
        p_u_29:_UpdateArrow()
    end)
    p_u_29.AnimationPlayed:Connect(function()
        p_u_29:_UpdateArrow()
    end)
    p_u_29.AnimationStopped:Connect(function()
        p_u_29:_UpdateArrow()
    end)
    p_u_29:_Setup()
    task.spawn(p_u_29._UpdateArrow, p_u_29)
end
return v_u_5