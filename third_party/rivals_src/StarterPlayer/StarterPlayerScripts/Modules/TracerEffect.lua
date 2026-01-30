local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.CONSTANTS)
local v_u_4 = require(v1.Modules.BetterDebris)
local v_u_5 = require(v1.Modules.Utility)
local v_u_6 = v2.LocalPlayer.PlayerScripts.Assets.Misc:WaitForChild("TracerEffect")
local v_u_7 = ColorSequence.new(Color3.fromRGB(255, 81, 0))
local v_u_8 = ColorSequence.new(Color3.fromRGB(255, 8, 0))
return {
    ["VerifyTracerData"] = function(_, p9, p10, p11)
        local v12 = p9 or {}
        v12.RaycastResults = v12.RaycastResults or {}
        v12.IsLocal = v12.IsLocal or false
        v12.IsEnemy = v12.IsEnemy or false
        local v13 = p10 or {}
        v13.EnemyColor = v13.EnemyColor or nil
        v13.Color = v13.Color or nil
        v13.BeamProperties = v13.BeamProperties or nil
        v13.MaxLengthFirstPerson = v13.MaxLengthFirstPerson or nil
        v13.MaxLength = v13.MaxLength or nil
        v13.NoDistanceDelay = v13.NoDistanceDelay or nil
        v13.Template = v13.Template or nil
        v13.InitCallback = v13.InitCallback or nil
        v13.UpdateSpeed = v13.UpdateSpeed or nil
        v13.CustomUpdate = v13.CustomUpdate or nil
        v13.PlayFlyBySound = v13.PlayFlyBySound or nil
        local v14 = p11 or {}
        v14.FriendlyTracerColor = v14.FriendlyTracerColor or v_u_7
        v14.ActuallyFirstPerson = v14.ActuallyFirstPerson or false
        v14.MuzzlePosition = v14.MuzzlePosition or nil
        return v12, v13, v14
    end,
    ["Play"] = function(p15, p16, p17, p18)
        local v_u_19, v_u_20, v_u_21 = p15:VerifyTracerData(p16, p17, p18)
        if v_u_21.MuzzlePosition then
            local v22 = {}
            for _, v25 in pairs(v_u_19.RaycastResults) do
                if not v_u_19.IsLocal then
                    local v24 = v25
                    while v25.LastRaycastResult do
                        local v25 = v25.LastRaycastResult
                    end
                    v22[v25] = v22[v25] or {}
                    local v26 = v22[v25]
                    table.insert(v26, v24)
                end
            end
            for _, v27 in pairs(v22) do
                local v28 = nil
                local v29 = nil
                for _, v30 in pairs(v27) do
                    local v31 = v30.StartPosition or v_u_21.MuzzlePosition
                    local v32 = Ray.new(v31, (v30.Position - v31).Unit):ClosestPoint(workspace.CurrentCamera.CFrame.Position)
                    if not v28 or (v32 - workspace.CurrentCamera.CFrame.Position).Magnitude < (v28 - workspace.CurrentCamera.CFrame.Position).Magnitude then
                        v29 = v31
                        v28 = v32
                    end
                end
                if v28 then
                    local v33 = (v28 - v29).Magnitude
                    if v33 > 1 and v33 < v_u_3.RENDER_DISTANCE then
                        local v34 = 1 - ((v28 - workspace.CurrentCamera.CFrame.Position).Magnitude / 50) ^ 3
                        if v_u_20.PlayFlyBySound then
                            v_u_20.PlayFlyBySound(v28, v34, 50)
                        else
                            v_u_5:CreateSound("rbxassetid://14767954026", 1 * v34, 1.4 + 0.2 * math.random(), v28, true, 10, 50, 50)
                        end
                    end
                end
            end
            local v_u_35
            if v_u_21.ActuallyFirstPerson then
                v_u_35 = v_u_20.MaxLengthFirstPerson or 75
            else
                v_u_35 = v_u_20.MaxLength or 15
            end
            for v_u_36, v_u_37 in pairs(v_u_19.RaycastResults) do
                task.defer(function()
                    local v38 = v_u_37
                    local v39 = 0
                    while v38 and (v38.LastRaycastResult and not v_u_20.NoDistanceDelay) do
                        v39 = v39 + ((v38.StartPosition or v_u_21.MuzzlePosition) - v_u_37.Position).Magnitude
                        v38 = v38.LastRaycastResult
                    end
                    if v39 > 0 then
                        wait(1.6666666666666667 / (800 / v39))
                    end
                    local v_u_40 = v_u_37.StartPosition or v_u_21.MuzzlePosition
                    local v41 = (v_u_40 - v_u_37.Position).Magnitude
                    local v_u_42 = (v_u_20.Template or v_u_6):Clone()
                    v_u_42.CFrame = CFrame.identity
                    v_u_42.Parent = workspace
                    v_u_4:AddItem(v_u_42, 10)
                    if v_u_20.InitCallback then
                        v_u_20.InitCallback(v_u_42, v_u_36)
                    else
                        local v43 = v_u_42.Beam
                        local v44
                        if v_u_19.IsEnemy then
                            v44 = v_u_20.EnemyColor or v_u_8
                        else
                            v44 = v_u_20.Color or v_u_21.FriendlyTracerColor
                        end
                        v43.Color = v44
                        v_u_42.Attachment1.PointLight.Color = v_u_42.Beam.Color.Keypoints[1].Value
                        for v45, v46 in pairs(v_u_20.BeamProperties or {}) do
                            v_u_42.Beam[v45] = v46
                        end
                    end
                    local v_u_47 = v_u_42.Attachment0
                    local v_u_48 = v_u_42.Attachment1
                    v_u_5:RenderstepForLoop(0, 100, v_u_20.UpdateSpeed or 800 / v41, function(p49)
                        local v50 = p49 / 100
                        if v_u_20.CustomUpdate then
                            v_u_20.CustomUpdate(v_u_42, v_u_47, v_u_48, v50, v_u_40, v_u_37.Position)
                        else
                            v_u_48.WorldPosition = v_u_40:Lerp(v_u_37.Position, v50)
                            local v51 = v_u_47
                            local v52 = v_u_48.WorldPosition
                            local v53 = (v_u_37.Position - v_u_40).Unit
                            local v54 = (v_u_48.WorldPosition - v_u_37.Position).Magnitude
                            local v55 = v_u_35
                            v51.WorldPosition = v52 + v53 * math.min(v54, v55)
                        end
                    end)
                    v_u_42:Destroy()
                end)
            end
        end
    end
}