local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("CollectionService")
local v_u_3 = game:GetService("Players")
local v_u_4 = require(v1.Modules.CONSTANTS)
local v_u_5 = require(v1.Modules.Signal)
local v_u_6 = require(v_u_3.LocalPlayer.PlayerScripts.Controllers.ArcadeController)
local v_u_7 = require(v_u_3.LocalPlayer.PlayerScripts.Modules.LobbyElement)
local v_u_8 = setmetatable({}, v_u_7)
v_u_8.__index = v_u_8
function v_u_8._new(...)
    local v9 = v_u_7.new(...)
    local v10 = v_u_8
    local v11 = setmetatable(v9, v10)
    v11._update_garage_doors_internal = v_u_5.new()
    v11:_Init()
    return v11
end
function v_u_8._DoorAdded(p_u_12, p_u_13)
    local v_u_14 = p_u_13:WaitForChild("Door")
    local v_u_15 = p_u_13:WaitForChild("ArcadePortal")
    if v_u_4.QUEUES_ACTIVE then
        task.defer(v_u_15.Destroy, v_u_15)
    else
        local v16 = v_u_15:WaitForChild("Portal")
        local v17 = v16:WaitForChild("Hitbox")
        v16:PivotTo(v_u_15:WaitForChild("Anchor").CFrame)
        local v18 = v16:WaitForChild("Model"):WaitForChild("UnanchorMe")
        local v19 = v18:Clone()
        v19:PivotTo(v18:GetPivot())
        v19.Parent = v18.Parent
        v18.Parent = nil
        for _, v20 in pairs(v19:GetDescendants()) do
            if v20:IsA("BasePart") and not v20:HasTag("DontUnanchorMe") then
                v20.Anchored = false
            end
        end
        local function v22()
            local v21 = v_u_6.CurrentDuel
            if v21 then
                v21 = v_u_6.CurrentDuel:Get("Status") ~= "GameOver"
            end
            v_u_14:PivotTo(p_u_12:_GetOriginalPivot(v_u_14) + (v21 and Vector3.new(0, 0, 0) or Vector3.new(0, -21.75, 0)))
            v_u_15.Parent = v21 and p_u_13 or nil
        end
        p_u_12._update_garage_doors_internal:Connect(v22)
        local v23 = v_u_6.CurrentDuel
        if v23 then
            v23 = v_u_6.CurrentDuel:Get("Status") ~= "GameOver"
        end
        v_u_14:PivotTo(p_u_12:_GetOriginalPivot(v_u_14) + (v23 and Vector3.new(0, 0, 0) or Vector3.new(0, -21.75, 0)))
        v_u_15.Parent = v23 and p_u_13 and p_u_13 or nil
        v17.Touched:Connect(function(p24)
            if v_u_3:GetPlayerFromCharacter(p24.Parent) == v_u_3.LocalPlayer then
                v_u_6:Join()
            end
        end)
    end
end
function v_u_8._ClientDuelAdded(p_u_25, p26)
    p26:GetDataChangedSignal("Status"):Connect(function()
        p_u_25._update_garage_doors_internal:Fire()
    end)
    p_u_25._update_garage_doors_internal:Fire()
end
function v_u_8._Init(p_u_27)
    v_u_2:GetInstanceAddedSignal("LobbyDuelsGarageDoor"):Connect(function(p28)
        p_u_27:_DoorAdded(p28)
    end)
    v_u_6.DuelSet:Connect(function(p29)
        if v_u_6.CurrentDuel then
            p_u_27:_ClientDuelAdded(p29)
        else
            p_u_27._update_garage_doors_internal:Fire()
        end
    end)
    if v_u_6.CurrentDuel then
        task.defer(p_u_27._ClientDuelAdded, p_u_27, v_u_6.CurrentDuel)
    end
    for _, v30 in pairs(v_u_2:GetTagged("LobbyDuelsGarageDoor")) do
        task.defer(p_u_27._DoorAdded, p_u_27, v30)
    end
end
return v_u_8._new()