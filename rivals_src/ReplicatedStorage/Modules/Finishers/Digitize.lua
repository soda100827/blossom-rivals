local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("RunService")
local v_u_3 = game:GetService("Players")
local v_u_4 = require(v1.Modules.CONSTANTS)
local v_u_5 = require(v1.Modules.DuelLibrary)
local v_u_6 = require(v1.Modules.Finisher)
local v_u_7 = require(v1.Modules.Spring)
local v_u_8 = setmetatable({}, v_u_6)
v_u_8.__index = v_u_8
function v_u_8.new(...)
    local v9 = v_u_6.new(...)
    local v10 = v_u_8
    local v11 = setmetatable(v9, v10)
    v11:_Init()
    return v11
end
function v_u_8.PlayClient(p_u_12)
    for _, v13 in pairs(p_u_12:_GetObjects(true)) do
        if v13:IsA("BasePart") then
            v13.LocalTransparencyModifier = 1
        elseif v13:IsA("Decal") or (v13:IsA("Texture") or (v13:IsA("Beam") or (v13:IsA("ParticleEmitter") or (v13:IsA("Trail") or v13:IsA("SurfaceAppearance"))))) then
            v13:Destroy()
        end
    end
    local v_u_14 = p_u_12._is_humanoid and p_u_12._subject.RootPart or p_u_12._subject
    local v_u_15 = CFrame.Angles(0, math.random() * 3.141592653589793 * 2, 0)
    local v16 = p_u_12._is_humanoid
    if v16 then
        v16 = v_u_3:GetPlayerFromCharacter(p_u_12._subject.Parent)
    end
    local v17 = v16 and v16:GetAttribute("TeamID")
    if v17 then
        v17 = v_u_5:GetTeamColor(v16:GetAttribute("TeamID"))
    end
    local v_u_18 = script.Model:Clone()
    v_u_18.Part.BillboardGui.Headshot.Image = not v16 and "" or string.format(v_u_4.HEADSHOT_IMAGE, v16.UserId)
    v_u_18.Parent = p_u_12._subject
    if v17 then
        v_u_18.Extra.Neon.Color = v17
        v_u_18.Extra.Ring.Color = v17
        v_u_18.Extra.NeonCone.Color = v17
        v_u_18.Extra.Model["Meshes/HandLamp_01c"].Beam.Color = ColorSequence.new(v17)
    end
    local v_u_19 = p_u_12:_GetObjects(true)
    local v_u_20 = v_u_7.new(v_u_14.Position, 1, 2)
    local v21 = v_u_2.RenderStepped:Connect(function()
        v_u_20.Target = p_u_12:_GetGroundPosition(v_u_14.Position, v_u_19)
        v_u_18:PivotTo(CFrame.new(v_u_20.Value.X, v_u_20.Target.Y, v_u_20.Value.Z) * v_u_15)
    end)
    local v22 = p_u_12._connections
    table.insert(v22, v21)
    p_u_12:CreateSound("rbxassetid://80428386536466", 1.25, 1, nil, true, 5)
    p_u_12:CreateSound("rbxassetid://138661631832263", 1.5, 1, nil, true, 5)
    wait(3)
    v21:Disconnect()
    wait(7)
end
function v_u_8._Init(_) end
return v_u_8