local v1 = game:GetService("Players")
local v_u_2 = require(v1.LocalPlayer.PlayerScripts.Modules.FestiveLightsCircuit)
local v_u_3 = require(v1.LocalPlayer.PlayerScripts.Modules:WaitForChild("ViewModels"):WaitForChild("BaseChainsaw"))
local v_u_4 = setmetatable({}, v_u_3)
v_u_4.__index = v_u_4
function v_u_4.new(...)
    local v5 = v_u_3.new(...)
    local v6 = v_u_4
    local v7 = setmetatable(v5, v6)
    v7._festive_lights_circuit_body = v_u_2.new(0.5, v7.ItemModel:WaitForChild("Body"):WaitForChild("Light1"), v7.ItemModel:WaitForChild("Body"):WaitForChild("Light2"), v7.ItemModel:WaitForChild("Body"):WaitForChild("Light3"))
    v7._festive_lights_circuit_spin = v_u_2.new(0.1, v7.ItemModel:WaitForChild("Spin"):WaitForChild("Light1"), v7.ItemModel:WaitForChild("Spin"):WaitForChild("Light2"), v7.ItemModel:WaitForChild("Spin"):WaitForChild("Light3"))
    v7:_Init()
    return v7
end
function v_u_4.Update(p8, p9, p10, p11)
    v_u_3.Update(p8, p9, p10, p11)
    if p11.IsActive then
        p8._festive_lights_circuit_body:Update(p9)
        p8._festive_lights_circuit_spin:Update(p9)
    end
end
function v_u_4.Destroy(p12)
    p12._festive_lights_circuit_body:Destroy()
    p12._festive_lights_circuit_spin:Destroy()
    v_u_3.Destroy(p12)
end
function v_u_4._Init(_) end
return v_u_4