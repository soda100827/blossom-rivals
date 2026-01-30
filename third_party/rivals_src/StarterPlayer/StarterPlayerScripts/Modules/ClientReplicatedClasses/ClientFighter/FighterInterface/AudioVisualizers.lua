local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.BetterDebris)
local v_u_4 = require(v1.Modules.Utility)
local v_u_5 = require(v1.Modules.Spring)
local v_u_6 = v2.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("AudioVisualizerIcon")
local v_u_7 = { "rbxassetid://131616644976154", "rbxassetid://101856596290673", "rbxassetid://78940013186909" }
local v_u_8 = {}
v_u_8.__index = v_u_8
function v_u_8.new(p9)
    local v10 = v_u_8
    local v11 = setmetatable({}, v10)
    v11.FighterInterface = p9
    v11.Frame = v11.FighterInterface.Frame:WaitForChild("AudioVisualizers")
    v11._current_visualizers = {}
    v11:_Init()
    return v11
end
function v_u_8.Create(p_u_12, p_u_13, p_u_14, p_u_15)
    if p_u_12.FighterInterface:IsActive() then
        local v16 = p_u_12:_GetSourcePosition(p_u_13)
        if v16 then
            local v17 = p_u_12.FighterInterface.ClientFighter.Entity
            if v17 then
                v17 = (v16 - p_u_12.FighterInterface.ClientFighter.Entity.RootPart.Position).Magnitude <= 4
            end
            if not v17 and p_u_12:_GetEffectiveVolume(v16, p_u_14, p_u_15) > 0 then
                for v18, v19 in pairs(p_u_12._current_visualizers) do
                    if v19.Source == p_u_13 or v19.Source2 == p_u_13 then
                        v18:Destroy()
                        p_u_12._current_visualizers[v18] = nil
                    end
                end
                local v_u_20 = v_u_6:Clone()
                v_u_20.Parent = p_u_12.Frame
                v_u_3:AddItem(v_u_20, 30)
                local v_u_21 = false
                local _ = workspace.CurrentCamera.CFrame
                local v_u_22 = v16
                local v_u_23 = v_u_5.new(0, 1, 40)
                local v_u_24 = v_u_5.new(0.5, 1, 40)
                local v_u_25 = nil
                local v_u_26 = 0
                local v_u_27 = 0
                local v_u_28 = false
                local function v54(p29)
                    local v30 = p_u_12:_GetSourcePosition(p_u_13)
                    if v30 then
                        v_u_22 = v_u_22
                    else
                        v_u_28 = true
                        v30 = v_u_22
                    end
                    local v31 = workspace.CurrentCamera.CFrame
                    local v32 = (v30 - v31.Position) * Vector3.new(1, 0, 1)
                    local v33 = v31.LookVector * Vector3.new(1, 0, 1)
                    local v34 = v33.Magnitude <= 0.01 and Vector3.new(1, 0, 0) or v33.Unit
                    if v32 == v32 and v32.Magnitude ~= 0 then
                        v_u_20.Visible = true
                        local v35 = v32:Dot(v34) / v32.Magnitude
                        local v36 = math.acos(v35)
                        local v37 = v34:Cross(v32).Y
                        local v38 = math.sign(v37)
                        local v39 = v_u_23
                        if v38 == 1 then
                            v36 = 6.283185307179586 - v36 or v36
                        end
                        v39.Target = v36 + 1.5707963267948966
                        local v40 = v_u_24
                        local v41 = (v32.Magnitude - 5) / 25
                        local v42 = 0.5 / math.max(1, v41)
                        v40.Target = math.max(0.125, v42)
                        if p29 then
                            if v_u_25 then
                                local v43 = v_u_23.Target - v_u_25
                                if v43 > 3.141592653589793 then
                                    local v44 = v_u_23
                                    v44.Value = v44.Value + 6.283185307179586
                                elseif v43 < -3.141592653589793 then
                                    local v45 = v_u_23
                                    v45.Value = v45.Value - 6.283185307179586
                                end
                            end
                        else
                            v_u_24.Value = v_u_24.Target
                            v_u_23.Value = v_u_23.Target
                        end
                        local v46 = Vector2.new(0.5, 0.5)
                        local v47 = Vector2.new
                        local v48 = v_u_23.Value
                        local v49 = math.cos(v48)
                        local v50 = v_u_23.Value
                        local v51 = v46 - v47(v49, (math.sin(v50))) * 0.75 / 2
                        v_u_20.Position = UDim2.new(v51.X, 0, v51.Y, 0)
                        local v52 = v_u_20
                        local v53 = v_u_23.Value - 1.5707963267948966
                        v52.Rotation = math.deg(v53)
                        v_u_20.Size = UDim2.new(v_u_24.Value, 0, v_u_24.Value, 0)
                        if not v_u_21 then
                            v_u_20.ImageTransparency = v_u_6.ImageTransparency + (1 - v_u_6.ImageTransparency) * (1 - p_u_12:_GetEffectiveVolume(v30, p_u_14, p_u_15))
                        end
                        v_u_25 = v_u_23.Target
                        if v_u_27 < tick() then
                            v_u_27 = tick() + 0.04
                            v_u_26 = v_u_26 + 1
                            v_u_20.Image = v_u_7[v_u_26 % #v_u_7 + 1]
                        end
                    else
                        v_u_20.Visible = false
                    end
                end
                local v55 = p_u_12._current_visualizers
                local v56 = {
                    ["Source"] = p_u_13,
                    ["Update"] = v54
                }
                local v57 = typeof(p_u_13) == "Instance" and p_u_13:IsA("Sound")
                if v57 then
                    v57 = p_u_13.Parent
                end
                v56.Source2 = v57
                v55[v_u_20] = v56
                v54(nil)
                wait(0)
                v_u_21 = true
                local v_u_58 = v_u_20.ImageTransparency
                v_u_4:RenderstepForLoop(0, 100, 4, function(p59)
                    v_u_20.ImageTransparency = v_u_58 + (1 - v_u_58) * (1 - (1 - p59 / 100) ^ 4)
                end)
                v_u_20:Destroy()
                p_u_12._current_visualizers[v_u_20] = nil
            end
        else
            return
        end
    else
        return
    end
end
function v_u_8.Update(p60, p61, _)
    for _, v62 in pairs(p60._current_visualizers) do
        pcall(v62.Update, p61)
    end
end
function v_u_8.Clear(p63)
    for v64 in pairs(p63._current_visualizers) do
        v64:Destroy()
    end
    p63._current_visualizers = {}
end
function v_u_8.Destroy(p65)
    p65:Clear()
end
function v_u_8._GetSourcePosition(_, p66)
    if typeof(p66) == "Vector3" then
        return p66
    end
    if p66:IsA("BasePart") then
        return p66.Position
    end
    if p66.Parent and p66.Parent:IsA("BasePart") then
        return p66.Parent.Position
    end
end
function v_u_8._GetEffectiveVolume(_, p67, p68, p69)
    local v70 = ((workspace.CurrentCamera.CFrame.Position - p67).Magnitude - p68) / (p69 - p68)
    return (1 - math.clamp(v70, 0, 1)) ^ 2
end
function v_u_8._Init(_) end
return v_u_8