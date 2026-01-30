local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.ItemLibrary)
require(v_u_2.LocalPlayer.PlayerScripts.Controllers.ControlsController)
local v_u_4 = require(v_u_2.LocalPlayer.PlayerScripts.Modules.WeaponStatusHandler)
local v_u_5 = v_u_2.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("InfiniteAmmoParticle")
local v_u_6 = v_u_2.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("AmmoDisplay")
local v_u_7 = {}
v_u_7.__index = v_u_7
function v_u_7.new(p8, p9)
    local v10 = v_u_7
    local v11 = setmetatable({}, v10)
    v11.AmmoDisplays = p8
    v11.ClientItem = p9
    v11.Frame = v_u_6:Clone()
    v11.AmmoIcon = v11.Frame:WaitForChild("Icon")
    v11.AmmoReserveText = v11.Frame:WaitForChild("Reserve")
    v11.AmmoText = v11.AmmoReserveText:WaitForChild("Ammo")
    v11.ItemNameText = v11.Frame:WaitForChild("ItemName")
    v11._connections = {}
    v11._infinite_ammo_effect_active = false
    v11._infinite_ammo_particles = {}
    v11._infinite_ammo_next_particle = 0
    v11:_Init()
    return v11
end
function v_u_7.UpdateAmmo(p12)
    local v13, v14, v15, v16 = p12:_GetAmmoVariables()
    local v17 = p12:_IsMainItem()
    p12.AmmoReserveText.Text = v14 and (v16 and "\226\136\158" or (v13 and (" " .. v14 or "") or "")) or ""
    p12.AmmoReserveText.TextColor3 = v14 and v14 <= 0 and Color3.fromRGB(255, 50, 50) or (v17 and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(0, 0, 0))
    p12.AmmoText.Text = v15 and "\226\136\158" or (v13 or "")
    p12.AmmoText.TextColor3 = v13 and v13 <= 0 and Color3.fromRGB(255, 50, 50) or (v17 and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(0, 0, 0))
    p12.AmmoIcon.Visible = v13 ~= nil
    p12.AmmoIcon.ImageColor3 = v14 and p12.AmmoReserveText.TextColor3 or p12.AmmoText.TextColor3
    p12.AmmoIcon.ImageTransparency = v14 and p12.AmmoReserveText.TextTransparency or p12.AmmoText.TextTransparency
    p12._infinite_ammo = v15
    p12._infinite_ammo_reserve = v16
    p12._infinite_ammo_effect_active = p12._infinite_ammo or p12._infinite_ammo_reserve
    if not p12._infinite_ammo_effect_active then
        for _, v18 in pairs(p12._infinite_ammo_particles) do
            v18.Particle:Destroy()
        end
        p12._infinite_ammo_particles = {}
    end
end
function v_u_7.UpdateVisuals(p19)
    local v20 = p19:_IsMainItem()
    p19.Frame.Visible = p19.ClientItem.IsEquipped
    p19.Frame.Size = v20 and UDim2.new(1, 0, 1, 0) or UDim2.new(0.5, 0, 0.5, 0)
    p19.ItemNameText.TextColor3 = v20 and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(0, 0, 0)
    p19.ItemNameText.TextTransparency = v20 and 0 or 0.7
    p19.AmmoText.TextTransparency = v20 and 0 or 0.7
    p19.AmmoReserveText.TextTransparency = v20 and 0 or 0.7
    p19:UpdateAmmo()
end
function v_u_7.Update(p21, p22, _)
    if p21._infinite_ammo_effect_active then
        p21:_UpdateInfiniteAmmo(p22, p21._infinite_ammo, p21._infinite_ammo_reserve)
    end
end
function v_u_7.Destroy(p23)
    for _, v24 in pairs(p23._connections) do
        v24:Disconnect()
    end
    p23.Frame:Destroy()
end
function v_u_7._IsMainItem(p25)
    return p25.ClientItem == p25.AmmoDisplays.Hotbar.FighterInterface.ClientFighter.EquippedItem
end
function v_u_7._GetAmmoVariables(p26)
    local v27 = p26.ClientItem:Get("Ammo")
    if v27 then
        local v28 = p26.ClientItem:Get("Ammo") + 0.5
        v27 = math.floor(v28)
    end
    local v29 = p26.ClientItem.Info.MaxAmmoReserve and (p26.ClientItem.Info.MaxAmmoReserve > 0 and p26.ClientItem:Get("AmmoReserve"))
    if v29 then
        local v30 = p26.ClientItem:Get("AmmoReserve") + 0.5
        v29 = math.floor(v30)
    end
    local v31
    if v27 and v27 >= (1 / 0) then
        v31 = true
    elseif v27 then
        if v27 > 0 then
            v31 = p26.AmmoDisplays.Hotbar.FighterInterface.ClientFighter:Get("InfiniteAmmo")
        else
            v31 = false
        end
    else
        v31 = v27
    end
    return v27, v29, v31, v29 and v29 >= (1 / 0) and true or p26.AmmoDisplays.Hotbar.FighterInterface.ClientFighter:Get("InfiniteAmmoReserve")
end
function v_u_7._SpawnInfiniteAmmoParticle(p32, p33)
    if p33:IsDescendantOf(v_u_2) then
        local v34 = v_u_5:Clone()
        v34.RichText = p33.RichText
        v34.Text = p33.Text
        v34.TextColor3 = p33.TextColor3
        v34.TextTransparency = p33.TextTransparency
        v34.Position = UDim2.new(1, -p33.TextBounds.X * math.random(), 0.5, p33.TextBounds.Y * 0.5 * (math.random() - 0.5))
        v34.Parent = p33
        v34:TweenSize(UDim2.new(), "In", "Back", 0.75, true)
        local v35 = p32._infinite_ammo_particles
        local v36 = {
            ["Particle"] = v34,
            ["Position"] = v34.Position,
            ["Velocity"] = Vector2.new(math.random() - 0.5, -math.random() - 0.5) * 100,
            ["Start"] = tick()
        }
        table.insert(v35, v36)
    end
end
function v_u_7._UpdateInfiniteAmmo(p37, p38, p39, p40)
    for v41 = #p37._infinite_ammo_particles, 1, -1 do
        local v42 = p37._infinite_ammo_particles[v41]
        if tick() - v42.Start >= 1 then
            v42.Particle:Destroy()
            table.remove(p37._infinite_ammo_particles, v41)
        else
            local v43 = v42.Velocity.X * p38 / 60
            local v44 = v42.Velocity.Y * p38 / 60 + 0.25 * (tick() - v42.Start) ^ 2
            v42.Position = v42.Position + UDim2.new(v43, 0, v44, 0)
            v42.Particle.Position = v42.Position
            local v45 = v42.Particle
            v45.Rotation = v45.Rotation + v43 * 200
        end
    end
    if tick() >= p37._infinite_ammo_next_particle then
        p37._infinite_ammo_next_particle = tick() + 0.1
        if p39 then
            p37:_SpawnInfiniteAmmoParticle(p37.AmmoText)
        end
        if p40 then
            p37:_SpawnInfiniteAmmoParticle(p37.AmmoReserveText)
        end
    end
end
function v_u_7._UpdateAmmoPosition(p46)
    p46.AmmoText.Position = UDim2.new(1, -p46.AmmoReserveText.TextBounds.X, 0.1, 0)
end
function v_u_7._Setup(p47)
    p47.AmmoIcon.Image = p47.ClientItem.Info.AmmoType and (v_u_3.Ammos[p47.ClientItem.Info.AmmoType].Image or "") or ""
    p47.ItemNameText.Text = p47.ClientItem.Name
    v_u_4:ApplyItemStatusToText(p47.ItemNameText, p47.ClientItem.Info.Status)
end
function v_u_7._Init(p_u_48)
    p_u_48.AmmoReserveText:GetPropertyChangedSignal("TextBounds"):Connect(function()
        p_u_48:_UpdateAmmoPosition()
    end)
    local v49 = p_u_48._connections
    local v50 = p_u_48.ClientItem:GetDataChangedSignal("Ammo")
    table.insert(v49, v50:Connect(function()
        p_u_48:UpdateAmmo()
    end))
    local v51 = p_u_48._connections
    local v52 = p_u_48.ClientItem:GetDataChangedSignal("AmmoReserve")
    table.insert(v51, v52:Connect(function()
        p_u_48:UpdateAmmo()
    end))
    local v53 = p_u_48._connections
    local v54 = p_u_48.ClientItem.EquippedChanged
    table.insert(v53, v54:Connect(function()
        p_u_48:UpdateVisuals()
    end))
    p_u_48:_Setup()
    p_u_48:_UpdateAmmoPosition()
    p_u_48:UpdateAmmo()
    p_u_48:UpdateVisuals()
end
return v_u_7