game:GetService("CollectionService")
local v_u_1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("Lighting")
local v_u_3 = require(v_u_1.Modules.GameplayUtility)
local v_u_4 = require(v_u_1.Modules.Spring)
local v_u_5 = {}
v_u_5.__index = v_u_5
function v_u_5.new(p6)
    local v7 = v_u_5
    local v8 = setmetatable({}, v7)
    v8.FighterInterface = p6
    v8._smoke_cloud_spring = v_u_4.new(0, 1, 20)
    v8._smoke_cloud_cover = Instance.new("Part")
    v8._smoke_cloud_dof = Instance.new("DepthOfFieldEffect")
    v8._smoke_clouds_entered = {}
    v8:_Init()
    return v8
end
function v_u_5.Hide(p9)
    p9._smoke_cloud_cover.Parent = nil
    p9._smoke_cloud_dof.Parent = nil
end
function v_u_5.Update(p10, _, _)
    local v11 = p10:_GetSmokeCloud()
    p10._smoke_cloud_spring.Target = v11 and 1 or 0
    p10._smoke_cloud_spring.Speed = v11 and 100 or 20
    p10._smoke_cloud_cover.Transparency = 1 + -0.989 * p10._smoke_cloud_spring.Value
    p10._smoke_cloud_cover.CFrame = workspace.CurrentCamera.CFrame * CFrame.new(0, 0, -0.25)
    p10._smoke_cloud_cover.Parent = workspace
    p10._smoke_cloud_dof.FarIntensity = p10._smoke_cloud_spring.Value
    p10._smoke_cloud_dof.Parent = p10._smoke_cloud_spring.Value > 0.001 and v_u_2 or nil
    if v11 and not p10._smoke_clouds_entered[v11] then
        p10._smoke_clouds_entered[v11] = true
        v_u_1.Remotes.Replication.Fighter.WasSmoked:FireServer(v11:GetAttribute("ObjectID"))
    end
end
function v_u_5.Clear(p12)
    p12._smoke_clouds_entered = {}
end
function v_u_5.Destroy(p13)
    p13._smoke_cloud_cover:Destroy()
    p13._smoke_cloud_dof:Destroy()
    p13:Clear()
end
function v_u_5._GetSmokeCloud(p14)
    local v15 = { workspace.CurrentCamera.CFrame.Position, p14.FighterInterface.ClientFighter.Entity and p14.FighterInterface.ClientFighter.Entity.RootPart.Position or nil }
    for _, v16 in pairs(v15) do
        local v17 = v_u_3:GetSmokeCloudsInSphere(v16)[1]
        if v17 then
            return v17
        end
    end
end
function v_u_5._Setup(p18)
    p18._smoke_cloud_cover.Color = Color3.fromRGB(72, 75, 79)
    p18._smoke_cloud_cover.Anchored = true
    p18._smoke_cloud_cover.CanCollide = false
    p18._smoke_cloud_cover.CastShadow = false
    p18._smoke_cloud_cover.CanQuery = false
    p18._smoke_cloud_cover.CanTouch = false
    p18._smoke_cloud_cover.Size = Vector3.new(10, 10, 0)
    p18._smoke_cloud_cover.Material = Enum.Material.Neon
    p18._smoke_cloud_cover.Transparency = 1
    p18._smoke_cloud_dof.FarIntensity = 0
    p18._smoke_cloud_dof.FocusDistance = 0
    p18._smoke_cloud_dof.InFocusRadius = 1.75
    p18._smoke_cloud_dof.NearIntensity = 0
end
function v_u_5._Init(p19)
    p19:_Setup()
end
return v_u_5