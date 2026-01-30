local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = require(v1.Modules.Emote)
local v_u_3 = setmetatable({}, v_u_2)
v_u_3.__index = v_u_3
function v_u_3.new(...)
    local v4 = v_u_2.new(nil, script.Name, ...)
    local v5 = v_u_3
    local v6 = setmetatable(v4, v5)
    v6:_Init()
    return v6
end
function v_u_3.PlayClient(p7, ...)
    v_u_2.PlayClient(p7, ...)
    p7:_PlayAnimation("rbxassetid://71250144811352")
end
function v_u_3._Recolor(p8)
    for _, v9 in pairs(p8._humanoid.Parent:GetDescendants()) do
        if v9:IsA("BasePart") and v9.Transparency < 0.99 then
            for _, v10 in pairs(script.Textures:GetChildren()) do
                v10:Clone().Parent = v9
            end
        end
    end
end
function v_u_3._Init(p11)
    task.spawn(p11._Recolor, p11)
end
return v_u_3