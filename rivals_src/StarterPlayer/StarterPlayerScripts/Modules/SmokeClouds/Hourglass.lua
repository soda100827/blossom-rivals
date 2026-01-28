local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.Utility)
local v_u_4 = require(v2.LocalPlayer.PlayerScripts.Modules:WaitForChild("SmokeCloud"))
local v_u_5 = setmetatable({}, v_u_4)
v_u_5.__index = v_u_5
function v_u_5.new(...)
    local v6 = v_u_4.new(...)
    local v7 = v_u_5
    local v8 = setmetatable(v6, v7)
    v8:_Init()
    return v8
end
function v_u_5.Update(p9, p10)
    if not v_u_4.Update(p9, p10) then
        p9.Model:PivotTo(CFrame.new(p9._position_spring.Value, workspace.CurrentCamera.CFrame.Position) * CFrame.Angles(-p9._spin, 0, 0))
    end
end
function v_u_5._CreateIdleSound(_)
    return v_u_3:CreateSound("rbxassetid://94857514154727", 2, 1, nil, true)
end
function v_u_5._Init(_) end
return v_u_5