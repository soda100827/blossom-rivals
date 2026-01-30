local v_u_1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("Players")
local v_u_3 = require(v_u_1.Modules.EventLibrary)
local v_u_4 = require(v_u_1.Modules.ServerOsTime)
local v_u_5 = require(v_u_1.Modules.Utility)
local v_u_6 = require(v_u_2.LocalPlayer.PlayerScripts.Controllers.PlayerDataController)
local v_u_7 = v_u_2.LocalPlayer.PlayerScripts.Assets.Misc.ToyTrain
local v_u_8 = {}
v_u_8.__index = v_u_8
function v_u_8.new(p9)
    local v10 = v_u_8
    local v11 = setmetatable({}, v10)
    v11.Model = p9
    v11._connections = {}
    v11._num_paths = v11.Model:GetAttribute("NumPaths")
    v11._paths = {}
    v11._path_to_running_total_length = {}
    v11._length = 0
    v11._padding = 0
    v11._speed = 0
    v11._progress = v_u_4:Get()
    v11._tick = v11._progress
    v11._num_trains = 0
    v11._trains = {}
    v11._train_sizes = {}
    v11._train_attachments = {}
    v11._train_attachment_positions = {}
    v11._train_attacheds = {}
    v11._event_gifts = {}
    v11._claim_event_gift_cooldown = 0
    v11._sound_cooldown = tick() + 15
    v11:_Init()
    return v11
end
function v_u_8.GetCFrame(p12, p13)
    local v14 = p13 % 1
    for v15 = 1, p12._num_paths do
        local v16 = v15 == 1 and 0 or p12._path_to_running_total_length[v15 - 1]
        local v17 = p12._path_to_running_total_length[v15]
        if v14 >= v16 and v17 >= v14 then
            local v18 = p12._paths[v15]
            return v18.Start.WorldPosition:Lerp(v18.Finish.WorldPosition, (v14 - v16) / (v17 - v16)), CFrame.new(v18.Start.WorldPosition, v18.Finish.WorldPosition).Rotation
        end
    end
    return CFrame.identity
end
function v_u_8.Update(p19, p20)
    p19._tick = p19._tick + p20
    p19._progress = p19._progress + p19._speed * p20
    for v21, v22 in pairs(p19._trains) do
        local v23, v24 = p19:GetCFrame(p19._progress - p19._padding * (v21 - 1))
        local v25 = CFrame.new(v23) * v22:GetPivot().Rotation:Lerp(v24, 0.1)
        local v26 = p19._tick % p19._num_trains + 1
        local v27
        if v21 <= v26 and v26 <= v21 + 1 then
            local v28 = 6.283185307179586 * p19._tick
            v27 = math.sin(v28)
        else
            v27 = 0
        end
        local v29 = v27 * (v27 < 0 and 0.25 or 1)
        local v30 = v29 * 1
        local v31 = p19._train_sizes[v21]
        local v32 = v29 * -0.5
        local v33 = v29 * -0.5
        v22.Size = v31 + Vector3.new(v32, v30, v33)
        local v34 = v30 / 2
        v22:PivotTo(v25 + Vector3.new(0, v34, 0))
        if p19._train_attachments[v21] then
            p19._train_attachments[v21].Position = p19._train_attachment_positions[v21] + Vector3.new(0, v30, 0)
            p19._train_attacheds[v21]:PivotTo(p19._train_attachments[v21].WorldCFrame)
        end
        if v21 == 1 and tick() > p19._sound_cooldown then
            p19._sound_cooldown = tick() + 20 + 20 * math.random()
            v_u_5:CreateSound("rbxassetid://106675250798882", 0.25, 1, v22, true, 5)
            task.delay(0.4, v_u_5.CreateSound, v_u_5, "rbxassetid://114399683675542", 0.25, 1, v22, true, 5)
        end
    end
end
function v_u_8.Destroy(p35)
    for _, v36 in pairs(p35._connections) do
        v36:Disconnect()
    end
    p35._connections = {}
    p35.Model:Destroy()
end
function v_u_8._UpdateEventGiftEnabled(p37)
    for v38, v39 in pairs(p37._event_gifts) do
        local v40
        if v_u_4:Get() < v_u_6:Get("LastEventGiftClaimed") + v_u_3.EVENT_GIFT_COOLDOWN then
            v40 = nil
        else
            v40 = p37._trains[v38]
        end
        v39.Parent = v40
    end
end
function v_u_8._Setup(p_u_41)
    for v42 = 1, p_u_41._num_paths do
        local v43 = p_u_41.Model:WaitForChild(v42)
        local v44 = v43.Start
        local v45 = v43.Size.X / 2
        v44.Position = Vector3.new(v45, 0, 0)
        local v46 = v43.Finish
        local v47 = -v43.Size.X / 2
        v46.Position = Vector3.new(v47, 0, 0)
        p_u_41._paths[v42] = v43
        p_u_41._length = p_u_41._length + (p_u_41._paths[v42].Finish.Position - p_u_41._paths[v42].Start.Position).Magnitude
        p_u_41._path_to_running_total_length[v42] = p_u_41._length
        v43.Transparency = 1
    end
    for v48, v49 in pairs(p_u_41._path_to_running_total_length) do
        p_u_41._path_to_running_total_length[v48] = v49 / p_u_41._length
    end
    p_u_41._padding = 8 / p_u_41._length
    p_u_41._speed = 4 / p_u_41._length
    local v50 = v_u_7:Clone()
    p_u_41._num_trains = v50:GetAttribute("NumTrains")
    for v51 = 1, p_u_41._num_trains do
        local v52 = v50:WaitForChild(v51)
        p_u_41._trains[v51] = v52
        p_u_41._train_sizes[v51] = v52.Size
        local v53 = v52:FindFirstChild("Attachment")
        local v54 = v52:FindFirstChild("Attached")
        if v53 and v54 then
            p_u_41._train_attachments[v51] = v53
            p_u_41._train_attachment_positions[v51] = v53.Position
            p_u_41._train_attacheds[v51] = v54
            if v54:GetAttribute("IsEventGift") then
                p_u_41._event_gifts[v51] = v54
                v54.Hitbox.Touched:Connect(function(p55)
                    if v_u_2:GetPlayerFromCharacter(p55.Parent) == v_u_2.LocalPlayer and tick() > p_u_41._claim_event_gift_cooldown then
                        p_u_41._claim_event_gift_cooldown = tick() + 3
                        v_u_1.Remotes.Misc.ClaimEventGift:FireServer()
                    end
                end)
            end
        end
    end
    v50.Parent = p_u_41.Model
end
function v_u_8._Init(p_u_56)
    local v57 = p_u_56._connections
    local v58 = v_u_6:GetDataChangedSignal("LastEventGiftClaimed")
    table.insert(v57, v58:Connect(function()
        p_u_56:_UpdateEventGiftEnabled()
    end))
    p_u_56:_Setup()
    task.defer(p_u_56._UpdateEventGiftEnabled, p_u_56)
end
return v_u_8