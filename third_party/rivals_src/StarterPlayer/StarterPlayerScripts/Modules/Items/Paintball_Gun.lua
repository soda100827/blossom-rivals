local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.BetterDebris)
require(v1.Modules.Utility)
local v_u_4 = require(v2.LocalPlayer.PlayerScripts.Modules.ItemTypes.Gun)
local v_u_5 = v2.LocalPlayer.PlayerScripts.Assets.Misc:WaitForChild("ImpactMarkerSplat")
local v_u_6 = { "rbxassetid://17098901439", "rbxassetid://17098901515", "rbxassetid://16833617681" }
local v_u_7 = setmetatable({}, v_u_4)
v_u_7.__index = v_u_7
function v_u_7.new(...)
    local v8 = v_u_4.new(...)
    local v9 = v_u_7
    local v10 = setmetatable(v8, v9)
    v10:_Init()
    return v10
end
function v_u_7._ImpactMarker(p11, p12)
    local v13 = p11.ViewModel:GetPaintballColor()
    local v14 = v_u_5.Size * (0.5 + 0.75 * math.random()) * 2
    for v15 = #p11._impact_markers, 1, -1 do
        local v16 = p11._impact_markers[v15]
        if (v16.Position - p12.Position).Magnitude <= v14.X / 2 + v16.Size.X / 2 and v16.Size.Magnitude < 10 then
            v14 = v14 + v16.Size
            v13:Lerp(v16.Decal.Color3, 0.5)
            v16.Decal.Transparency = 1
            v_u_3:AddItem(v16, 1)
            table.remove(p11._impact_markers, v15)
        end
    end
    local v17 = v_u_5:Clone()
    v17.Decal.Color3 = v13
    v17.Decal.Texture = v_u_6[math.random(#v_u_6)]
    v17.Attachment.Particles.Color = ColorSequence.new(v13)
    local v18 = v14.X
    local v19 = math.min(v18, 10)
    local v20 = v14.X
    local v21 = math.min(v20, 10)
    v17.Size = Vector3.new(v19, v21, 0)
    v17.CFrame = CFrame.new(p12.Position, p12.Position + p12.Normal) * CFrame.Angles(0, 0, math.random() * 3.141592653589793 * 2)
    v17.Parent = p12.Part or workspace
    p11:_AddImpactMarker(v17, 10, 40)
    local v22 = v14.Magnitude / v_u_5.Size.Magnitude
    v17.Attachment.Particles.Size = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.075 * v22, 0.05 * v22), NumberSequenceKeypoint.new(1, 0.05 * v22, 0.05 * v22) })
    v17.Attachment.Particles:Emit(10)
    p11.ViewModel:PlaySplatSound(v17)
end
function v_u_7._Tracers(p23, p24)
    local v25 = {
        ["Color"] = ColorSequence.new(p23.ViewModel:GetPaintballColor()),
        ["BeamProperties"] = {
            ["LightEmission"] = 0,
            ["Brightness"] = 2
        },
        ["MaxLength"] = 2,
        ["MaxLengthFirstPerson"] = 5
    }
    return v_u_4._Tracers(p23, p24, v25)
end
function v_u_7._Init(_) end
return v_u_7