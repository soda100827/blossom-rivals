local v1 = game:GetService("Players")
local v_u_2 = require(v1.LocalPlayer.PlayerScripts.Modules.ViewModels:WaitForChild("BaseChainsaw"))
local v_u_3 = setmetatable({}, v_u_2)
v_u_3.__index = v_u_3
function v_u_3.new(...)
    local v4 = v_u_2.new(...)
    local v5 = v_u_3
    local v6 = setmetatable(v4, v5)
    v6:_Init()
    return v6
end
function v_u_3._Init(p7)
    p7:_RegisterBlade(p7.ItemModel:WaitForChild("RightBlade"):WaitForChild("Blade"))
    p7:_RegisterBlade(p7.ItemModel:WaitForChild("LeftBlade"):WaitForChild("Blade"))
    p7:_RegisterSpikesPart(p7.ItemModel:WaitForChild("RightBlade"):WaitForChild("Spikes1"), true)
    p7:_RegisterSpikesPart(p7.ItemModel:WaitForChild("RightBlade"):WaitForChild("Spikes2"), false)
    p7:_RegisterSpikesPart(p7.ItemModel:WaitForChild("LeftBlade"):WaitForChild("Spikes1"), false)
    p7:_RegisterSpikesPart(p7.ItemModel:WaitForChild("LeftBlade"):WaitForChild("Spikes2"), true)
end
return v_u_3