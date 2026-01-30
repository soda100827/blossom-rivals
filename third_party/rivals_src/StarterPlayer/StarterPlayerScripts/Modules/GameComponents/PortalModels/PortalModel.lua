local v_u_1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("Players")
local v_u_3 = require(v_u_1.Modules.Utility)
local v_u_4 = require(v_u_2.LocalPlayer.PlayerScripts.Controllers.FighterController)
local v_u_5 = require(script:WaitForChild("Portal"))
local v_u_6 = {}
v_u_6.__index = v_u_6
function v_u_6.new(p7)
    local v8 = v_u_6
    local v9 = setmetatable({}, v8)
    v9.Model = p7
    v9.Portals = {}
    v9._user_id = v9.Model:GetAttribute("UserID")
    v9._teleport_cooldowns = {}
    v9:_Init()
    return v9
end
function v_u_6.GetPortal(p10, p11)
    for v12, v13 in pairs(p10.Portals) do
        if v13.Model == p11 then
            return v13, v12
        end
    end
end
function v_u_6.GetOtherPortal(p14, p15)
    return p14.Portals[3 - p15.PortalNum]
end
function v_u_6.ArePortalsGrown(p16)
    local v17 = p16.Portals[1] and (p16.Portals[1]:IsGrown() and p16.Portals[2])
    if v17 then
        v17 = p16.Portals[2]:IsGrown()
    end
    return v17
end
function v_u_6.CanWarp(p18)
    local v19 = p18.Portals[1]
    if v19 then
        v19 = not (p18.Portals[2] and p18._user_id) or p18._user_id == v_u_2.LocalPlayer.UserId
    end
    return v19
end
function v_u_6.Update(p20, p21)
    for _, v22 in pairs(p20.Portals) do
        v22:Update(p21)
    end
end
function v_u_6.Destroy(p_u_23)
    for _, v24 in pairs(p_u_23.Portals) do
        v24:Destroy()
    end
    pcall(function()
        p_u_23.Model:Destroy()
    end)
end
function v_u_6._UpdateVisuals(p25)
    local v26 = p25:CanWarp()
    for _, v27 in pairs(p25.Portals) do
        v27:UpdateVisuals(v26)
    end
end
function v_u_6._ChildRemoved(p28, p29)
    local v30, v31 = p28:GetPortal(p29)
    if v30 then
        v30:Destroy()
        p28.Portals[v31] = nil
        p28:_UpdateVisuals()
    end
end
function v_u_6._ChildAdded(p_u_32, p33)
    if p33:IsA("Model") then
        p_u_32:_ChildRemoved(p33)
        local v_u_34 = v_u_5.new(p33)
        p_u_32.Portals[v_u_34.PortalNum] = v_u_34
        p_u_32:_UpdateVisuals()
        p_u_32._teleport_cooldowns[v_u_34.PortalNum] = {}
        v_u_34.Hitbox.Touched:Connect(function(p35)
            if p_u_32:CanWarp() and p_u_32:ArePortalsGrown() then
                local v36 = p_u_32:GetOtherPortal(v_u_34)
                if v36 then
                    local v37 = p35.AssemblyRootPart or p35
                    if p35.Parent == v_u_2.LocalPlayer.Character and (tick() >= (p_u_32._teleport_cooldowns[v_u_34.PortalNum][v37] or 0) and (v_u_4.LocalFighter and v_u_4.LocalFighter:IsAlive())) then
                        p_u_32._teleport_cooldowns[v_u_34.PortalNum][v37] = tick() + 0.25
                        p_u_32._teleport_cooldowns[v36.PortalNum][v37] = tick() + 1
                        v_u_4.LocalFighter.Entity:WarpTo(v36:GetTeleportCFrame())
                        v_u_3:CreateSound("rbxassetid://86785771664692", 0.5, 1 + 0.1 * math.random(), v_u_34.Hitbox, true, 10)
                        v_u_3:CreateSound("rbxassetid://81610952487049", 1, 1 + 0.1 * math.random(), v36.Hitbox, true, 10)
                        v_u_1.Remotes.Replication.Fighter.PlayMechanicsSound:FireServer("Warp")
                    end
                else
                    return
                end
            else
                return
            end
        end)
    end
end
function v_u_6._Init(p_u_38)
    p_u_38.Model.ChildAdded:Connect(function(p39)
        p_u_38:_ChildAdded(p39)
    end)
    p_u_38.Model.ChildRemoved:Connect(function(p40)
        p_u_38:_ChildRemoved(p40)
    end)
end
return v_u_6