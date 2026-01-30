local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("RunService")
local v3 = game:GetService("Players")
local v_u_4 = require(v1.Modules.Utility)
local v_u_5 = v3.LocalPlayer.PlayerScripts.Assets.Misc:WaitForChild("TrajectoryVisualNode")
local v_u_6 = {}
v_u_6.__index = v_u_6
function v_u_6.new(p7)
    local v8 = v_u_6
    local v9 = setmetatable({}, v8)
    v9._num_segments = p7 or 100
    v9._folder = Instance.new("Folder")
    v9._impact_sphere = Instance.new("Part")
    v9._segments = {}
    v9._renderstep_connection = nil
    v9._last_args = {}
    v9:_Init()
    return v9
end
function v_u_6.OnStep(p10, p11)
    if p10._renderstep_connection then
        p10._renderstep_connection:Disconnect()
        p10._renderstep_connection = nil
    end
    p10._renderstep_connection = v_u_2.RenderStepped:Connect(p11)
end
function v_u_6.Update(p12, p13, p14, p15, p16, p17, p18)
    if p12._last_args[1] ~= p13 or (p12._last_args[2] ~= p14 or (p12._last_args[3] ~= p15 or (p12._last_args[4] ~= p16 or (p12._last_args[5] ~= p17 or p12._last_args[6] ~= p18)))) then
        p12._last_args = {
            p13,
            p14,
            p15,
            p16,
            p17,
            p18
        }
        local v19 = p13
        local v20 = p15 or 196.2
        local v21 = false
        local v22 = p16 or 0.05
        local v23 = p18 or (1 / 0)
        for v24, v25 in pairs(p12._segments) do
            if v21 then
                v25.CFrame = CFrame.new(p13)
            else
                local v26 = (v24 - 1) * v22 + 0
                local v27 = math.min(v23, v26)
                local v28 = v19 + p14 * v27 - Vector3.new(0, 1, 0) * v20 * v27 ^ 2
                if p13:FuzzyEq(v28) then
                    v25.CFrame = CFrame.new(p13)
                else
                    local v29 = v_u_4:Raycast(p13, v28, (p13 - v28).Magnitude, p17, Enum.RaycastFilterType.Include)
                    v25.CFrame = p13:FuzzyEq(v29.Position) and CFrame.new(p13) or CFrame.new(p13, v29.Position)
                    p13 = v29.Position
                    if v29.Instance or v23 <= v27 then
                        v21 = true
                    end
                end
            end
        end
        p12._impact_sphere.CFrame = CFrame.new(p13)
    end
end
function v_u_6.Destroy(p30)
    if p30._renderstep_connection then
        p30._renderstep_connection:Disconnect()
        p30._renderstep_connection = nil
    end
    p30._folder:Destroy()
end
function v_u_6._Setup(p31)
    for v32 = 1, p31._num_segments do
        local v33 = v_u_5:Clone()
        v33.Size = Vector3.new(1, 2, 1) * (0.1 + 0.02 * v32)
        v33.Parent = p31._folder
        p31._segments[v32] = v33
        local v34 = p31._segments[v32 - 1]
        if v34 then
            v33.Beam.Attachment0 = v34.Attachment
            v33.Beam.Width0 = v34.Size.Y / 4
            v33.Beam.Width1 = v33.Beam.Width0
        end
    end
    p31._impact_sphere.Shape = "Ball"
    p31._impact_sphere.Color = Color3.fromRGB(255, 255, 255)
    p31._impact_sphere.Material = Enum.Material.ForceField
    p31._impact_sphere.Size = Vector3.new(3, 3, 3)
    p31._impact_sphere.Anchored = true
    p31._impact_sphere.CanCollide = false
    p31._impact_sphere.CanTouch = false
    p31._impact_sphere.CanQuery = false
    p31._impact_sphere.CastShadow = false
    p31._impact_sphere.Parent = p31._folder
    p31._folder.Parent = workspace
end
function v_u_6._Init(p35)
    p35:_Setup()
end
return v_u_6