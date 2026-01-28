local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.CONSTANTS)
local v_u_4 = require(v1.Modules.BetterDebris)
local v_u_5 = require(v1.Modules.Utility)
local v_u_6 = require(v2.LocalPlayer.PlayerScripts.Controllers.CameraController)
local v_u_7 = v2.LocalPlayer.PlayerScripts.Assets:WaitForChild("Misc"):WaitForChild("MushroomCloud")
local function v_u_13(p8)
    local v9 = (p8 - workspace.CurrentCamera.CFrame.Position).Unit
    local v10 = p8 - v9
    local v11 = p8 + v9 * 8
    local v12 = v_u_5:Raycast(v10, v11, (v10 - v11).Magnitude)
    if v12.Normal then
        return CFrame.new(Vector3.new(0, 0, 0), v12.Normal) * CFrame.Angles(-1.5707963267948966, 0, 0)
    else
        return CFrame.identity
    end
end
return function(p14, p15, p16, p17, p18, p19, p20)
    local v21 = 5 * (p16 or 1)
    local v22 = p18 or 64
    local v23 = (workspace.CurrentCamera.CFrame.Position - p14).Magnitude
    if v_u_3.RENDER_DISTANCE >= v23 then
        v_u_5:CreateSound("rbxassetid://13455969017", 0.5, 0.9 + 0.2 * math.random(), p14, true, 10, p19, p20)
        v_u_5:CreateSound("rbxassetid://17641561917", 1.5, 0.9 + 0.2 * math.random(), p14, true, 10, p19, p20)
        if v23 <= v22 then
            local v24 = 1 - v23 / v22
            local v25 = math.max(0, v24)
            v_u_6:ShakeOnce(v25 * 50, v25 * 10 / v21, 0.1 / v21, 0.4 / v21, Vector3.new(0.25, 0.25, 0), Vector3.new(0, 0, 0))
        end
        local v_u_26 = p15 / 40
        local v27 = CFrame.new(p14)
        local v28
        if p17 then
            v28 = v_u_13(p14)
        else
            v28 = CFrame.identity
        end
        local v_u_29 = v27 * v28
        local v_u_30 = -5 * v_u_26
        local v_u_31 = v_u_7:Clone()
        v_u_31.Parent = workspace
        v_u_31:SetPrimaryPartCFrame(v_u_29)
        v_u_4:AddItem(v_u_31, 25 / v21)
        v_u_31.Fire.PointLight.Range = p15 * 3
        v_u_5:PlayParticles(v_u_31.Fire)
        local v_u_32 = (math.random(1, 2) - 1.5) * 2
        v_u_5:RenderstepForLoop(0, 100, 0.5 * v21, function(p33)
            local v34 = 1 - (1 - p33 / 100) ^ 5
            local v35 = p33 / 100
            local v36 = v34 * 3
            local v37 = v35 * 3
            local v38 = 1 + (1 - v34)
            v_u_31.Cloud.Size = Vector3.new(14.711, 14.091, 13.818) * v36 * v_u_26
            v_u_31.Fire.Size = Vector3.new(14.007, 14.026, 13.543) * v36 * v_u_26
            v_u_31.Ring.Size = Vector3.new(14.9445, 2.697, 14.778) * v37 * v_u_26
            local v39 = v_u_31.Cloud
            local v40 = v_u_29 * CFrame.new(0, v_u_31.Cloud.Size.Y / 2 + v_u_30, 0) * CFrame.Angles(0, tick() * 0.25 * v_u_32 % 6.283185307179586, 0)
            local v41 = math.random() - 0.5
            local v42 = math.random() - 0.5
            local v43 = math.random() - 0.5
            v39.CFrame = v40 + Vector3.new(v41, v42, v43) * 0.25 * (v38 or 1)
            local v44 = v_u_31.Fire
            local v45 = v_u_31.Cloud.CFrame
            local v46 = math.random() - 0.5
            local v47 = math.random() - 0.5
            local v48 = math.random() - 0.5
            v44.CFrame = v45 + Vector3.new(v46, v47, v48) * 0.25 * (v38 or 1)
            local v49 = v_u_31.Ring
            local v50 = v_u_31.Cloud.CFrame * CFrame.new(0, -1.815, 0)
            local v51 = math.random() - 0.5
            local v52 = math.random() - 0.5
            local v53 = math.random() - 0.5
            v49.CFrame = v50 + Vector3.new(v51, v52, v53) * 0.25 * (v38 or 1)
        end)
        v_u_5:RenderstepForLoop(0, 100, 0.5 * v21, function(p54)
            local v55 = p54 / 100
            local v56 = (1 + v55 / 2) * 3
            v_u_31.Fire.Transparency = v55
            v_u_31.Ring.Transparency = v55 / 2
            v_u_31.Ring.Size = Vector3.new(14.9445, 2.697, 14.778) * v56 * v_u_26
            local v57 = v_u_31.Cloud
            local v58 = v_u_29 * CFrame.new(0, v_u_31.Cloud.Size.Y / 2 + v_u_30, 0) * CFrame.Angles(0, tick() * 0.25 * v_u_32 % 6.283185307179586, 0)
            local v59 = math.random() - 0.5
            local v60 = math.random() - 0.5
            local v61 = math.random() - 0.5
            v57.CFrame = v58 + Vector3.new(v59, v60, v61) * 0.25 * 1
            local v62 = v_u_31.Fire
            local v63 = v_u_31.Cloud.CFrame
            local v64 = math.random() - 0.5
            local v65 = math.random() - 0.5
            local v66 = math.random() - 0.5
            v62.CFrame = v63 + Vector3.new(v64, v65, v66) * 0.25 * 1
            local v67 = v_u_31.Ring
            local v68 = v_u_31.Cloud.CFrame * CFrame.new(0, -1.815, 0)
            local v69 = math.random() - 0.5
            local v70 = math.random() - 0.5
            local v71 = math.random() - 0.5
            v67.CFrame = v68 + Vector3.new(v69, v70, v71) * 0.25 * 1
        end)
        v_u_5:RenderstepForLoop(0, 100, 1 * v21, function(p72)
            local v73 = p72 / 100
            local v74 = (1.5 + v73 / 2) * 3
            v_u_31.Cloud.Transparency = v73
            v_u_31.Ring.Transparency = 0.5 + v73 / 2
            v_u_31.Ring.Size = Vector3.new(14.9445, 2.697, 14.778) * v74 * v_u_26
            local v75 = v_u_31.Cloud
            local v76 = v_u_29 * CFrame.new(0, v_u_31.Cloud.Size.Y / 2 + v_u_30, 0) * CFrame.Angles(0, tick() * 0.25 * v_u_32 % 6.283185307179586, 0)
            local v77 = math.random() - 0.5
            local v78 = math.random() - 0.5
            local v79 = math.random() - 0.5
            v75.CFrame = v76 + Vector3.new(v77, v78, v79) * 0.25 * 1
            local v80 = v_u_31.Ring
            local v81 = v_u_31.Cloud.CFrame * CFrame.new(0, -1.815, 0)
            local v82 = math.random() - 0.5
            local v83 = math.random() - 0.5
            local v84 = math.random() - 0.5
            v80.CFrame = v81 + Vector3.new(v82, v83, v84) * 0.25 * 1
        end)
        v_u_31:Destroy()
    end
end