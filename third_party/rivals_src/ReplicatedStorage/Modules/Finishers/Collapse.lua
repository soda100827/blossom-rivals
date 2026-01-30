local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("RunService")
local v_u_3 = require(v1.Modules.Finisher)
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
function v_u_5.PlayServer(p9)
    p9:_AnchorModel(0)
end
function v_u_5.PlayClient(p10, ...)
    if p10._is_humanoid then
        p10:CreateSound("rbxassetid://140285154660882", 1.25, 1, p10._subject.RootPart.Position, true, 5)
        local v11 = p10._subject.Parent
        local v12 = Random.new():NextUnitVector()
        local v13 = v11:GetPivot()
        local v14 = v11:GetScale()
        local v15 = tick()
        while tick() < v15 + 0.5 do
            local v16 = 1 - (1 - (1 - (v15 + 0.5 - tick()) / 0.5)) ^ 2
            local v17 = v12 * -v16 * 3.141592653589793 * 2 * 3
            v11:ScaleTo(v14 * (1 - v16))
            v11:PivotTo(v13 * CFrame.Angles(v17.X, v17.Y, v17.Z))
            v_u_2.RenderStepped:Wait()
        end
        local v18 = script.Particles.Attachment:Clone()
        v18.Parent = p10._subject.RootPart
        local v19 = p10._destroy_these
        table.insert(v19, v18)
        v_u_4:PlayParticles(v18)
        wait(0.25)
        p10:CreateSound("rbxassetid://73926817558125", 1, 1, p10._subject.RootPart.Position, true, 5)
        wait(1)
    end
end
function v_u_5._Init(_) end
return v_u_5