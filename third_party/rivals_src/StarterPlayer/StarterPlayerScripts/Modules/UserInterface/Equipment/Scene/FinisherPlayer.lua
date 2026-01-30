local v_u_1 = game:GetService("ReplicatedStorage").Modules.Finishers
local v_u_2 = {}
v_u_2.__index = v_u_2
function v_u_2.new(p3)
    local v4 = v_u_2
    local v5 = setmetatable({}, v4)
    v5.Scene = p3
    v5._dummy_template = v5.Scene.Model:WaitForChild("FinisherDummy")
    v5._fake_player = v5.Scene.Model:WaitForChild("FakePlayer")
    v5._playing_hash = 0
    v5._last_rig = nil
    v5._last_finisher = nil
    v5:_Init()
    return v5
end
function v_u_2.GetHumanoidCFrame(p6)
    return p6._dummy_template:GetPivot()
end
function v_u_2.OnCustomizingStateChanged(p7)
    task.defer(p7._StartPlaying, p7)
end
function v_u_2.OnStateChanged(p8)
    task.defer(p8._StartPlaying, p8)
end
function v_u_2._StartPlaying(p9)
    p9._playing_hash = p9._playing_hash + 1
    local v10 = p9._playing_hash
    if p9._last_rig then
        p9._last_rig:Destroy()
        p9._last_rig = nil
    end
    if p9._last_finisher then
        p9._last_finisher:Destroy()
        p9._last_finisher = nil
    end
    local v11 = p9.Scene.Equipment:GetSelectedCosmetic()
    if p9.Scene.Equipment:GetCustomizingType() ~= "Finisher" then
        return
    end
    while true do
        p9._last_rig = p9._dummy_template:Clone()
        p9._last_rig:PivotTo(p9:GetHumanoidCFrame() * CFrame.new(0, 0, 8))
        p9._last_rig.Parent = p9.Scene.Model
        p9._last_rig.Humanoid:MoveTo((p9._last_rig:GetPivot() * CFrame.new(0, 0, -16)).Position)
        local v12 = Instance.new("Animation")
        v12.AnimationId = "rbxassetid://14266666697"
        local v13, v14 = pcall(p9._last_rig.Humanoid.LoadAnimation, p9._last_rig.Humanoid, v12)
        if v13 then
            v14:Play(0)
        end
        wait(0.5)
        if p9._playing_hash ~= v10 then
            return
        end
        if v13 then
            v14:Stop(0)
        end
        local v15 = p9._last_rig
        local v16 = p9._last_rig:GetPivot()
        local v17 = CFrame.Angles
        local v18 = math.random() - 0.5
        v15:PivotTo(v16 * v17(0.17453292519943295, 0, math.sign(v18) * 0.17453292519943295))
        local v19 = p9._last_rig.HumanoidRootPart
        v19.AssemblyLinearVelocity = v19.AssemblyLinearVelocity * 0
        p9._last_rig.Humanoid.Health = 0
        for _, v20 in pairs(p9._last_rig:GetChildren()) do
            if v20:IsA("BasePart") then
                for _, v21 in pairs(p9._last_rig:GetChildren()) do
                    if v21:IsA("BasePart") and v21 ~= v20 then
                        local v22 = Instance.new("NoCollisionConstraint")
                        v22.Part1 = v21
                        v22.Part0 = v20
                        v22.Parent = v20
                    end
                end
            end
        end
        for _, v23 in pairs(p9._last_rig:GetDescendants()) do
            if v23:IsA("BasePart") then
                v23.CanCollide = true
            end
        end
        local v24 = v11 == "RANDOM_COSMETIC" and "Ragdoll" or (v11 or "Ragdoll")
        local v25 = {
            ["Character"] = p9._fake_player
        }
        p9._last_finisher = require(v_u_1[v24]).new(p9._last_rig.Humanoid, false, v25)
        p9._last_finisher:Simulate()
        if p9._playing_hash ~= v10 then
            return
        end
        wait(3)
        if p9._playing_hash ~= v10 then
            return
        end
        if p9._last_rig then
            p9._last_rig:Destroy()
            p9._last_rig = nil
        end
        if p9._last_finisher then
            p9._last_finisher:Destroy()
            p9._last_finisher = nil
        end
    end
end
function v_u_2._Setup(p26)
    p26._dummy_template.Parent = nil
end
function v_u_2._Init(p27)
    p27:_Setup()
end
return v_u_2