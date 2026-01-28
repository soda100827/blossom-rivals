local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = require(v1.Modules.Utility)
return function(p3)
    v_u_2:CreateSound("rbxassetid://18184524463", 1.2, 0.75, p3.HumanoidRootPart, true)
    wait(1.1)
    v_u_2:CreateSound("rbxassetid://18184413892", 0.7, 1, p3.HumanoidRootPart, true)
    wait(0.65)
end