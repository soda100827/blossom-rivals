local v1 = game:GetService("Players")
local v_u_2 = require(v1.LocalPlayer.PlayerScripts.Modules.ClientReplicatedClasses.ClientEntity.ClientHumanoidEntity.ClientEnemy)
local v_u_3 = v1.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("DPSGui")
local v_u_4 = setmetatable({}, v_u_2)
v_u_4.__index = v_u_4
function v_u_4.new(...)
    local v5 = v_u_2.new(...)
    local v6 = v_u_4
    local v7 = setmetatable(v5, v6)
    v7._gui = v_u_3:Clone()
    v7._dps_start = nil
    v7._dps_initial_damage = 0
    v7._dps_total_damage = 0
    v7._dps_hash = 0
    v7:_Init()
    return v7
end
function v_u_4.ReplicateFromServer(p_u_8, p9, ...)
    if p9 == "RegisterDPS" then
        if p_u_8:IsRendered() then
            local v10 = ...
            p_u_8._dps_start = p_u_8._dps_start or tick()
            p_u_8._dps_initial_damage = p_u_8._dps_initial_damage or v10
            p_u_8._dps_total_damage = p_u_8._dps_total_damage + v10
            p_u_8._dps_hash = p_u_8._dps_hash + 1
            local v11 = p_u_8._dps_total_damage
            local v12 = p_u_8._dps_initial_damage - p_u_8._dps_total_damage
            local v13 = v11 - (math.abs(v12) < 0.001 and 0 or p_u_8._dps_initial_damage)
            p_u_8._gui.MainFrame.Bar.Bar.Size = UDim2.new(1, 0, 1, 0)
            p_u_8._gui.MainFrame.Bar.Bar:TweenSize(UDim2.new(0, 0, 1, 0), "Out", "Linear", 3, true)
            local v14 = p_u_8._gui.MainFrame.DPS
            local v15 = string.format
            local v16 = tick() - p_u_8._dps_start
            v14.Text = v15("DPS: %.1f", v13 / math.max(1, v16))
            p_u_8._gui.MainFrame.Total.Text = string.format("Total: %.1f", p_u_8._dps_total_damage)
            p_u_8._gui.Enabled = true
            local v_u_17 = p_u_8._dps_hash
            task.delay(3, function()
                if not p_u_8._destroyed and p_u_8._dps_hash == v_u_17 then
                    p_u_8._dps_start = nil
                    p_u_8._dps_initial_damage = 0
                    p_u_8._dps_total_damage = 0
                    p_u_8._gui.Enabled = false
                end
            end)
        end
    else
        v_u_2.ReplicateFromServer(p_u_8, p9, ...)
        return
    end
end
function v_u_4._Setup(p18)
    p18._gui.Enabled = false
    p18._gui.Parent = p18.RootPart
end
function v_u_4._Init(p19)
    p19:_Setup()
end
return v_u_4