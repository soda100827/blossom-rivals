local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.CONSTANTS)
local v_u_4 = require(v_u_2.LocalPlayer.PlayerScripts.Modules.UILibrary)
local v_u_5 = v_u_2.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("ESPGui")
local v_u_6 = v_u_2.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("ESPSlot")
local v_u_7 = {}
v_u_7.__index = v_u_7
function v_u_7.new(p8)
    local v9 = v_u_7
    local v10 = setmetatable({}, v9)
    v10.FighterInterface = p8
    v10._esp_connections = {}
    v10._esp_slots = {}
    v10._esp_gui = nil
    v10._esp_gui_frame = nil
    v10._esp_gui_fov_frame = nil
    v10:_Init()
    return v10
end
function v_u_7.Refresh(p_u_11)
    p_u_11:Clear()
    if p_u_11.FighterInterface.ClientFighter:Get("CheaterMode") then
        p_u_11._esp_gui = p_u_11:_CreateGui()
        p_u_11._esp_gui_frame = p_u_11._esp_gui:WaitForChild("Frame")
        p_u_11._esp_gui_fov_frame = p_u_11._esp_gui_frame:WaitForChild("FOV")
        local v12 = p_u_11._esp_connections
        local v13 = v_u_2.PlayerRemoving
        table.insert(v12, v13:Connect(function(p14)
            if p_u_11._esp_slots[p14] then
                p_u_11._esp_slots[p14].Slot:Destroy()
                p_u_11._esp_slots[p14] = nil
            end
        end))
        local function v_u_35(p15)
            if p_u_11._esp_slots[p15] then
                p_u_11._esp_slots[p15].Slot:Destroy()
                p_u_11._esp_slots[p15] = nil
            end
            if p15 == v_u_2.LocalPlayer or v_u_2.LocalPlayer:GetAttribute("TeamID") and v_u_2.LocalPlayer:GetAttribute("TeamID") == p15:GetAttribute("TeamID") then
                return
            else
                local v_u_16 = p15.Character
                local v_u_17
                if v_u_16 then
                    v_u_17 = v_u_16:FindFirstChild("HumanoidRootPart")
                else
                    v_u_17 = v_u_16
                end
                if v_u_16 then
                    v_u_16 = v_u_16:FindFirstChild("Humanoid")
                end
                if v_u_17 and (v_u_16 and v_u_16.Health > 0) then
                    local v_u_18 = v_u_6:Clone()
                    v_u_18.Parent = p_u_11._esp_gui_frame
                    local v_u_19 = v_u_18.Line
                    local v34 = {
                        ["Slot"] = v_u_18,
                        ["Update"] = function(_)
                            local v20, _ = workspace.CurrentCamera:WorldToScreenPoint(v_u_17.Position)
                            local v21 = v_u_4:ScreenPointToPosition(Vector2.new(v20.X, v20.Y), p_u_11._esp_gui_frame.AbsolutePosition)
                            local v22 = v_u_18
                            local v23
                            if v20.Z >= 0 and v20.Z < v_u_3.RENDER_DISTANCE then
                                v23 = v_u_16.Health > 0
                            else
                                v23 = false
                            end
                            v22.Visible = v23
                            if v_u_18.Visible then
                                local v24 = p_u_11._esp_gui_fov_frame.AbsolutePosition + p_u_11._esp_gui_fov_frame.AbsoluteSize / 2
                                local v25 = (v24.X - v20.X) ^ 2 + (v24.Y - v20.Y) ^ 2
                                local v26 = math.sqrt(v25)
                                local v27 = v20.X - v24.X
                                local v28 = v20.Y - v24.Y
                                local v29 = 4.71238898038469 - math.atan2(v27, v28)
                                v_u_18.Position = UDim2.new(0, v21.X, 0, v21.Y)
                                v_u_19.Size = UDim2.new(0, v26, 0, 0)
                                v_u_19.Position = UDim2.new(0.5, math.cos(v29) * v26 / 2, 0.5, math.sin(v29) * v26 / 2)
                                v_u_19.Rotation = math.deg(v29)
                                local v30 = workspace.CurrentCamera:WorldToScreenPoint(v_u_17.Position + Vector3.new(0, 2, 0))
                                local v31 = workspace.CurrentCamera:WorldToScreenPoint(v_u_17.Position - Vector3.new(0, 3, 0))
                                local v32 = v30.Y - v31.Y
                                local v33 = math.abs(v32)
                                v_u_18.Size = UDim2.new(0, v33 * 0.8, 0, v33)
                            end
                        end
                    }
                    p_u_11._esp_slots[p15] = v34
                end
            end
        end
        local function v42(p_u_36)
            local function v37()
                p_u_36:WaitForChild("HumanoidRootPart", 3)
                v_u_35(p_u_36)
            end
            local v38 = p_u_11._esp_connections
            local v39 = p_u_36:GetAttributeChangedSignal("TeamID")
            table.insert(v38, v39:Connect(v37))
            local v40 = p_u_11._esp_connections
            local v41 = p_u_36.CharacterAdded
            table.insert(v40, v41:Connect(v37))
            task.defer(v37)
        end
        local v43 = p_u_11._esp_connections
        local v44 = v_u_2.PlayerAdded
        table.insert(v43, v44:Connect(v42))
        for _, v45 in pairs(v_u_2:GetPlayers()) do
            task.defer(v42, v45)
        end
        local function v47()
            for _, v46 in pairs(v_u_2:GetPlayers()) do
                v_u_35(v46)
            end
        end
        local v48 = p_u_11._esp_connections
        local v49 = v_u_2.LocalPlayer:GetAttributeChangedSignal("TeamID")
        table.insert(v48, v49:Connect(v47))
        p_u_11._esp_gui.Parent = v_u_2.LocalPlayer.PlayerGui
    end
end
function v_u_7.Update(p50, p51, _)
    if p50._esp_gui then
        local v52 = v_u_4:ScreenPointToPosition(p50.FighterInterface.ClientFighter:GetMouseLocation(), p50._esp_gui_frame.AbsolutePosition)
        p50._esp_gui_fov_frame.Position = UDim2.new(0, v52.X, 0, v52.Y)
        for _, v53 in pairs(p50._esp_slots) do
            if v_u_3.IS_STUDIO then
                v53.Update(p51)
            else
                pcall(v53.Update, p51)
            end
        end
    end
end
function v_u_7.Clear(p54)
    for _, v55 in pairs(p54._esp_connections) do
        v55:Disconnect()
    end
    for _, v56 in pairs(p54._esp_slots) do
        v56.Slot:Destroy()
    end
    p54._esp_connections = {}
    p54._esp_slots = {}
    if p54._esp_gui then
        p54._esp_gui:Destroy()
        p54._esp_gui = nil
    end
end
function v_u_7.Destroy(p57)
    p57:Clear()
end
function v_u_7._CreateGui(p_u_58)
    local v_u_59 = v_u_5:Clone()
    local function v_u_62()
        local v60 = v_u_59
        local v61 = p_u_58.FighterInterface.Frame.Visible
        if v61 then
            v61 = p_u_58.FighterInterface.Frame.Parent
        end
        v60.Enabled = v61
    end
    local v63 = p_u_58._esp_connections
    local v64 = p_u_58.FighterInterface.Frame:GetPropertyChangedSignal("Visible")
    table.insert(v63, v64:Connect(v_u_62))
    local v65 = p_u_58.FighterInterface.Frame.Visible
    if v65 then
        v65 = p_u_58.FighterInterface.Frame.Parent
    end
    v_u_59.Enabled = v65
    local v66 = p_u_58._esp_connections
    local v67 = p_u_58.FighterInterface.Frame.AncestryChanged
    table.insert(v66, v67:Connect(function()
        if p_u_58.FighterInterface.Frame.Parent then
            local v68 = p_u_58._esp_connections
            local v69 = p_u_58.FighterInterface.Frame.Parent:GetPropertyChangedSignal("Visible")
            local v70 = v_u_62
            table.insert(v68, v69:Connect(v70))
            local v71 = v_u_59
            local v72 = p_u_58.FighterInterface.Frame.Visible
            if v72 then
                v72 = p_u_58.FighterInterface.Frame.Parent
            end
            v71.Enabled = v72
        end
    end))
    if not p_u_58.FighterInterface.Frame.Parent then
        return v_u_59
    end
    local v73 = p_u_58._esp_connections
    local v74 = p_u_58.FighterInterface.Frame.Parent:GetPropertyChangedSignal("Visible")
    table.insert(v73, v74:Connect(v_u_62))
    local v75 = p_u_58.FighterInterface.Frame.Visible
    if v75 then
        v75 = p_u_58.FighterInterface.Frame.Parent
    end
    v_u_59.Enabled = v75
    return v_u_59
end
function v_u_7._Init(_) end
return v_u_7