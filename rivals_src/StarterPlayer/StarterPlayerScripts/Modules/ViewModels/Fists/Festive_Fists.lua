local v1 = game:GetService("Players")
local v_u_2 = require(v1.LocalPlayer.PlayerScripts.Modules.FestiveLightsCircuit)
local v_u_3 = require(v1.LocalPlayer.PlayerScripts.Modules.ViewModels.Fists)
local v_u_4 = setmetatable({}, v_u_3)
v_u_4.__index = v_u_4
function v_u_4.new(...)
    local v5 = v_u_3.new(...)
    local v6 = v_u_4
    local v7 = setmetatable(v5, v6)
    v7._festive_lights_circuits = {}
    v7:_Init()
    return v7
end
function v_u_4.Update(p8, p9, p10, p11)
    v_u_3.Update(p8, p9, p10, p11)
    if p11.IsActive then
        for _, v12 in pairs(p8._festive_lights_circuits) do
            v12:Update(p9)
        end
    end
end
function v_u_4.Destroy(p13)
    for _, v14 in pairs(p13._festive_lights_circuits) do
        v14:Destroy()
    end
    v_u_3.Destroy(p13)
end
function v_u_4._Setup(p15)
    for v16 in pairs(p15._arm_submodels) do
        local v17 = p15._festive_lights_circuits
        local v18 = v_u_2.new
        local v19 = v16:WaitForChild("Light1")
        local v20 = v16:WaitForChild("Light2")
        table.insert(v17, v18(0.5, v19, v20, v16:WaitForChild("Light3")))
    end
end
function v_u_4._Init(p21)
    p21:_Setup()
end
return v_u_4