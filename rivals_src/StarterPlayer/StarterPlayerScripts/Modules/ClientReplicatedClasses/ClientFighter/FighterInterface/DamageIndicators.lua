local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.BetterDebris)
local v_u_4 = require(v1.Modules.Utility)
local v_u_5 = require(v1.Modules.Spring)
local v_u_6 = v2.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("DamageIndicatorIcon")
local v_u_7 = {}
v_u_7.__index = v_u_7
function v_u_7.new(p8)
    local v9 = v_u_7
    local v10 = setmetatable({}, v9)
    v10.FighterInterface = p8
    v10.Frame = v10.FighterInterface.Frame:WaitForChild("DamageIndicators")
    v10._current_damage_indicators = {}
    v10:_Init()
    return v10
end
function v_u_7.Create(p11, p12)
    local v13 = p12[utf8.char(2)]
    if v13 and (p12[utf8.char(0)] ~= 0 and p11.FighterInterface:IsActive()) then
        for v14, v15 in pairs(p11._current_damage_indicators) do
            if v15.Source == v13 then
                v14:Destroy()
                p11._current_damage_indicators[v14] = nil
            end
        end
        local v16 = typeof(v13) == "Instance"
        local v_u_17 = v_u_5.new(0, 1, 40)
        local v_u_18 = v_u_5.new(0.5, 1, 40)
        local v_u_19 = v_u_6:Clone()
        v_u_19.Parent = p11.Frame
        v_u_3:AddItem(v_u_19, 10)
        local v_u_20
        if v16 then
            v_u_20 = v13.Position or v13
        else
            v_u_20 = v13
        end
        local v_u_21 = nil
        local function v45(p22)
            local v23 = (v_u_20 - workspace.CurrentCamera.CFrame.Position) * Vector3.new(1, 0, 1)
            local v24 = workspace.CurrentCamera.CFrame.LookVector * Vector3.new(1, 0, 1)
            local v25 = v24.Magnitude <= 0.01 and Vector3.new(1, 0, 0) or v24.Unit
            if v23 == v23 and v23.Magnitude ~= 0 then
                v_u_19.Visible = true
                local v26 = v23:Dot(v25) / v23.Magnitude
                local v27 = math.acos(v26)
                local v28 = v25:Cross(v23).Y
                local v29 = math.sign(v28)
                local v30 = v_u_17
                if v29 == 1 then
                    v27 = 6.283185307179586 - v27 or v27
                end
                v30.Target = v27 + 1.5707963267948966
                local v31 = v_u_18
                local v32 = (v23.Magnitude - 5) / 25
                local v33 = 0.5 / math.max(1, v32)
                v31.Target = math.max(0.125, v33)
                if p22 then
                    if v_u_21 then
                        local v34 = v_u_17.Target - v_u_21
                        if v34 > 3.141592653589793 then
                            local v35 = v_u_17
                            v35.Value = v35.Value + 6.283185307179586
                        elseif v34 < -3.141592653589793 then
                            local v36 = v_u_17
                            v36.Value = v36.Value - 6.283185307179586
                        end
                    end
                else
                    v_u_18.Value = v_u_18.Target
                    v_u_17.Value = v_u_17.Target
                end
                local v37 = Vector2.new(0.5, 0.5)
                local v38 = Vector2.new
                local v39 = v_u_17.Value
                local v40 = math.cos(v39)
                local v41 = v_u_17.Value
                local v42 = v37 - v38(v40, (math.sin(v41))) * 0.75 / 2
                v_u_19.Position = UDim2.new(v42.X, 0, v42.Y, 0)
                local v43 = v_u_19
                local v44 = v_u_17.Value - 1.5707963267948966
                v43.Rotation = math.deg(v44)
                v_u_19.Size = UDim2.new(v_u_18.Value, 0, v_u_18.Value, 0)
                v_u_21 = v_u_17.Target
            else
                v_u_19.Visible = false
            end
        end
        p11._current_damage_indicators[v_u_19] = {
            ["Source"] = v13,
            ["Update"] = v45
        }
        v45(nil)
        wait(5)
        v_u_4:RenderstepForLoop(0, 100, 4, function(p46)
            v_u_19.ImageTransparency = (p46 / 100) ^ 4
        end)
        v_u_19:Destroy()
        p11._current_damage_indicators[v_u_19] = nil
    end
end
function v_u_7.Update(p47, p48, _)
    for _, v49 in pairs(p47._current_damage_indicators) do
        pcall(v49.Update, p48)
    end
end
function v_u_7.Clear(p50)
    for v51 in pairs(p50._current_damage_indicators) do
        v51:Destroy()
    end
    p50._current_damage_indicators = {}
end
function v_u_7.Destroy(p52)
    p52:Clear()
end
function v_u_7._Init(_) end
return v_u_7