local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("ContentProvider")
local v_u_3 = game:GetService("Players")
local v4 = require(v1.Modules.CONSTANTS)
local v_u_5 = require(v1.Modules.CosmeticLibrary)
local v6 = require(v1.Modules.TestLibrary)
local v_u_7 = require(v1.Modules.Utility)
local v_u_8 = require(v1.Modules.Signal)
local v_u_9 = v4.IS_CLIENT
if v_u_9 then
    v_u_9 = require(v_u_3.LocalPlayer.PlayerScripts.Controllers.PlayerDataController)
end
local v_u_10 = v6:GetTestAttribute("StudioPing")
local v_u_11 = v4.IS_STUDIO
local v_u_12 = {}
v_u_12.__index = v_u_12
v_u_12._id_counter = 0
function v_u_12.new(p13, p14, p15)
    local v16 = v_u_5.Cosmetics[p14]
    if v16 then
        v16 = v_u_5.Cosmetics[p14].Type == "Emote"
    end
    assert(v16, p14)
    local v17
    if typeof(p15) == "Instance" then
        v17 = p15:IsA("Humanoid")
    else
        v17 = false
    end
    assert(v17, "Argument 1 invalid, expected a Humanoid")
    local v18 = v_u_12
    local v19 = setmetatable({}, v18)
    v19.Destroying = v_u_8.new()
    v19.ObjectID = v19:_NewObjectID()
    v19.Name = p14
    v19.Info = v_u_5.Cosmetics[p14]
    v19.Lifetime = p13
    v19._humanoid = p15
    v19._destroyed = false
    v19._destroy_these = {}
    v19._connections = {}
    v19._threads = {}
    v19._animation_tracks = {}
    v19._serial = nil
    v19._seed = math.random(1, 1000000)
    v19._sounds = {}
    v19._are_sounds_hidden = false
    v19:_Init()
    return v19
end
function v_u_12.IsDestroyed(p20)
    return p20._destroyed
end
function v_u_12.CreateSound(p21, p22, p23, p24, p25, ...)
    local v26 = v_u_9 and v_u_9:Get("Settings Emote Volume") or 1
    local v27
    if p21._destroyed or (not p21._humanoid:IsDescendantOf(workspace) or p21._are_sounds_hidden) then
        v27 = nil
    else
        v27 = p25 or p21._humanoid.RootPart
    end
    local v28 = v_u_7:CreateSound(p22, p23 * v26, p24, v27, ...)
    local v29 = p21._destroy_these
    table.insert(v29, v28)
    p21._sounds[v28] = v28.Parent
    return v28
end
function v_u_12.HideSounds(p_u_30, p31)
    if p31 ~= p_u_30._are_sounds_hidden then
        p_u_30._are_sounds_hidden = p31
        for v_u_32, v_u_33 in pairs(p_u_30._sounds) do
            pcall(function()
                local v34 = v_u_32
                local v35
                if p_u_30._are_sounds_hidden then
                    v35 = nil
                else
                    v35 = v_u_33
                end
                v34.Parent = v35
            end)
        end
    end
end
function v_u_12.Simulate(p_u_36, p_u_37)
    local v_u_38 = Instance.new("BindableEvent")
    local v39 = p_u_36._destroy_these
    table.insert(v39, v_u_38)
    local v_u_40 = 0
    task.spawn(function()
        local v41, v42 = pcall(p_u_36.PlayServer, p_u_36, true)
        if not v41 and p_u_37 then
            p_u_37(v42)
        end
        if not v41 and v_u_11 then
            error(v42)
        end
        v_u_40 = v_u_40 + 1
        v_u_38:Fire()
    end)
    task.spawn(function()
        if v_u_10 and v_u_10 > 0 then
            wait(v_u_10 / 1000)
        end
        local v43, v44 = pcall(p_u_36.PlayClient, p_u_36, true)
        if not v43 and p_u_37 then
            p_u_37(v44)
        end
        if not v43 and v_u_11 then
            error(v44)
        end
        v_u_40 = v_u_40 + 1
        v_u_38:Fire()
    end)
    while v_u_40 < 2 do
        v_u_38.Event:Wait()
    end
end
function v_u_12.PlayServer(p45, _)
    if p45.Lifetime then
        task.delay(p45.Lifetime, p45.Destroy, p45)
    end
end
function v_u_12.PlayClient(_, _) end
function v_u_12.SetSerial(p46, p47)
    p46._serial = p47
    p46._seed = p47.Seed
    p46.ObjectID = p47.ObjectID
end
function v_u_12.Serialize(p48)
    return {
        ["ObjectID"] = p48.ObjectID,
        ["Name"] = p48.Name,
        ["Seed"] = p48._seed
    }
end
function v_u_12.Destroy(p49)
    if not p49._destroyed then
        p49._destroyed = true
        p49.Destroying:Fire()
        task.defer(p49.Destroying.Destroy, p49.Destroying)
        for _, v50 in pairs(p49._connections) do
            v50:Disconnect()
        end
        for _, v51 in pairs(p49._destroy_these) do
            v51:Destroy()
        end
        for _, v52 in pairs(p49._threads) do
            pcall(task.cancel, v52)
        end
        for _, v53 in pairs(p49._animation_tracks) do
            v53:Stop()
            v53:Destroy()
        end
    end
end
function v_u_12._CanPlayAnimation(p54)
    local v55 = p54._humanoid.Parent
    if v55 then
        v55 = v_u_3:GetPlayerFromCharacter(p54._humanoid.Parent)
    end
    return not v55 or v55 == v_u_3.LocalPlayer
end
function v_u_12._NewObjectID(_)
    local v56 = v_u_12
    v56._id_counter = v56._id_counter + 1
    return utf8.char(v_u_12._id_counter - 1)
end
function v_u_12._GetGroundPosition(_, p57, p58)
    return v_u_7:Raycast(p57, p57 + Vector3.new(0, -100, 0), 100, p58, Enum.RaycastFilterType.Exclude).Position
end
function v_u_12._SetupProp(p59, p60)
    local v61 = {}
    for _, v62 in pairs(p60:GetChildren()) do
        if v62:IsA("BasePart") then
            local v63 = v62:Clone()
            local v64 = p59._destroy_these
            table.insert(v64, v63)
            local v65 = p60:WaitForChild(v63.Name):Clone()
            local v66 = p59._destroy_these
            table.insert(v66, v65)
            v65.Part1 = v63
            v65.Part0 = p59._humanoid.RootPart
            v65.Parent = p59._humanoid.RootPart
            for _, v67 in pairs(v63:GetDescendants()) do
                if v67:IsA("BasePart") then
                    v63.CanCollide = false
                    v63.CanTouch = false
                    v63.CanQuery = false
                    v63.Massless = true
                end
            end
            v63.CanCollide = false
            v63.CanTouch = false
            v63.CanQuery = false
            v63.Massless = true
            v63:PivotTo(p59._humanoid.RootPart.CFrame)
            v63.Parent = p59._humanoid.Parent
            for _, v68 in pairs(v63:GetDescendants()) do
                if v68:IsA("ParticleEmitter") then
                    v68:SetAttribute("IgnoreVisibilityCheck", true)
                end
            end
            table.insert(v61, v63)
        end
    end
    return table.unpack(v61)
end
function v_u_12._SetupMultipleProps(p69, ...)
    local v70 = { p69:_SetupProp(...) }
    local v71 = {}
    for _, v72 in pairs(v70) do
        local v73 = not v71[v72.Name]
        local v74 = v72.Name
        assert(v73, v74)
        v71[v72.Name] = v72
    end
    return v71
end
function v_u_12._PlayAnimation(p_u_75, p_u_76, p_u_77, p_u_78)
    if p_u_75:_CanPlayAnimation() then
        p_u_75:_InternalThread(task.spawn, function()
            local v79 = Instance.new("Animation")
            v79.AnimationId = p_u_76
            local v80 = p_u_75._destroy_these
            table.insert(v80, v79)
            if p_u_77 then
                task.spawn(pcall, v_u_2.PreloadAsync, v_u_2, { v79 })
                local v81 = Instance.new("Animation")
                v81.AnimationId = p_u_77
                local v82 = p_u_75._destroy_these
                table.insert(v82, v81)
                local v83, v84 = pcall(p_u_75._humanoid.LoadAnimation, p_u_75._humanoid, v81)
                if v83 then
                    local v85 = p_u_75._animation_tracks
                    table.insert(v85, v84)
                    v84:Play()
                end
                wait(p_u_78 - 0.04)
                if p_u_75._destroyed then
                    return
                end
            end
            local v86, v87 = pcall(p_u_75._humanoid.LoadAnimation, p_u_75._humanoid, v79)
            if v86 then
                local v88 = p_u_75._animation_tracks
                table.insert(v88, v87)
                v87:Play(p_u_77 and 0 or 0.1)
            end
        end)
    end
end
function v_u_12._InternalThread(p89, p_u_90, ...)
    local v_u_91 = nil
    if v_u_11 then
        v_u_91 = p_u_90(...)
    else
        pcall(function(...)
            v_u_91 = p_u_90(...)
        end, ...)
    end
    local v92 = p89._threads
    table.insert(v92, v_u_91)
    return v_u_91
end
function v_u_12._Init(p_u_93)
    local v94 = p_u_93._connections
    local v95 = p_u_93._humanoid.Destroying
    table.insert(v94, v95:Connect(function()
        p_u_93:Destroy()
    end))
end
return v_u_12