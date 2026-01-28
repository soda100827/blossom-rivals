local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.SoundLibrary)
local v_u_4 = require(v1.Modules.BetterDebris)
local v_u_5 = require(v1.Modules.DuelLibrary)
local v_u_6 = require(v1.Modules.Utility)
local v_u_7 = require(v_u_2.LocalPlayer.PlayerScripts.Controllers.ComplianceController)
local v_u_8 = require(v_u_2.LocalPlayer.PlayerScripts.Modules.UILibrary)
local v_u_9 = v_u_2.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("EliminationSlot")
local v_u_10 = {}
v_u_10.__index = v_u_10
function v_u_10.new(p11)
    local v12 = v_u_10
    local v13 = setmetatable({}, v12)
    v13.FighterInterface = p11
    v13.Frame = v13.FighterInterface.Frame:WaitForChild("EliminationSlots")
    v13._destroyed = false
    v13._connections = {}
    v13._reference_frame = v_u_8:GetTo("MainFrame", "BottomStack", "EliminationSlots")
    v13._elimination_queue = {}
    v13._elimination_queue_playing = false
    v13._elimination_chain = 0
    v13:_Init()
    return v13
end
function v_u_10.SetVisible(p14, p15)
    p14.Frame.Visible = p15
end
function v_u_10.Refresh(p16)
    p16.Frame.Position = UDim2.new(0.5, 0, 0, p16._reference_frame.AbsolutePosition.Y)
end
function v_u_10.Clear(p17)
    p17._elimination_chain = 0
end
function v_u_10.Create(p_u_18, ...)
    if p_u_18.FighterInterface:IsActive() then
        local v19 = p_u_18._elimination_queue
        table.insert(v19, { ... })
        if not p_u_18._elimination_queue_playing then
            p_u_18._elimination_queue_playing = true
            while #p_u_18._elimination_queue > 0 do
                local v20 = table.remove
                local v21 = p_u_18._elimination_queue
                local v22, v23 = table.unpack(v20(v21, 1))
                if v22 ~= v_u_2.LocalPlayer then
                    p_u_18._elimination_chain = p_u_18._elimination_chain + 1
                    local v24 = p_u_18._elimination_chain - 3
                    local v25 = math.clamp(v24, 0, 10)
                    local v26 = p_u_18.FighterInterface
                    local v27 = v_u_3.EliminationSounds
                    local v28 = p_u_18._elimination_chain
                    v26:CreateSound(v27[math.min(v28, 3)], v25 * 0.25 + 2, v25 * 0.1 + 1, script, true, 10)
                    local v29 = v_u_5:GetTeamColor(p_u_18.FighterInterface.ClientFighter:Get("TeamID"))
                    local v30 = string.format("%s,%s,%s", string.format("%.0f", v29.R * 255), string.format("%.0f", v29.G * 255), string.format("%.0f", v29.B * 255))
                    local v31 = v_u_7:GetName(p_u_18.FighterInterface.ClientFighter.Player)
                    local v32 = not p_u_18.FighterInterface.ClientFighter.IsLocalPlayer
                    if v32 then
                        v32 = string.format("<stroke color=\"rgb(0,0,0)\" joins=\"round\" thickness=\"3\" transparency=\"0\"><font color=\"rgb(%s)\"><font weight=\"800\">%s</font></font></stroke>  ", v30, v31)
                    end
                    local v33 = v23 and "Assist" or "Eliminated"
                    local v34 = v_u_5:GetTeamColor(v22:GetAttribute("TeamID"))
                    local v35 = string.format("%s,%s,%s", string.format("%.0f", v34.R * 255), string.format("%.0f", v34.G * 255), string.format("%.0f", v34.B * 255))
                    local v36 = v_u_7:GetName(v22)
                    local v37 = string.format
                    local v38 = "<stroke color=\"rgb(0,0,0)\" joins=\"round\" thickness=\"1\" transparency=\"0.75\"><font weight=\"500\">%s  </font></stroke><stroke color=\"rgb(0,0,0)\" joins=\"round\" thickness=\"3\" transparency=\"0\"><font color=\"rgb(%s)\"><font weight=\"800\">%s</font></font></stroke>"
                    if v32 then
                        v33 = string.lower(v33) or v33
                    end
                    local v39 = v37(v38, v33, v35, v36)
                    local v_u_40 = v_u_9:Clone()
                    v_u_40.LayoutOrder = p_u_18._elimination_chain
                    v_u_40.TextLabel.Text = (v32 or "") .. v39
                    v_u_40.Size = UDim2.new(1, 0, 0, 0)
                    v_u_40.Parent = p_u_18.Frame
                    v_u_4:AddItem(v_u_40, 5)
                    v_u_40:TweenSize(UDim2.new(1, 0, v32 and 0.75 or 1, 6), "Out", "Back", 0.25, true, function()
                        wait(3)
                        if not p_u_18._destroyed and v_u_40:IsDescendantOf(v_u_2.LocalPlayer) then
                            v_u_40:TweenSize(UDim2.new(1, 0, 0, 0), "In", "Quint", 0.5, true)
                            v_u_6:RenderstepForLoop(0, 100, 10, function(p41)
                                v_u_40.GroupTransparency = p41 / 100
                            end)
                            v_u_40:Destroy()
                            if #p_u_18.Frame:GetChildren() == 1 then
                                p_u_18:Clear()
                            end
                        end
                    end)
                    wait(0.04)
                end
            end
            p_u_18._elimination_queue_playing = false
        end
    else
        return
    end
end
function v_u_10.Destroy(p42)
    p42._destroyed = true
    for _, v43 in pairs(p42._connections) do
        v43:Disconnect()
    end
    p42._connections = {}
end
function v_u_10._Init(p_u_44)
    local v45 = p_u_44._connections
    local v46 = p_u_44._reference_frame:GetPropertyChangedSignal("AbsolutePosition")
    table.insert(v45, v46:Connect(function()
        p_u_44:Refresh()
    end))
end
return v_u_10