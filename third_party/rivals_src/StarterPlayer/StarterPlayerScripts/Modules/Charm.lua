local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.SeasonLibrary)
local v_u_4 = require(v1.Modules.Spring)
local v_u_5 = v2.LocalPlayer.PlayerScripts.Assets.Charms
local v_u_6 = CFrame.Angles(0.7853981633974483, 0, 0)
local v_u_7 = {
    ["X"] = Vector3.new(1, 0, 0),
    ["Y"] = Vector3.new(0, 1, 0),
    ["Z"] = Vector3.new(0, 0, 1)
}
local v_u_8 = { 6.283185307179586, -6.283185307179586 }
local v_u_9 = {}
v_u_9.__index = v_u_9
function v_u_9.new(p10, p11, p12)
    local v13 = v_u_9
    local v14 = setmetatable({}, v13)
    v14.ClientViewModel = p10
    v14.EquippedData = p11
    v14.Name = v14.EquippedData.Name
    v14.Model = v_u_5[v14.Name]:Clone()
    v14._original_scale = v14.Model:GetScale()
    v14._charm_pivot_attachment = p12
    v14._pivot_attachment = v14.Model:FindFirstChild("_pivot_attachment", true)
    v14._pivot_charm_scale = v14._charm_pivot_attachment:GetAttribute("CharmScale") or 1
    v14._orientation_spring = v_u_4.new(Vector3.new(0, 0, 0), 0.25, 10)
    v14._no_physics = v14._charm_pivot_attachment:GetAttribute("NoPhysics")
    v14._hide_until = 0
    v14:_Init()
    return v14
end
function v_u_9.SetParent(p15, p16)
    p15.Model.Parent = p16
end
function v_u_9.ScaleTo(p17, p18)
    p17.Model:ScaleTo(p17._original_scale * p17._pivot_charm_scale * p18)
end
function v_u_9.Hide(p_u_19, p20)
    p_u_19._hide_until = tick() + p20
    if tick() < p_u_19._hide_until then
        p_u_19:_LTM(1)
        task.delay(p20, function()
            if tick() >= p_u_19._hide_until then
                p_u_19:_LTM(0)
            end
        end)
    else
        p_u_19:_LTM(0)
    end
end
function v_u_9.Update(p21, _, p22)
    if p22 or p21._no_physics then
        p21.Model:PivotTo(p21._charm_pivot_attachment.WorldCFrame)
    else
        local v23 = p21._charm_pivot_attachment.WorldCFrame.LookVector.X
        local v24 = p21._charm_pivot_attachment.WorldCFrame.LookVector.Z
        local v25 = Vector3.new(v23, -1, v24)
        local v26 = CFrame.new(Vector3.new(0, 0, 0), v25) * v_u_6 * (p21.ClientViewModel and CFrame.Angles(0, 0, -p21.ClientViewModel.CurrentSwayValue.Y * 5) or CFrame.identity)
        local v27 = p21._charm_pivot_attachment.WorldCFrame.Rotation:ToObjectSpace(v26)
        p21._orientation_spring.Target = Vector3.new(v27:ToOrientation())
        for v28, v29 in pairs(v_u_7) do
            for _, v30 in pairs(v_u_8) do
                local v31 = p21._orientation_spring.Value[v28] - (p21._orientation_spring.Target[v28] + v30)
                local v32 = math.abs(v31)
                local v33 = p21._orientation_spring.Value[v28] - p21._orientation_spring.Target[v28]
                if v32 < math.abs(v33) then
                    local v34 = p21._orientation_spring
                    v34.Value = v34.Value - v29 * v30
                end
            end
        end
        local v35 = p21._orientation_spring.Value
        local v36 = p21._charm_pivot_attachment.WorldCFrame * CFrame.fromOrientation(v35.X, v35.Y, v35.Z)
        p21.Model:PivotTo(v36)
    end
end
function v_u_9.Destroy(p37)
    p37.Model:Destroy()
end
function v_u_9._LTM(p38, p39)
    for _, v40 in pairs(p38.Model:GetDescendants()) do
        if v40:IsA("BasePart") or (v40:IsA("Texture") or (v40:IsA("Beam") or (v40:IsA("ParticleEmitter") or (v40:IsA("Trail") or v40:IsA("Decal"))))) then
            v40.LocalTransparencyModifier = p39
        end
    end
end
function v_u_9._SetupSeasonRankCharm(p41)
    if #p41.Name >= 8 then
        local v42 = p41.Name
        if string.sub(v42, 1, 7) == "Season " then
            local v43 = p41.Name
            local v44 = string.sub(v43, 8)
            local v45 = tonumber(v44)
            if v45 then
                local v46 = v_u_3.SeasonsByVersion[v45].Name
                local v47
                if p41.EquippedData.Metadata then
                    v47 = p41.EquippedData.Metadata.SeasonELO or nil
                else
                    v47 = nil
                end
                local v48
                if p41.EquippedData.Metadata then
                    v48 = p41.EquippedData.Metadata.SeasonLeaderboardRank or nil
                else
                    v48 = nil
                end
                v_u_3:FormatSeasonRankCharm(p41.Model, v46, v47, v48)
            end
        end
    end
end
function v_u_9._Setup(p49)
    local v50 = p49._pivot_attachment ~= nil
    local v51 = p49.Name
    assert(v50, v51)
    if p49._no_physics and p49.Model:FindFirstChild("Hook") then
        p49.Model.Hook:Destroy()
    end
    p49.Model.WorldPivot = p49._no_physics and p49.Model.Primary.CFrame or p49._pivot_attachment.WorldCFrame
    p49.Model.PrimaryPart = nil
    for _, v52 in pairs(p49.Model:GetDescendants()) do
        if v52:IsA("BasePart") then
            v52.CastShadow = false
            v52.CanCollide = false
            v52.CanTouch = false
            v52.CanQuery = false
            v52.Massless = true
            v52.Anchored = true
        end
    end
    if p49.Model:FindFirstChild("Hook") and p49.Model.Hook:FindFirstChild("Ring") then
        p49.Model.Hook.Ring.Material = Enum.Material.Glass
    end
    if p49._pivot_charm_scale ~= 1 then
        p49:ScaleTo(1)
    end
end
function v_u_9._Init(p53)
    p53:_Setup()
    task.defer(p53._SetupSeasonRankCharm, p53)
end
return v_u_9