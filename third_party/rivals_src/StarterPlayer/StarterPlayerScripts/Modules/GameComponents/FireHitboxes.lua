local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("CollectionService")
local v_u_3 = game:GetService("TweenService")
local v4 = game:GetService("Players")
local v_u_5 = require(v1.Modules.BetterDebris)
local v_u_6 = require(v1.Modules.Utility)
require(v1.Modules.Spring)
local v_u_7 = v4.LocalPlayer.PlayerScripts.Assets:WaitForChild("Misc"):WaitForChild("FireHitboxes")
local v_u_8 = {}
v_u_8.__index = v_u_8
function v_u_8._new()
    local v9 = v_u_8
    local v10 = setmetatable({}, v9)
    v10._fire_hitboxes = {}
    v10:_Init()
    return v10
end
function v_u_8.Extinguish(p11, p12)
    for v13, v14 in pairs(p11._fire_hitboxes) do
        if v13:GetAttribute("FireHitboxID") == p12 then
            v14.Visual:Destroy()
            p11._fire_hitboxes[v13] = nil
            return v14.Visual:GetPivot().Position
        end
    end
end
function v_u_8.Update(p15, _)
    for v16, v17 in pairs(p15._fire_hitboxes) do
        v17.Visual:PivotTo(v16.CFrame)
    end
end
function v_u_8._Setup(p_u_18)
    local function v28(p19)
        local v_u_20 = p_u_18._fire_hitboxes[p19]
        if v_u_20 then
            for _, v21 in pairs(v_u_20.Visual:GetDescendants()) do
                if v21:IsA("ParticleEmitter") then
                    v21.Enabled = false
                end
            end
            v_u_5:AddItem(v_u_20.Visual, 10)
            if v_u_20.Visual.Name == "Hot Coals" then
                for _, v_u_22 in pairs(v_u_20.Visual.Coals:GetChildren()) do
                    v_u_22.Color = Color3.fromRGB(0, 0, 0)
                    task.delay(0.5 * math.random(), function()
                        v_u_3:Create(v_u_22, TweenInfo.new(0.25 + 0.5 * math.random(), Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
                            ["Size"] = Vector3.new(0, 0, 0)
                        }):Play()
                    end)
                end
            end
            local v_u_23 = v_u_20.Sound1
            if v_u_23 then
                v_u_23 = v_u_20.Sound1.Volume
            end
            local v_u_24 = v_u_20.Sound2
            if v_u_24 then
                v_u_24 = v_u_20.Sound2.Volume
            end
            local v_u_25 = v_u_20.Visual.Primary.PointLight
            v_u_6:RenderstepForLoop(0, 100, 1, function(p26)
                local v27 = 1 - (p26 / 100) ^ 2
                if v_u_20.Sound1 then
                    v_u_20.Sound1.Volume = v_u_23 * v27
                end
                if v_u_20.Sound2 then
                    v_u_20.Sound2.Volume = v_u_24 * v27
                end
                v_u_25.Brightness = 3 * v27
            end)
            p_u_18._fire_hitboxes[p19] = nil
        end
    end
    v_u_2:GetInstanceRemovedSignal("FireHitbox"):Connect(v28)
    local function v42(p29)
        local v30 = p29:GetAttribute("IsMain")
        local v31 = (v_u_7:FindFirstChild(p29:GetAttribute("ViewModelName") or "Default") or v_u_7.Default):Clone()
        v31.PrimaryPart = v31.Primary
        v31.Primary.Size = p29.Size
        v31:PivotTo(p29.CFrame)
        v31.Parent = workspace
        if v30 and v31.Primary:FindFirstChild("Fire") then
            v31.Primary.Fire.Acceleration = Vector3.new(0, 10, 0)
        end
        local v32, v33
        if v30 then
            local v34 = p29.Size.X
            local v35 = p29.Size.Y
            local v36 = p29.Size.Z
            local v37 = math.max(v34, v35, v36) * 1.5
            v32 = v_u_6:CreateSound("rbxassetid://13702989275", 0.5, 0.7 + 0.3 * math.random(), v31.Primary, true, nil, v37)
            v33 = v_u_6:CreateSound("rbxassetid://14812827622", 1.25, 0.875, v31.Primary, true, nil, v37)
        else
            v32 = nil
            v33 = nil
        end
        local v38 = {
            ["Visual"] = v31,
            ["Sound1"] = v32,
            ["Sound2"] = v33
        }
        p_u_18._fire_hitboxes[p29] = v38
        if v38.Visual.Name == "Hot Coals" then
            for _, v_u_39 in pairs(v38.Visual.Coals:GetChildren()) do
                local v_u_40 = v_u_39.Size
                v_u_39.Size = Vector3.new(0, 0, 0)
                v_u_39.CFrame = v_u_39.CFrame * CFrame.Angles(6.283185307179586 * math.random(), 6.283185307179586 * math.random(), 6.283185307179586 * math.random())
                task.delay(0.5 * math.random(), function()
                    local v41 = {
                        ["Size"] = v_u_40
                    }
                    v_u_3:Create(v_u_39, TweenInfo.new(1 * math.random(), Enum.EasingStyle.Quint, Enum.EasingDirection.Out), v41):Play()
                end)
            end
        end
    end
    v_u_2:GetInstanceAddedSignal("FireHitbox"):Connect(v42)
    for _, v43 in pairs(v_u_2:GetTagged("FireHitbox")) do
        task.spawn(v42, v43)
    end
end
function v_u_8._Init(p44)
    p44:_Setup()
end
return v_u_8._new()