local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("CollectionService")
local v_u_3 = game:GetService("ServerStorage")
local v_u_4 = game:GetService("Players")
local v_u_5 = require(v1.Modules.CONSTANTS)
local v_u_6 = require(v1.Modules.BetterDebris)
local v_u_7 = require(v1.Modules.ItemLibrary)
local v_u_8 = require(v1.Modules.ShopLibrary)
local v_u_9 = require(v1.Modules.Utility)
local v_u_10 = {}
v_u_10.__index = v_u_10
function v_u_10._new()
    local v11 = v_u_10
    local v12 = setmetatable({}, v11)
    v12.OOB_DEFAULT_WARN_DELAY = 1
    v12.OOB_DEFAULT_KILL_DELAY = 4
    v12:_Init()
    return v12
end
function v_u_10.IsEntity(_, p13)
    while p13 and p13 ~= workspace do
        if v_u_2:HasTag(p13, "Entity") then
            return p13
        end
        p13 = p13.Parent
    end
    return false
end
function v_u_10.GetEnvironmentID(_, p14)
    while p14 and p14:IsDescendantOf(workspace) do
        local v15 = p14:GetAttribute("EnvironmentID")
        if v15 then
            return v15
        end
        p14 = p14.Parent
    end
    return nil
end
function v_u_10.GetSmokeCloudBetweenPoints(_, p16, p17)
    for _, v18 in pairs(v_u_2:GetTagged("SmokeCloud")) do
        if v_u_9:SphereLineIntersection(v18.Position, v18.Size.X / 2, p16, p17) then
            return v18
        end
    end
end
function v_u_10.GetSmokeCloudsInSphere(_, p19, p20, p21, p22)
    local v23 = p20 or 0
    local v24 = {}
    for _, v25 in pairs(v_u_2:GetTagged("SmokeCloud")) do
        if (p19 - v25.Position).Magnitude <= v25.Size.X / 2 + v23 and (not p21 or (not p22 or p22 >= v_u_9:AngleBetweenVectors(p21, v25.Position - p19))) then
            table.insert(v24, v25)
        end
    end
    return v24
end
function v_u_10.GetEquippedItems(_, p26, p27, p28)
    if not p26 then
        return {}
    end
    local v29 = nil
    local v30 = nil
    for v31, v32 in pairs(p27) do
        if v32:Get("ObjectID") == p26 then
            v30 = v31
            v29 = v32
            break
        end
    end
    if not v29 then
        return {}
    end
    local v33 = {}
    for v34 = v30, v30 + (p28 or 0) do
        v33[p27[(v34 - 1) % #p27 + 1]] = true
    end
    return v33
end
function v_u_10.KnockbackTaggedParts(_, p35, p36, p37, p38, p39, p40, p41)
    local v42 = "RaycastWhitelist" .. (p35 or "")
    local v43 = OverlapParams.new()
    v43.FilterType = Enum.RaycastFilterType.Include
    v43.FilterDescendantsInstances = v_u_2:GetTagged("Knockbackable")
    for _, v44 in pairs(workspace:GetPartBoundsInRadius(p36, p37, v43)) do
        if not v44.Anchored and (not v44.Position:FuzzyEq(p36) and (not p40 or (not p41 or p41 >= v_u_9:AngleBetweenVectors(p40, v44.Position - p36)))) and v44:HasTag(v42) then
            if v44:HasTag("TrowelBrick") then
                v44.CustomPhysicalProperties = PhysicalProperties.new(0.1, v44.CurrentPhysicalProperties.Friction, v44.CurrentPhysicalProperties.Elasticity)
            end
            v44.Velocity = p39 or (v44.Position - p36).Unit * p38 * (1 - (v44.Position - p36).Magnitude / p37)
        end
    end
end
function v_u_10.GetRaycastRedirection(p45, p46, p47, p_u_48, p_u_49, p50)
    if p50 <= 0 then
        return p_u_48
    end
    local v_u_51 = {}
    p45:GetEntitiesWithinSphere(p46, p47, p_u_49, 128, false, nil, nil, nil, function(p52)
        local v53 = CFrame.new(p_u_49, p52.RootPart.Position).LookVector
        local v54 = {
            ["Entity"] = p52,
            ["LookDir"] = v53,
            ["Angle"] = v_u_9:AngleBetweenVectors(p_u_48, v53)
        }
        local v55 = v_u_51
        table.insert(v55, v54)
    end)
    table.sort(v_u_51, function(p56, p57)
        return p56.Angle < p57.Angle
    end)
    if v_u_51[1] and v_u_51[1].Angle < p50 then
        p_u_48 = v_u_51[1].LookDir or p_u_48
    end
    return p_u_48
end
function v_u_10.SwitchingWeaponsMakesSense(p58, p59, p60)
    local v61 = {}
    for v62, _ in pairs(v_u_7.Classes) do
        v61[v62] = {}
    end
    for _, v63 in pairs(v_u_8:GetReleasedOwnableWeapons(v_u_5.WEAPON_EARLY_ACCESS_TIME_OFFSET)) do
        local _ = v_u_7.Items[v63].Class
        for v64, v65 in pairs(v_u_7.Classes) do
            if p58:CanUseWeapon(p59, p60, v63, v65.Slot) then
                local v66 = v61[v64]
                table.insert(v66, v63)
                if #v61[v64] > 1 then
                    return true
                end
            end
        end
    end
    return false
end
function v_u_10.CanUseWeapon(p67, p68, p69, p70, p71)
    if not (p70 and (p68 and p69)) then
        return false
    end
    local v72 = p68:Get("WeaponPool")
    local v73 = p68:Get("WeaponPoolFilterType")
    local v74
    if v72 then
        if v73 == "Whitelist" then
            v74 = table.find(v72, p70)
        else
            v74 = false
        end
    else
        v74 = v72
    end
    if not (table.find(v_u_8:GetReleasedOwnableWeapons(v_u_5.WEAPON_EARLY_ACCESS_TIME_OFFSET), p70) or v74) then
        return false
    end
    if not (p69:GetWeaponData(p70) or p68:Get("IsInShootingRange") or (p68:Get("CanUseLockedWeapons") or p67:_CanUseWeaponFromFFlag(p70))) then
        return false
    end
    if v72 then
        if v73 == "Whitelist" and not table.find(v72, p70) then
            return false
        end
        if v73 == "Blacklist" and table.find(v72, p70) then
            return false
        end
    end
    return (not p71 or (v_u_7.SlotToClass[p71].Name == v_u_7.Items[p70].Class or p68:Get("WeaponClassRestrictionDisabled"))) and true or false
end
function v_u_10.GetSpread(_, p75, p76, p77, p78, p79, p80, p81)
    local v82 = math.min(p77 and p76 and p76 or 1, p78 and 0.75 or 1)
    local v83 = math.rad(p75) * v82
    if p81 and (p80 and (p80 > 1 and p79 == 1)) then
        return CFrame.identity
    elseif p81 and (p80 and (p80 > 1 and p79 ~= nil)) then
        local v84 = v83 / 0.75
        if p79 % 2 == 0 then
            return CFrame.Angles(0, 0, 6.283185307179586 / (p80 - 1) * p79) * CFrame.Angles(v84 / 2 / 2, 0, 0)
        else
            return CFrame.Angles(0, 0, 6.283185307179586 / (p80 - 1) * p79) * CFrame.Angles(v84 / 2, 0, 0)
        end
    else
        return CFrame.Angles(0, 0, 6.283185307179586 * math.random()) * CFrame.Angles(v83 * math.random(), 0, 0)
    end
end
function v_u_10.IsInWhitelist(_, p85, p86)
    for _, v87 in pairs(p86) do
        if p85 == v87 or v87:IsA("Instance") and p85:IsDescendantOf(v87) then
            return true
        end
    end
    return false
end
function v_u_10.GetRaycastWhitelist(p88, p89, p90, p91, p92)
    local v93 = p92 and {} or v_u_2:GetTagged("RaycastWhitelist" .. (p89 or ""))
    if not p90 then
        return v93
    end
    local v94 = p91 or {}
    local v95 = {}
    for _, v96 in pairs(v_u_2:GetTagged("Entity")) do
        local v97 = p88:GetEntityFromModel(v96)
        if not v94[v97] and (p90:IsValidTarget(v97) and v97:Get("EnvironmentID") == p89) then
            for _, v98 in pairs(v97:GetHitboxes(p90.GrabSmallHitboxes)) do
                table.insert(v93, v98)
                v95[v98] = v97
            end
        end
    end
    return v93, v95
end
function v_u_10.GetEntityFromModel(_, p99)
    if v_u_5.IS_SERVER then
        local v100 = require(v_u_3.Services.FighterService)
        local v101 = require(v_u_3.Services.EnemyService)
        local v102 = v100:GetFighter(p99)
        return v102 and v102.Entity or v101:GetEnemy(p99)
    end
    if v_u_5.IS_CLIENT then
        local v103 = require(v_u_4.LocalPlayer.PlayerScripts.Controllers.FighterController)
        local v104 = require(v_u_4.LocalPlayer.PlayerScripts.Controllers.EnemyController)
        local v105 = v103:GetFighter(p99)
        return v105 and v105.Entity or v104:GetEnemy(p99)
    end
end
function v_u_10.GetEntityFromTouch(p106, p107, p108, p109)
    local v110 = p106:GetEntityFromModel((p106:IsEntity(p109)))
    if v110 and (v110:Get("EnvironmentID") == p107 and p108:IsValidTarget(v110)) then
        return v110
    end
end
function v_u_10.GetEntitiesWithinSphere(p111, p112, p113, p114, p115, p116, p117, p118, p119, p120, p121)
    if p121 then
        local v122 = tonumber(p121) or (tonumber(false) or 30)
        local v123 = Instance.new("Part")
        v123.Color = Color3.fromRGB(255, 0, 0)
        v123.Material = Enum.Material.ForceField
        v123.CanTouch = false
        v123.CanCollide = false
        v123.CanQuery = false
        v123.CastShadow = false
        v123.Anchored = true
        v123.Shape = Enum.PartType.Ball
        v123.Size = Vector3.new(1, 1, 1) * p115 * 2
        v123.CFrame = CFrame.new(p114)
        v123.Parent = workspace
        v_u_6:AddItem(v123, v122)
        local v124 = Instance.new("Part")
        v124.Color = Color3.fromRGB(255, 0, 0)
        v124.Material = Enum.Material.Neon
        v124.CanTouch = false
        v124.CanCollide = false
        v124.CanQuery = false
        v124.CastShadow = false
        v124.Anchored = true
        v124.Shape = Enum.PartType.Ball
        v124.Size = Vector3.new(0.1, 0.1, 0.1)
        v124.CFrame = CFrame.new(p114)
        v124.Parent = workspace
        v_u_6:AddItem(v124, v122)
    end
    local v125 = OverlapParams.new()
    v125.FilterType = Enum.RaycastFilterType.Include
    v125.FilterDescendantsInstances = p111:GetRaycastWhitelist(p112, p113, nil, true)
    local v126 = not p116
    if v126 then
        v126 = p111:GetRaycastWhitelist(p112)
    end
    local v127 = not p116
    if v127 then
        v127 = Enum.RaycastFilterType.Include
    end
    local v128 = {}
    for _, v129 in pairs(workspace:GetPartBoundsInRadius(p114, p115, v125)) do
        local v130 = v129:GetAttribute("IsAssemblyRootPart") and v129 and v129 or (v129.AssemblyRootPart or v129)
        if not v128[v130] and (not p117 or (not p118 or ((p119 or 3) >= (v129.Position - p114).Magnitude or p118 >= v_u_9:AngleBetweenVectors(p117, v129.Position - p114)))) then
            local v131 = p111:GetEntityFromTouch(p112, p113, v129)
            if v131 and (v131:IsAlive() and (p116 or not v_u_9:Raycast(p114, v129.Position, (p114 - v129.Position).Magnitude, v126, v127).Instance)) then
                v128[v130] = true
                task.spawn(p120, v131, v129)
            end
        end
    end
end
function v_u_10.GetEntitiesFromPoint(p132, p133, p134, p135)
    local v_u_136 = {}
    p132:GetEntitiesWithinSphere(p133, p134, p135, 0, nil, nil, nil, nil, function(p137, p138)
        local v139 = v_u_136
        table.insert(v139, {
            ["Entity"] = p137,
            ["Hitbox"] = p138
        })
    end)
    return v_u_136
end
function v_u_10.GetEntitiesFromRaycast(p140, p141, p142, p143, p144, p145, p146, p147, p148)
    local v149 = p147 and v_u_9:CloneTable(p147, true) or {}
    local v150 = {}
    local v151 = p146 or 0
    local v152 = 1
    local v153 = nil
    local v154 = nil
    while v152 <= 1 + v151 do
        local v155, v156 = p140:GetRaycastWhitelist(p141, p142, v149)
        v154 = v_u_9:Raycast(p143, p143 + p144, p145, v155, Enum.RaycastFilterType.Include)
        local v157 = v156[v154.Instance]
        v153 = v153 or v154
        if not v157 then
            break
        end
        local v158 = {
            ["Entity"] = v157,
            ["Hitbox"] = v154.Instance,
            ["RaycastResult"] = v154
        }
        table.insert(v150, v158)
        v149[v157] = true
        if v157.Model:GetAttribute("PierceThrough") then
            v151 = v151 + 1
        end
        v152 = v152 + 1
    end
    for _, v159 in pairs(p140:GetEntitiesFromPoint(p141, p142, p143)) do
        v159.RaycastResult = v153
        table.insert(v150, 1, v159)
    end
    if v154 and p148 then
        local v160 = (v154.Position - p143).Magnitude
        local v161 = Instance.new("Part")
        v161.Color = Color3.fromRGB(255, 0, 0)
        v161.Material = Enum.Material.ForceField
        v161.CanTouch = false
        v161.CanCollide = false
        v161.CanQuery = false
        v161.CastShadow = false
        v161.Anchored = true
        v161.Size = Vector3.new(0.1, 0.1, v160)
        v161.CFrame = CFrame.new(p143, v154.Position) * CFrame.new(0, 0, -v160 / 2)
        v161.Parent = workspace
        v_u_6:AddItem(v161, 10)
    end
    return v150, v154
end
function v_u_10.GetJumpPadPlacement(p162, p163, p164, p165, p166, p167, p168)
    local v169 = p162:GetRaycastWhitelist(p163)
    if p167 then
        p167 = p167.CFrame * (p168 or CFrame.identity)
    end
    local v170
    if p167 then
        v170 = CFrame.new(p166.Position, p167.Position) or p166
    else
        v170 = p166
    end
    if v170 ~= v170 then
        v170 = CFrame.new(p166.Position)
    end
    local v171 = v_u_9:Raycast(v170.Position, v170.Position + v170.LookVector * v_u_5.MAX_RAYCAST_DISTANCE, v_u_5.MAX_RAYCAST_DISTANCE, v169, Enum.RaycastFilterType.Include)
    local v172 = v_u_9:Raycast(p165.Position, p165.Position + (v171.Position - p165.Position).Unit * p164, p164, v169, Enum.RaycastFilterType.Include)
    if v172.Instance and not (v172.Instance:HasTag("Barrier") or (v_u_9:IsWithinTaggedParts("Barrier", v172.Position) or v_u_10:IsWithinOOBPart(v172.Position))) then
        return v172, CFrame.new(v172.Position, v172.Position + v172.Normal) * CFrame.Angles(-1.5707963267948966, 0, 0) * CFrame.new(p165.Position * Vector3.new(1, 0, 1), v172.Position * Vector3.new(1, 0, 1)).Rotation * CFrame.Angles(1.5707963267948966, 0, 0)
    else
        return v172, nil
    end
end
function v_u_10.GetSubspaceTripminePlacement(_, p173, p174, p175)
    if not (p174:FuzzyEq(p175) and p174) then
        local v176 = (p174 - p175).Unit
        local v177 = (p174 - p175).Magnitude
        p174 = p175 + v176 * math.min(p173, v177)
    end
    local v178 = p174:FuzzyEq(p175) and CFrame.identity or CFrame.new(p174 * Vector3.new(1, 0, 1), p175 * Vector3.new(1, 0, 1))
    return CFrame.new(p174) * v178.Rotation
end
function v_u_10.GetOOBWarnDelay(p179, p180)
    local v181 = p180 or p179.OOB_DEFAULT_WARN_DELAY
    return v181 == -1 and (1 / 0) or v181
end
function v_u_10.GetOOBKillDelay(p182, p183)
    local v184 = p183 or p182.OOB_DEFAULT_KILL_DELAY
    return v184 == -1 and (1 / 0) or v184
end
function v_u_10.IsWithinOOBPart(p_u_185, p186, p187)
    if v_u_9:IsWithinTaggedParts("OutOfBoundsSafePart", p186) then
        return nil
    end
    local v188 = v_u_9:IsWithinTaggedParts("OutOfBoundsPart", p186, p187, true)
    table.sort(v188, function(p189, p190)
        return p_u_185:GetOOBWarnDelay(p189:GetAttribute("WarnDelay")) + p_u_185:GetOOBKillDelay(p189:GetAttribute("KillDelay")) < p_u_185:GetOOBWarnDelay(p190:GetAttribute("WarnDelay")) + p_u_185:GetOOBKillDelay(p190:GetAttribute("KillDelay"))
    end)
    return v188[1]
end
function v_u_10._CanUseWeaponFromFFlag(_, p_u_191)
    local v193, v194 = pcall(function()
        local v192
        if v_u_5.IS_SERVER then
            v192 = require(v_u_3.Services.FFlagService)
        else
            v192 = require(v_u_4.LocalPlayer.PlayerScripts.Controllers.FFlagController)
        end
        return v192:GetFFlag("FreeToUse" .. v_u_7.Items[p_u_191].Status .. "Weapons")
    end)
    if not v193 then
        warn("Failed to fetch FreeWeapons FFlag")
    end
    return v193 and v194
end
function v_u_10._Init(_) end
return v_u_10._new()