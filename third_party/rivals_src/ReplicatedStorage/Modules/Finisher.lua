local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("ServerStorage")
local v3 = game:GetService("Players")
local v4 = require(v1.Modules.CONSTANTS)
local v5 = require(v1.Modules.TestLibrary)
local v_u_6 = require(v1.Modules.Utility)
local v_u_7 = v4.IS_SERVER
if v_u_7 then
    v_u_7 = require(v2.Services.CollisionsService)
end
local v_u_8 = v4.IS_CLIENT
if v_u_8 then
    v_u_8 = require(v3.LocalPlayer.PlayerScripts.Controllers.PlayerDataController)
end
local v_u_9 = v5:GetTestAttribute("StudioPing")
local v_u_10 = v4.IS_STUDIO
local v_u_11 = {}
v_u_11.__index = v_u_11
function v_u_11.new(p12, p13, p14)
    local v15
    if typeof(p12) == "Instance" then
        v15 = p12:IsA("Humanoid") or p12:IsA("BasePart")
    else
        v15 = false
    end
    assert(v15, "Argument 1 invalid, expected a Humanoid or BasePart")
    local v16 = v_u_11
    local v17 = setmetatable({}, v16)
    v17._subject = p12
    v17._is_humanoid = p12:IsA("Humanoid")
    v17._is_final_finisher = p13
    v17._eliminator = p14
    v17._anchor_model_hash = 0
    v17._destroy_these = {}
    v17._connections = {}
    v17._threads = {}
    v17._destroyed = false
    v17._serial = nil
    v17._seed = math.random(1, 1000000)
    v17._original_collision_groups = {}
    v17:_Init()
    return v17
end
function v_u_11.CreateSound(p18, p19, p20, p21, p22, ...)
    local v23 = v_u_6:CreateSound(p19, p20 * (v_u_8 and v_u_8:Get("Settings Finisher Volume") or 1), p21, p22 or (p18._is_humanoid and p18._subject.RootPart or p18._subject), ...)
    local v24 = p18._destroy_these
    table.insert(v24, v23)
    return v23
end
function v_u_11.Simulate(p_u_25, p_u_26)
    local v_u_27 = Instance.new("BindableEvent")
    local v28 = p_u_25._destroy_these
    table.insert(v28, v_u_27)
    local v_u_29 = 0
    task.spawn(function()
        local v30, v31 = pcall(p_u_25.PlayServer, p_u_25, true)
        if not v30 and p_u_26 then
            p_u_26(v31)
        end
        if not v30 and v_u_10 then
            error(v31)
        end
        v_u_29 = v_u_29 + 1
        v_u_27:Fire()
    end)
    task.spawn(function()
        if v_u_9 and v_u_9 > 0 then
            wait(v_u_9 / 1000)
        end
        local v32, v33 = pcall(p_u_25.PlayClient, p_u_25, true)
        if not v32 and p_u_26 then
            p_u_26(v33)
        end
        if not v32 and v_u_10 then
            error(v33)
        end
        v_u_29 = v_u_29 + 1
        v_u_27:Fire()
    end)
    while v_u_29 < 2 do
        v_u_27.Event:Wait()
    end
end
function v_u_11.PlayServer(_, _) end
function v_u_11.PlayClient(_, _) end
function v_u_11.SetSerial(p34, p35)
    p34._serial = p35
end
function v_u_11.Serialize(p36)
    return {
        ["Seed"] = p36._seed
    }
end
function v_u_11.Destroy(p37)
    p37._destroyed = true
    for _, v38 in pairs(p37._connections) do
        v38:Disconnect()
    end
    for _, v39 in pairs(p37._destroy_these) do
        v39:Destroy()
    end
    for _, v40 in pairs(p37._threads) do
        pcall(task.cancel, v40)
    end
end
function v_u_11._GetGroundPosition(_, p41, p42)
    return v_u_6:Raycast(p41, p41 + Vector3.new(0, -100, 0), 100, p42, Enum.RaycastFilterType.Exclude).Position
end
function v_u_11._HideBody(p43, p44)
    for _, v45 in pairs(p43:_GetObjects(true)) do
        if not (p44 and table.find(p44, v45)) then
            if v45:IsA("BasePart") then
                v45.Transparency = 1
                v45.Size = Vector3.new(0, 0, 0)
            elseif v45 ~= p43._subject then
                v45:Destroy()
            end
        end
    end
end
function v_u_11._GetObjects(p46, p47)
    return p46._is_humanoid and (not p46._subject.Parent and {} or p46._subject.Parent[p47 and "GetDescendants" or "GetChildren"](p46._subject.Parent)) or { p46._subject }
end
function v_u_11._BreakJoints(p48)
    if p48._is_humanoid and p48._subject.Parent then
        for _, v49 in pairs(p48._subject.Parent:GetDescendants()) do
            if v49:IsA("Motor6D") then
                v49.Part0 = nil
                v49.Part1 = nil
                v49:Destroy()
            elseif v49:IsA("MeshPart") then
                v49.AssemblyLinearVelocity = p48._subject.RootPart.AssemblyLinearVelocity
                v49.AssemblyAngularVelocity = p48._subject.RootPart.AssemblyAngularVelocity
                if v49.Name == "Head" and v49.Parent == p48._subject.Parent then
                    v49.CanCollide = true
                end
            end
        end
        p48._subject.Parent.DescendantAdded:Connect(function(p50)
            if p50:IsA("Motor6D") then
                p50.Part0 = nil
                p50.Part1 = nil
                task.defer(p50.Destroy, p50)
            end
        end)
    end
end
function v_u_11._AnchorModel(p_u_51, p52, p53)
    p_u_51._anchor_model_hash = p_u_51._anchor_model_hash + 1
    local v_u_54 = p_u_51._anchor_model_hash
    if p_u_51._is_humanoid then
        local v55 = p52 or 3
        local v_u_56 = p53 == nil and true or p53
        local function v58()
            if p_u_51._subject.Parent and v_u_54 == p_u_51._anchor_model_hash then
                for _, v57 in pairs(p_u_51._subject.Parent:GetDescendants()) do
                    if v57:IsA("BasePart") then
                        if v_u_7 then
                            v_u_7:ClearSetDescendantsLogic(v57, true)
                        end
                        p_u_51._original_collision_groups[v57] = p_u_51._original_collision_groups[v57] or v57.CollisionGroup
                        v57.CollisionGroup = v_u_56 and "Noclip" or (p_u_51._original_collision_groups[v57] or v57.CollisionGroup)
                        v57.Anchored = v_u_56
                    end
                end
            end
        end
        if v55 <= 0 then
            task.spawn(v58)
        else
            task.delay(v55 or 3, v58)
        end
    else
        return
    end
end
function v_u_11._Ragdoll(p59)
    if p59._is_humanoid and p59._subject.Parent then
        for _, v60 in pairs(p59._subject.Parent:GetDescendants()) do
            if v60:IsA("Motor6D") then
                local v61 = Instance.new("Attachment")
                v61.CFrame = v60.C0
                v61.Name = v60.Name .. " - A0"
                v61.Parent = v60.Part0
                local v62 = Instance.new("Attachment")
                v62.CFrame = v60.C1
                v62.Name = v60.Name .. " - A1"
                v62.Parent = v60.Part1
                local v63 = Instance.new("BallSocketConstraint")
                v63.Attachment0 = v61
                v63.Attachment1 = v62
                v63.Name = "RagdollBSC"
                v63.LimitsEnabled = true
                v63.TwistLimitsEnabled = true
                v63.MaxFrictionTorque = 10
                v63.Parent = v60.Part0
                v60:Destroy()
            end
        end
        p59._subject.Parent.DescendantAdded:Connect(function(p64)
            if p64:IsA("Motor6D") then
                task.defer(p64.Destroy, p64)
            end
        end)
    end
end
function v_u_11._InternalThread(p65, p_u_66, ...)
    local v_u_67 = nil
    if v_u_10 then
        v_u_67 = p_u_66(...)
    else
        pcall(function(...)
            v_u_67 = p_u_66(...)
        end, ...)
    end
    local v68 = p65._threads
    table.insert(v68, v_u_67)
    return v_u_67
end
function v_u_11._Init(p_u_69)
    p_u_69._subject.Destroying:Connect(function()
        p_u_69:Destroy()
    end)
end
return v_u_11