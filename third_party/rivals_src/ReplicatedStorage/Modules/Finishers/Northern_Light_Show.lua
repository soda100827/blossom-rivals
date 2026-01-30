local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("RunService")
local v_u_3 = require(v1.Modules.Finishers.Ragdoll)
local v_u_4 = require(v1.Modules.Utility)
local v_u_5 = setmetatable({}, v_u_3)
v_u_5.__index = v_u_5
function v_u_5.new(...)
    local v6 = v_u_3.new(...)
    local v7 = v_u_5
    local v8 = setmetatable(v6, v7)
    v8:_Init()
    return v8
end
function v_u_5.PlayClient(p9)
    v_u_3.PlayClient(p9)
    local v_u_10 = p9._is_humanoid and p9._subject.RootPart or p9._subject
    local v_u_11 = CFrame.Angles(0, 6.283185307179586 * math.random(), 0)
    local v_u_12 = script.Aurora:Clone()
    v_u_12.PrimaryPart = v_u_12.Primary
    v_u_12.Parent = p9._subject
    local v13 = p9._destroy_these
    table.insert(v13, v_u_12)
    local v14 = v_u_2.RenderStepped:Connect(function()
        v_u_12:PivotTo(CFrame.new(v_u_10.Position) * v_u_11)
    end)
    local v15 = p9._connections
    table.insert(v15, v14)
    p9:CreateSound("rbxassetid://81606650181214", 1, 1.25 + 0.125 * math.random(), nil, true, 5)
    local v_u_16 = v_u_12.Beams:GetChildren()
    v_u_4:RenderstepForLoop(0, 100, 1, function(p17)
        for _, v18 in pairs(v_u_16) do
            v18.LocalTransparencyModifier = 1 - p17 / 100
        end
    end)
    wait(3)
    v_u_4:RenderstepForLoop(0, 100, 1, function(p19)
        for _, v20 in pairs(v_u_16) do
            v20.LocalTransparencyModifier = p19 / 100
        end
    end)
    v14:Disconnect()
end
function v_u_5._Init(_) end
return v_u_5