local v1 = game:GetService("Players")
local v_u_2 = require(v1.LocalPlayer.PlayerScripts.Modules:WaitForChild("ViewModels"):WaitForChild("BaseChainsaw"))
local v_u_3 = setmetatable({}, v_u_2)
v_u_3.__index = v_u_3
function v_u_3.new(...)
    local v4 = v_u_2.new(...)
    local v5 = v_u_3
    local v6 = setmetatable(v4, v5)
    v6:_Init()
    return v6
end
function v_u_3.CreateHoldSounds(p7)
    local v8 = {}
    local v9 = p7:CreateSound("rbxassetid://16359327230", 0.75, 1.25, true)
    local v10 = Instance.new("PitchShiftSoundEffect")
    v10.Octave = 0.625
    v10.Parent = v9
    table.insert(v8, v9)
    local v11 = p7:CreateSound("rbxassetid://16359327230", 0.5, 1.2, true)
    local v12 = Instance.new("PitchShiftSoundEffect")
    v12.Octave = 0.5
    v12.Parent = v11
    table.insert(v8, v11)
    return v8
end
function v_u_3.PlayStartingHoldSounds(p13)
    p13:CreateSound("rbxassetid://18763594759", 0.5, 1, true, 10)
end
function v_u_3._Init(p14)
    p14:_RegisterBlade(p14.ItemModel:WaitForChild("Drill"):WaitForChild("Blade"))
end
return v_u_3