local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = require(v1.Modules.Utility)
return function(p3)
    v_u_2:CreateSound("rbxassetid://18184524463", 0.8, 1, p3.HumanoidRootPart, true)
    wait(0.75)
    v_u_2:CreateSound("rbxassetid://18184524463", 0.9, 1.1, p3.HumanoidRootPart, true)
    wait(0.65)
    v_u_2:CreateSound("rbxassetid://83395955233446", 1, 1.1, p3.HumanoidRootPart, true)
end