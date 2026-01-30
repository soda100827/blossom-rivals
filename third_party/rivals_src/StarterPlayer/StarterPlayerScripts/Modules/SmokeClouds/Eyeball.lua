local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.QuaternionSpring)
local v_u_4 = require(v1.Modules.Quaternion)
local v_u_5 = require(v1.Modules.Spring)
local v_u_6 = require(v2.LocalPlayer.PlayerScripts.Modules:WaitForChild("SmokeCloud"))
local v_u_7 = setmetatable({}, v_u_6)
v_u_7.__index = v_u_7
function v_u_7.new(...)
    local v8 = v_u_6.new(...)
    local v9 = v_u_7
    local v10 = setmetatable(v8, v9)
    v10._direction_spring = v_u_3.new(v_u_4.fromCFrame(CFrame.identity), 0.75, 10)
    v10._pupil_size_spring = v_u_5.new(0.187, 0.75, 5)
    v10._next_direction_update = 0
    v10._direction_update_count = 0
    v10:_Init()
    return v10
end
function v_u_7.Update(p11, _)
    if not p11:_UpdateCoreLogic() then
        if tick() > p11._next_direction_update then
            p11._direction_update_count = p11._direction_update_count + 1
            local v12
            if p11._direction_update_count % 30 == 0 then
                v12 = CFrame.new(p11.Part.Position, workspace.CurrentCamera.CFrame.Position)
                p11._direction_spring.Speed = 10
                p11._pupil_size_spring.Target = 0.3
                p11._next_direction_update = tick() + 3
            else
                local v13 = Random.new():NextUnitVector()
                local v14 = CFrame.new
                local v15 = v13.X
                local v16 = (v13.Y + 1) / 2
                local v17 = v13.Z
                v12 = v14(Vector3.new(0, 0, 0), (Vector3.new(v15, v16, v17)))
                p11._direction_spring.Speed = 10
                p11._pupil_size_spring.Target = 0.187
                p11._next_direction_update = tick() + 0.1
            end
            p11._direction_spring.Target = v_u_4.fromCFrame(v12)
        elseif p11._direction_update_count % 30 == 0 then
            p11._direction_spring.Target = v_u_4.fromCFrame(CFrame.new(p11.Part.Position, workspace.CurrentCamera.CFrame.Position))
        end
        local v18 = p11.Model.Pupil
        local v19 = p11._pupil_size_spring.Value
        local v20 = p11._pupil_size_spring.Value
        v18.Size = Vector3.new(v19, v20, 0.009) * p11.Model:GetScale()
        p11.Model:PivotTo(CFrame.new(p11.Part.Position) * p11._direction_spring.Position:ToCFrame().Rotation)
    end
end
function v_u_7._Setup(p21)
    p21.Model.Iris.Color = Color3.fromHSV(math.random(), 1, 1)
end
function v_u_7._Init(p22)
    p22:_Setup()
end
return v_u_7